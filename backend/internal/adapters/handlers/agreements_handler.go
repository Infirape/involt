package handlers

import (
	"context"
	"fmt"
	"sort"
	"strings"
	"time"

	"connectrpc.com/connect"
	"github.com/google/uuid"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

// agreementPlan is a computed (not yet saved) agreement. validation holds a business-rule
// violation that Preview reports as text and Create returns as an error.
type agreementPlan struct {
	user         *auth.UserContext
	customer     *domain.Customer
	policy       domain.CollectionPolicy
	receipts     []domain.AgreementReceipt
	principal    float64
	fees         float64
	total        float64
	minInitial   float64
	installments []domain.Installment
	validation   error
}

func (h *AdminHandler) planAgreement(ctx context.Context, req *involtv1.AgreementRequest) (*agreementPlan, error) {
	user, customer, err := h.authorizeCustomer(ctx, req.CustomerId)
	if err != nil {
		return nil, err
	}
	readings, err := h.readingRepo.ListByCustomer(ctx, customer.ID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	state, err := h.loadCollectionState(ctx, []string{customer.ID}, readings)
	if err != nil {
		return nil, err
	}
	plan := &agreementPlan{user: user, customer: customer, policy: state.policy}

	selected, err := selectAgreementReadings(readings, req.ReadingIds, state)
	if err != nil {
		return nil, err
	}
	waive := state.policy.Agreement.WaiveLateFees
	var principalC, feeC int64
	for i := range selected {
		r := &selected[i]
		rc := domain.AgreementReceipt{ReadingID: r.ID, Period: r.EffectivePeriod(), Principal: state.balance(r)}
		if !waive {
			rc.LateFee = state.lateFee(r)
		}
		principalC += toCentsRounded(rc.Principal)
		feeC += toCentsRounded(rc.LateFee)
		plan.receipts = append(plan.receipts, rc)
	}
	plan.principal, plan.fees = float64(principalC)/100, float64(feeC)/100
	plan.total = float64(principalC+feeC) / 100
	plan.minInitial = roundCents(plan.total * state.policy.Agreement.MinInitialPercent / 100)

	if len(plan.receipts) == 0 {
		plan.validation = fmt.Errorf("%w: no outstanding receipts to include", domain.ErrInvalidAgreement)
		if len(state.activeBy) > 0 {
			plan.validation = fmt.Errorf("%w: all outstanding receipts are already in an agreement", domain.ErrReceiptInAgreement)
		}
		return plan, nil
	}
	if conflict := receiptsInActiveAgreement(selected, state); conflict != "" {
		plan.validation = fmt.Errorf("%w: %s", domain.ErrReceiptInAgreement, conflict)
		return plan, nil
	}
	firstDue, err := firstDueDate(req.FirstDueDate, h.now())
	if err != nil {
		plan.validation = err
		return plan, nil
	}
	if plan.validation = state.policy.Agreement.CheckRequest(plan.total, req.InitialAmount, int(req.Installments)); plan.validation != nil {
		return plan, nil
	}
	plan.installments, plan.validation = domain.BuildInstallments(plan.total, req.InitialAmount, int(req.Installments), firstDue)
	return plan, nil
}

// selectAgreementReadings returns the requested receipts (or every outstanding one), oldest first.
func selectAgreementReadings(readings []domain.Reading, ids []string, state *collectionState) ([]domain.Reading, error) {
	var selected []domain.Reading
	if len(ids) == 0 {
		for _, r := range readings {
			if _, inAgreement := state.activeBy[r.ID]; state.balance(&r) > 0 && !inAgreement {
				selected = append(selected, r)
			}
		}
	} else {
		byID := make(map[string]domain.Reading, len(readings))
		for _, r := range readings {
			byID[r.ID] = r
		}
		for _, id := range ids {
			r, ok := byID[id]
			if !ok {
				return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("receipt %s does not belong to this customer", id))
			}
			if state.balance(&r) > 0 {
				selected = append(selected, r)
			}
		}
	}
	sort.SliceStable(selected, func(i, j int) bool { return selected[i].EffectivePeriod() < selected[j].EffectivePeriod() })
	return selected, nil
}

func receiptsInActiveAgreement(readings []domain.Reading, state *collectionState) string {
	for _, r := range readings {
		if a, ok := state.activeBy[r.ID]; ok {
			return fmt.Sprintf("receipt %s is in agreement N° %d", r.EffectivePeriod(), a.Number)
		}
	}
	return ""
}

func firstDueDate(raw string, now time.Time) (time.Time, error) {
	if raw == "" {
		next := time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, time.UTC).AddDate(0, 1, 0)
		return time.Date(next.Year(), next.Month(), min(now.Day(), 28), 0, 0, 0, 0, time.UTC), nil
	}
	d, err := time.Parse("2006-01-02", raw)
	if err != nil {
		return time.Time{}, fmt.Errorf("%w: first_due_date must be YYYY-MM-DD", domain.ErrInvalidAgreement)
	}
	return d, nil
}

// PreviewAgreement computes totals and the schedule without saving anything.
func (h *AdminHandler) PreviewAgreement(
	ctx context.Context,
	req *connect.Request[involtv1.AgreementRequest],
) (*connect.Response[involtv1.PreviewAgreementResponse], error) {
	plan, err := h.planAgreement(ctx, req.Msg)
	if err != nil {
		return nil, err
	}
	resp := &involtv1.PreviewAgreementResponse{
		Total: plan.total, Principal: plan.principal, LateFees: plan.fees,
		MinInitialAmount: plan.minInitial, MaxInstallments: int32(plan.policy.Agreement.MaxInstallments),
		LateFeesWaived: plan.policy.Agreement.WaiveLateFees,
		Receipts:       mapAgreementReceipts(plan.receipts),
		Installments:   mapInstallments(plan.installments, 0),
	}
	if plan.validation != nil {
		resp.ValidationError = plan.validation.Error()
	}
	return connect.NewResponse(resp), nil
}

// CreateAgreement signs the agreement, waives mora if the policy says so and collects the
// initial payment. If the initial payment fails the agreement is cancelled again.
func (h *AdminHandler) CreateAgreement(
	ctx context.Context,
	req *connect.Request[involtv1.AgreementRequest],
) (*connect.Response[involtv1.CreateAgreementResponse], error) {
	plan, err := h.planAgreement(ctx, req.Msg)
	if err != nil {
		return nil, err
	}
	if plan.validation != nil {
		return nil, agreementError(plan.validation)
	}
	method, ok := paymentMethodFromProto(involtv1.PaymentMethod(req.Msg.InitialPaymentMethod))
	if !ok {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("unknown payment method"))
	}

	a := &domain.Agreement{
		ID: uuid.New().String(), CustomerID: plan.customer.ID, Total: plan.total,
		InitialAmount: req.Msg.InitialAmount, Notes: strings.TrimSpace(req.Msg.Notes),
		LateFeesWaived: plan.policy.Agreement.WaiveLateFees,
		CreatedBy:      plan.user.ID, CreatedByEmail: plan.user.Email,
		Receipts: plan.receipts, Installments: plan.installments,
	}
	if err := h.agreementRepo.Create(ctx, a); err != nil {
		return nil, agreementError(err)
	}

	ids := make([]string, len(a.Receipts))
	waivers := make([]ports.LateFeeWaiver, len(a.Receipts))
	for i, rc := range a.Receipts {
		ids[i] = rc.ReadingID
		waivers[i] = ports.LateFeeWaiver{ReadingID: rc.ReadingID, AgreementID: a.ID, WaivedBy: plan.user.ID,
			WaivedByEmail: plan.user.Email, Reason: fmt.Sprintf("Condonada por convenio N° %d", a.Number)}
	}
	if a.LateFeesWaived {
		if err := h.agreementRepo.Waive(ctx, waivers); err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
	}

	resp := &involtv1.CreateAgreementResponse{}
	if a.InitialAmount > 0 {
		payment, err := h.recordPayment(ctx, plan.user, plan.customer, ids, a.InitialAmount, method,
			req.Msg.InitialPaymentReference, fmt.Sprintf("Cuota inicial del convenio N° %d", a.Number))
		if err != nil {
			_ = h.agreementRepo.Cancel(ctx, a.ID, plan.user.ID, "Cuota inicial no registrada")
			return nil, err
		}
		resp.InitialPaymentId = payment.ID
	}

	stored, err := h.agreementRepo.GetByID(ctx, a.ID)
	if err != nil {
		return nil, agreementError(err)
	}
	resp.Agreement = h.mapAgreementToProto(stored, plan.policy)
	return connect.NewResponse(resp), nil
}

// CancelAgreement cancels an active agreement; its receipts go back to normal collection.
func (h *AdminHandler) CancelAgreement(
	ctx context.Context,
	req *connect.Request[involtv1.CancelAgreementRequest],
) (*connect.Response[involtv1.CancelAgreementResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok || !canManagePayments(user) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins or supervisors can cancel agreements"))
	}
	reason := strings.TrimSpace(req.Msg.Reason)
	if req.Msg.AgreementId == "" || reason == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("agreement_id and reason are required"))
	}
	existing, err := h.agreementRepo.GetByID(ctx, req.Msg.AgreementId)
	if err != nil {
		return nil, agreementError(err)
	}
	if _, _, err := h.authorizeCustomer(ctx, existing.CustomerID); err != nil {
		return nil, err
	}
	if err := h.agreementRepo.Cancel(ctx, existing.ID, user.ID, reason); err != nil {
		return nil, agreementError(err)
	}
	cancelled, err := h.agreementRepo.GetByID(ctx, existing.ID)
	if err != nil {
		return nil, agreementError(err)
	}
	policy, err := h.collectionPolicy(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&involtv1.CancelAgreementResponse{Agreement: h.mapAgreementToProto(cancelled, policy)}), nil
}

// customerAgreements lists every agreement of a customer (any status), newest first.
func (h *AdminHandler) customerAgreements(ctx context.Context, customerID string, state *collectionState) ([]*involtv1.PaymentAgreement, error) {
	if h.agreementRepo == nil {
		return nil, nil
	}
	list, err := h.agreementRepo.List(ctx, []string{customerID}, false)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	out := make([]*involtv1.PaymentAgreement, 0, len(list))
	for i := range list {
		out = append(out, h.mapAgreementToProto(&list[i], state.policy))
	}
	return out, nil
}
