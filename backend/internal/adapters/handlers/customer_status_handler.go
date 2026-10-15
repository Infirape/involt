package handlers

import (
	"context"
	"errors"
	"fmt"
	"time"

	"connectrpc.com/connect"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

var serviceStatuses = map[domain.ServiceStatus]involtv1.ServiceStatus{
	domain.ServiceActive:       involtv1.ServiceStatus_SERVICE_STATUS_ACTIVE,
	domain.ServiceTemporaryCut: involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT,
	domain.ServiceNoPower:      involtv1.ServiceStatus_SERVICE_STATUS_NO_POWER,
}

// serviceStatusToProto maps a stored status; empty (older rows) counts as active.
func serviceStatusToProto(raw string) involtv1.ServiceStatus {
	if raw == "" {
		return involtv1.ServiceStatus_SERVICE_STATUS_ACTIVE
	}
	return serviceStatuses[domain.ServiceStatus(raw)]
}

func serviceStatusFromProto(s involtv1.ServiceStatus) (domain.ServiceStatus, bool) {
	for d, p := range serviceStatuses {
		if p == s {
			return d, true
		}
	}
	return "", false
}

// serviceStatusFilter turns an optional proto filter into the repository's string filter.
func serviceStatusFilter(s involtv1.ServiceStatus) string {
	d, _ := serviceStatusFromProto(s)
	return string(d)
}

// SetCustomerServiceStatus changes a supply's service status. Admins only; a reason is required.
func (h *AdminHandler) SetCustomerServiceStatus(
	ctx context.Context,
	req *connect.Request[involtv1.SetCustomerServiceStatusRequest],
) (*connect.Response[involtv1.SetCustomerServiceStatusResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok || user.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can change the service status"))
	}
	status, ok := serviceStatusFromProto(req.Msg.Status)
	if !ok {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("a valid service status is required"))
	}
	if _, _, err := h.authorizeCustomer(ctx, req.Msg.CustomerId); err != nil {
		return nil, err
	}
	_, err := h.statusRepo.SetStatus(ctx, req.Msg.CustomerId, status, req.Msg.Reason, user.ID, user.Email)
	if errors.Is(err, domain.ErrInvalidServiceStatus) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	}
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	customer, err := h.customerRepo.GetByID(ctx, req.Msg.CustomerId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&involtv1.SetCustomerServiceStatusResponse{Customer: domain.MapCustomerToProto(customer)}), nil
}

// GetCustomerStatusHistory lists a supply's status changes, newest first.
func (h *AdminHandler) GetCustomerStatusHistory(
	ctx context.Context,
	req *connect.Request[involtv1.GetCustomerStatusHistoryRequest],
) (*connect.Response[involtv1.GetCustomerStatusHistoryResponse], error) {
	if _, _, err := h.authorizeCustomer(ctx, req.Msg.CustomerId); err != nil {
		return nil, err
	}
	history, err := h.statusRepo.History(ctx, req.Msg.CustomerId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	resp := &involtv1.GetCustomerStatusHistoryResponse{}
	for _, c := range history {
		resp.Changes = append(resp.Changes, &involtv1.ServiceStatusChange{
			PreviousStatus: serviceStatusToProto(c.PreviousStatus), Status: serviceStatusToProto(c.Status),
			Reason: c.Reason, ChangedByEmail: c.ChangedByEmail, ChangedAt: c.ChangedAt.Format(time.RFC3339),
		})
	}
	return connect.NewResponse(resp), nil
}
