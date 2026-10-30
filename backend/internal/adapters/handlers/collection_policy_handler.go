package handlers

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

var lateFeeModes = map[domain.LateFeeMode]involtv1.LateFeeMode{
	domain.LateFeeNone:            involtv1.LateFeeMode_LATE_FEE_MODE_NONE,
	domain.LateFeeFixed:           involtv1.LateFeeMode_LATE_FEE_MODE_FIXED,
	domain.LateFeePercent:         involtv1.LateFeeMode_LATE_FEE_MODE_PERCENT,
	domain.LateFeeMonthlyInterest: involtv1.LateFeeMode_LATE_FEE_MODE_MONTHLY_INTEREST,
}

func mapPolicyToProto(p domain.CollectionPolicy) *involtv1.CollectionPolicy {
	out := &involtv1.CollectionPolicy{
		LateFeeMode:                lateFeeModes[p.LateFee.Mode],
		LateFeeValue:               p.LateFee.Value,
		AgreementMaxInstallments:   int32(p.Agreement.MaxInstallments),
		AgreementMinInitialPercent: p.Agreement.MinInitialPercent,
		AgreementGraceDays:         int32(p.Agreement.GraceDays),
		AgreementWaiveLateFees:     p.Agreement.WaiveLateFees,
		UpdatedBy:                  p.UpdatedBy,
	}
	if !p.LateFee.StartDate.IsZero() {
		out.LateFeeStartDate = p.LateFee.StartDate.Format("2006-01-02")
	}
	if !p.UpdatedAt.IsZero() {
		out.UpdatedAt = p.UpdatedAt.Format(time.RFC3339)
	}
	return out
}

func mapPolicyFromProto(p *involtv1.CollectionPolicy) (domain.CollectionPolicy, error) {
	out := domain.CollectionPolicy{
		LateFee: domain.LateFeePolicy{Mode: domain.LateFeeNone, Value: p.GetLateFeeValue()},
		Agreement: domain.AgreementPolicy{
			MaxInstallments:   int(p.GetAgreementMaxInstallments()),
			MinInitialPercent: p.GetAgreementMinInitialPercent(),
			GraceDays:         int(p.GetAgreementGraceDays()),
			WaiveLateFees:     p.GetAgreementWaiveLateFees(),
		},
	}
	for mode, proto := range lateFeeModes {
		if proto == p.GetLateFeeMode() {
			out.LateFee.Mode = mode
		}
	}
	if raw := p.GetLateFeeStartDate(); raw != "" {
		d, err := time.Parse("2006-01-02", raw)
		if err != nil {
			return out, fmt.Errorf("%w: late_fee_start_date must be YYYY-MM-DD", domain.ErrInvalidPolicy)
		}
		out.LateFee.StartDate = d
	}
	return out, out.Validate()
}

// GetCollectionPolicy returns the mora and agreement rules; cashiers need them too.
func (h *AdminHandler) GetCollectionPolicy(
	ctx context.Context,
	_ *connect.Request[involtv1.GetCollectionPolicyRequest],
) (*connect.Response[involtv1.GetCollectionPolicyResponse], error) {
	if _, ok := auth.GetUserFromContext(ctx); !ok {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("authentication required"))
	}
	policy, err := h.collectionPolicy(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&involtv1.GetCollectionPolicyResponse{Policy: mapPolicyToProto(policy)}), nil
}

// UpdateCollectionPolicy changes the mora and agreement rules (admin only).
func (h *AdminHandler) UpdateCollectionPolicy(
	ctx context.Context,
	req *connect.Request[involtv1.UpdateCollectionPolicyRequest],
) (*connect.Response[involtv1.UpdateCollectionPolicyResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok || user.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can change the collection policy"))
	}
	policy, err := mapPolicyFromProto(req.Msg.GetPolicy())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	policy.UpdatedBy = user.Email
	if err := h.policyRepo.Save(ctx, &policy); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	saved, err := h.collectionPolicy(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&involtv1.UpdateCollectionPolicyResponse{Policy: mapPolicyToProto(saved)}), nil
}

// WaiveLateFee forgives the mora of receipts; admins and supervisors only, with a reason.
func (h *AdminHandler) WaiveLateFee(
	ctx context.Context,
	req *connect.Request[involtv1.WaiveLateFeeRequest],
) (*connect.Response[involtv1.WaiveLateFeeResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok || !canManagePayments(user) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins or supervisors can waive late fees"))
	}
	reason := strings.TrimSpace(req.Msg.Reason)
	if reason == "" || len(req.Msg.ReadingIds) == 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("reading_ids and reason are required"))
	}

	waivers := make([]ports.LateFeeWaiver, 0, len(req.Msg.ReadingIds))
	for _, id := range req.Msg.ReadingIds {
		reading, err := h.readingRepo.GetByID(ctx, id)
		if err != nil || reading == nil {
			return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("receipt %s not found", id))
		}
		if _, _, err := h.authorizeCustomer(ctx, reading.CustomerID); err != nil {
			return nil, err
		}
		waivers = append(waivers, ports.LateFeeWaiver{ReadingID: id, Reason: reason, WaivedBy: user.ID, WaivedByEmail: user.Email})
	}
	if err := h.agreementRepo.Waive(ctx, waivers); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&involtv1.WaiveLateFeeResponse{Waived: int32(len(waivers))}), nil
}

// agreementError maps domain agreement errors to RPC codes.
func agreementError(err error) error {
	switch {
	case errors.Is(err, domain.ErrAgreementNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, domain.ErrReceiptInAgreement), errors.Is(err, domain.ErrAgreementsDisabled):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	case errors.Is(err, domain.ErrInvalidAgreement):
		return connect.NewError(connect.CodeInvalidArgument, err)
	}
	var ce *connect.Error
	if errors.As(err, &ce) {
		return err
	}
	return connect.NewError(connect.CodeInternal, err)
}
