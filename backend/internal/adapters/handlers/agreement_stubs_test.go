package handlers

import (
	"context"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

type policyRepoStub struct{ policy domain.CollectionPolicy }

func (s *policyRepoStub) Get(context.Context) (*domain.CollectionPolicy, error) {
	p := s.policy
	return &p, nil
}

func (s *policyRepoStub) Save(_ context.Context, p *domain.CollectionPolicy) error {
	s.policy = *p
	return nil
}

// fakeAgreementRepo keeps agreements in memory; PaidSinceSigning is set by tests.
type fakeAgreementRepo struct {
	agreements []*domain.Agreement
	waivers    []ports.LateFeeWaiver
}

func (f *fakeAgreementRepo) Create(_ context.Context, a *domain.Agreement) error {
	for _, existing := range f.agreements {
		if existing.Status != domain.AgreementActive {
			continue
		}
		for _, r := range existing.Receipts {
			for _, n := range a.Receipts {
				if r.ReadingID == n.ReadingID {
					return domain.ErrReceiptInAgreement
				}
			}
		}
	}
	a.Number = int64(len(f.agreements) + 1)
	a.Status = domain.AgreementActive
	a.CreatedAt = fixedNow
	f.agreements = append(f.agreements, a)
	return nil
}

func (f *fakeAgreementRepo) GetByID(_ context.Context, id string) (*domain.Agreement, error) {
	for _, a := range f.agreements {
		if a.ID == id {
			return a, nil
		}
	}
	return nil, domain.ErrAgreementNotFound
}

func (f *fakeAgreementRepo) List(_ context.Context, customerIDs []string, onlyActive bool) ([]domain.Agreement, error) {
	var out []domain.Agreement
	for _, a := range f.agreements {
		if onlyActive && a.Status != domain.AgreementActive {
			continue
		}
		match := len(customerIDs) == 0
		for _, id := range customerIDs {
			match = match || id == a.CustomerID
		}
		if match {
			out = append(out, *a)
		}
	}
	return out, nil
}

func (f *fakeAgreementRepo) Cancel(_ context.Context, id, by, reason string) error {
	for _, a := range f.agreements {
		if a.ID == id {
			if a.Status != domain.AgreementActive {
				return domain.ErrInvalidAgreement
			}
			now := fixedNow
			a.Status, a.CancelledAt, a.CancelledBy, a.CancelReason = domain.AgreementCancelled, &now, by, reason
			return nil
		}
	}
	return domain.ErrAgreementNotFound
}

func (f *fakeAgreementRepo) Waive(_ context.Context, w []ports.LateFeeWaiver) error {
	f.waivers = append(f.waivers, w...)
	return nil
}

func (f *fakeAgreementRepo) WaivedReadings(context.Context, []string) (map[string]bool, error) {
	out := map[string]bool{}
	for _, w := range f.waivers {
		out[w.ReadingID] = true
	}
	return out, nil
}
