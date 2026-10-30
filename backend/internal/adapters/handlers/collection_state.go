package handlers

import (
	"context"
	"sort"
	"time"

	"connectrpc.com/connect"

	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// collectionState gathers everything needed to price receipts today: what was paid (principal
// and mora), the collection policy, waivers and the active agreements protecting receipts.
type collectionState struct {
	policy     domain.CollectionPolicy
	today      time.Time
	paid       map[string]float64
	feePaid    map[string]float64
	waived     map[string]bool
	agreements []domain.Agreement
	progress   map[string]domain.AgreementProgress // by agreement ID
	activeBy   map[string]*domain.Agreement        // reading ID → stored-ACTIVE agreement
	frozenFee  map[string]float64                  // reading ID → mora frozen at signing
}

var defaultCollectionPolicy = domain.CollectionPolicy{
	LateFee:   domain.LateFeePolicy{Mode: domain.LateFeeNone},
	Agreement: domain.AgreementPolicy{MaxInstallments: 12, GraceDays: 15, WaiveLateFees: true},
}

func (h *AdminHandler) collectionPolicy(ctx context.Context) (domain.CollectionPolicy, error) {
	if h.policyRepo == nil {
		return defaultCollectionPolicy, nil
	}
	p, err := h.policyRepo.Get(ctx)
	if err != nil {
		return domain.CollectionPolicy{}, connect.NewError(connect.CodeInternal, err)
	}
	return *p, nil
}

// loadCollectionState loads payments, waivers and active agreements for the given readings.
func (h *AdminHandler) loadCollectionState(ctx context.Context, customerIDs []string, readings []domain.Reading) (*collectionState, error) {
	policy, err := h.collectionPolicy(ctx)
	if err != nil {
		return nil, err
	}
	ids := readingIDs(readings)
	s := &collectionState{
		policy: policy, today: h.now(),
		waived: map[string]bool{}, progress: map[string]domain.AgreementProgress{},
		activeBy: map[string]*domain.Agreement{}, frozenFee: map[string]float64{},
	}
	if s.paid, err = h.paymentRepo.PaidAmounts(ctx, ids); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	if s.feePaid, err = h.paymentRepo.LateFeesPaid(ctx, ids); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	if h.agreementRepo == nil {
		return s, nil
	}
	if s.waived, err = h.agreementRepo.WaivedReadings(ctx, ids); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	if len(customerIDs) > 0 {
		if s.agreements, err = h.agreementRepo.List(ctx, customerIDs, true); err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
	}
	for i := range s.agreements {
		a := &s.agreements[i]
		prog := domain.ComputeAgreementProgress(*a, a.PaidSinceSigning, s.today, policy.Agreement.GraceDays)
		s.progress[a.ID] = prog
		for _, rc := range a.Receipts {
			s.activeBy[rc.ReadingID] = a
			if prog.ProtectsReceipts() {
				s.frozenFee[rc.ReadingID] = rc.LateFee
			}
		}
	}
	return s, nil
}

func (s *collectionState) balance(r *domain.Reading) float64 {
	return domain.ReceiptBalance(r.TotalToPay, s.paid[r.ID])
}

func (s *collectionState) protected(r *domain.Reading) bool {
	_, ok := s.frozenFee[r.ID]
	return ok
}

func (s *collectionState) lateFee(r *domain.Reading) float64 {
	var frozen *float64
	if f, ok := s.frozenFee[r.ID]; ok {
		frozen = &f
	}
	return domain.LateFeeOwed(s.policy.LateFee, s.balance(r), r.ExpirationDate, s.today, s.feePaid[r.ID], s.waived[r.ID], frozen)
}

func (s *collectionState) status(r *domain.Reading) domain.ReceiptStatus {
	if s.balance(r) > 0 && s.protected(r) {
		return domain.ReceiptStatusInAgreement
	}
	return domain.ComputeReceiptStatus(r.TotalToPay, s.paid[r.ID], r.ExpirationDate, s.today)
}

func (s *collectionState) debt(r *domain.Reading) domain.Debt {
	return domain.Debt{ReadingID: r.ID, Period: r.EffectivePeriod(), Balance: s.balance(r), LateFee: s.lateFee(r)}
}

func (s *collectionState) receiptBalance(r *domain.Reading) *involtv1.ReceiptBalance {
	rb := &involtv1.ReceiptBalance{
		Reading:       domain.MapReadingToProto(r),
		PaidAmount:    s.paid[r.ID],
		Balance:       s.balance(r),
		Status:        receiptStatusToProto(s.status(r)),
		LateFee:       s.lateFee(r),
		LateFeeWaived: s.waived[r.ID],
	}
	if a, ok := s.activeBy[r.ID]; ok {
		rb.AgreementId = a.ID
	}
	return rb
}

// receiptBalances maps readings to balances, oldest period first.
func (s *collectionState) receiptBalances(readings []domain.Reading) []*involtv1.ReceiptBalance {
	sorted := make([]domain.Reading, len(readings))
	copy(sorted, readings)
	sort.SliceStable(sorted, func(i, j int) bool { return sorted[i].EffectivePeriod() < sorted[j].EffectivePeriod() })
	out := make([]*involtv1.ReceiptBalance, 0, len(sorted))
	for i := range sorted {
		out = append(out, s.receiptBalance(&sorted[i]))
	}
	return out
}
