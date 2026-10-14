package handlers

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"

	"connectrpc.com/connect"
	"github.com/google/uuid"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

// GetCustomerAccount returns every receipt of a customer with its balance plus the payment history.
func (h *AdminHandler) GetCustomerAccount(
	ctx context.Context,
	req *connect.Request[involtv1.GetCustomerAccountRequest],
) (*connect.Response[involtv1.GetCustomerAccountResponse], error) {
	_, customer, err := h.authorizeCustomer(ctx, req.Msg.CustomerId)
	if err != nil {
		return nil, err
	}

	readings, err := h.readingRepo.ListByCustomer(ctx, customer.ID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	paid, err := h.paymentRepo.PaidAmounts(ctx, readingIDs(readings))
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	payments, err := h.paymentRepo.List(ctx, ports.PaymentFilter{CustomerID: customer.ID, IncludeVoided: true})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &involtv1.GetCustomerAccountResponse{
		Customer: domain.MapCustomerToProto(customer),
		Receipts: buildReceiptBalances(readings, paid, h.now()),
	}
	var debtCents int64
	for _, r := range resp.Receipts {
		debtCents += int64(r.Balance*100 + 0.5)
		if r.Status == involtv1.ReceiptStatus_RECEIPT_STATUS_OVERDUE {
			resp.OverdueCount++
		}
	}
	resp.TotalDebt = float64(debtCents) / 100
	for i := range payments {
		resp.Payments = append(resp.Payments, mapPaymentToProto(&payments[i]))
	}
	return connect.NewResponse(resp), nil
}

// RegisterPayment records a payment, applying it to the oldest outstanding receipts first.
func (h *AdminHandler) RegisterPayment(
	ctx context.Context,
	req *connect.Request[involtv1.RegisterPaymentRequest],
) (*connect.Response[involtv1.RegisterPaymentResponse], error) {
	if req.Msg.Amount <= 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, domain.ErrInvalidPaymentAmount)
	}
	method, ok := paymentMethodFromProto(req.Msg.Method)
	if !ok {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("unknown payment method %v", req.Msg.Method))
	}
	user, customer, err := h.authorizeCustomer(ctx, req.Msg.CustomerId)
	if err != nil {
		return nil, err
	}

	payment, err := h.recordPayment(ctx, user, customer, req.Msg.ReadingIds, req.Msg.Amount, method, req.Msg.Reference, req.Msg.Observation)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&involtv1.RegisterPaymentResponse{Payment: mapPaymentToProto(payment)}), nil
}

// recordPayment allocates the amount over the customer's outstanding receipts and persists it.
func (h *AdminHandler) recordPayment(
	ctx context.Context,
	user *auth.UserContext,
	customer *domain.Customer,
	onlyReadingIDs []string,
	amount float64,
	method domain.PaymentMethod,
	reference, observation string,
) (*domain.Payment, error) {
	debts, err := h.outstandingDebts(ctx, customer.ID, onlyReadingIDs)
	if err != nil {
		return nil, err
	}
	allocations, err := domain.AllocatePayment(amount, debts)
	switch {
	case errors.Is(err, domain.ErrPaymentExceedsDebt):
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	case err != nil:
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	payment := &domain.Payment{
		ID:               uuid.New().String(),
		CustomerID:       customer.ID,
		CustomerName:     customer.Name,
		CustomerCode:     customer.Code,
		Amount:           amount,
		Method:           string(method),
		Reference:        strings.TrimSpace(reference),
		Observation:      strings.TrimSpace(observation),
		CollectedBy:      user.ID,
		CollectedByEmail: user.Email,
		Allocations:      allocations,
	}
	if err := h.paymentRepo.Create(ctx, payment); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	if stored, err := h.paymentRepo.GetByID(ctx, payment.ID); err == nil {
		payment = stored
	}
	return payment, nil
}

// VoidPayment annuls a payment; only admins and supervisors may do it, and a reason is mandatory.
func (h *AdminHandler) VoidPayment(
	ctx context.Context,
	req *connect.Request[involtv1.VoidPaymentRequest],
) (*connect.Response[involtv1.VoidPaymentResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok || !canManagePayments(user) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins or supervisors can void payments"))
	}
	reason := strings.TrimSpace(req.Msg.Reason)
	if req.Msg.PaymentId == "" || reason == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("payment_id and reason are required"))
	}

	err := h.paymentRepo.Void(ctx, req.Msg.PaymentId, user.ID, reason)
	switch {
	case errors.Is(err, domain.ErrPaymentNotFound):
		return nil, connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, domain.ErrPaymentAlreadyVoided):
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	case err != nil:
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	payment, err := h.paymentRepo.GetByID(ctx, req.Msg.PaymentId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&involtv1.VoidPaymentResponse{Payment: mapPaymentToProto(payment)}), nil
}

// CreateFlatCharge bills a period without meter reading with the fixed fee from settings.
func (h *AdminHandler) CreateFlatCharge(
	ctx context.Context,
	req *connect.Request[involtv1.CreateFlatChargeRequest],
) (*connect.Response[involtv1.CreateFlatChargeResponse], error) {
	if _, _, err := h.authorizeCustomer(ctx, req.Msg.CustomerId); err != nil {
		return nil, err
	}
	reading, err := h.createFlatCharge(ctx, req.Msg.CustomerId, req.Msg.Period, req.Msg.Amount, req.Msg.Observation)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&involtv1.CreateFlatChargeResponse{Reading: domain.MapReadingToProto(reading)}), nil
}

func (h *AdminHandler) createFlatCharge(ctx context.Context, customerID, period string, amount float64, observation string) (*domain.Reading, error) {
	if amount < 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("amount cannot be negative"))
	}
	existing, err := h.readingRepo.GetByCustomerAndPeriod(ctx, customerID, period)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	if existing != nil {
		return nil, connect.NewError(connect.CodeAlreadyExists, fmt.Errorf("period %s is already billed for this customer", period))
	}
	settings, err := h.metaRepo.GetSettings(ctx)
	if err != nil || settings == nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to load settings: %w", err))
	}
	start, end, expiration, err := domain.BillingDatesForPeriod(period, settings.DiasVencimiento)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	reading := &domain.Reading{
		ID:             uuid.New().String(),
		CustomerID:     customerID,
		Timestamp:      h.now(),
		Period:         period,
		PeriodStart:    start,
		PeriodEnd:      end,
		ExpirationDate: expiration,
		Observation:    strings.TrimSpace(observation),
	}
	if amount > 0 {
		reading.CargoFijo = amount
	} else {
		reading.CargoFijo = settings.CargoFijo
		reading.AlumbradoPublico = settings.Alumbrado
		reading.Mantenimiento = settings.Mantenimiento
	}
	reading.Subtotal = reading.CargoFijo + reading.AlumbradoPublico + reading.Mantenimiento
	reading.TotalToPay = reading.Subtotal
	if reading.TotalToPay <= 0 {
		return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("fixed fee is zero; configure cargo fijo or send an amount"))
	}

	if err := h.readingRepo.Save(ctx, reading); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return reading, nil
}

// authorizeCustomer loads the customer and checks the caller can operate on its sector.
func (h *AdminHandler) authorizeCustomer(ctx context.Context, customerID string) (*auth.UserContext, *domain.Customer, error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("authentication required"))
	}
	if customerID == "" {
		return nil, nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("customer_id is required"))
	}
	customer, err := h.customerRepo.GetByID(ctx, customerID)
	if errors.Is(err, sql.ErrNoRows) || (err == nil && customer == nil) {
		return nil, nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("customer %s not found", customerID))
	}
	if err != nil {
		return nil, nil, connect.NewError(connect.CodeInternal, err)
	}
	if !canAccessSector(user, customer.SectorID) {
		return nil, nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("sector not assigned"))
	}
	return user, customer, nil
}

// outstandingDebts returns the balances of the customer's receipts, optionally limited to readingIDs.
func (h *AdminHandler) outstandingDebts(ctx context.Context, customerID string, onlyIDs []string) ([]domain.Debt, error) {
	readings, err := h.readingRepo.ListByCustomer(ctx, customerID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	byID := make(map[string]domain.Reading, len(readings))
	for _, r := range readings {
		byID[r.ID] = r
	}
	if len(onlyIDs) > 0 {
		selected := make([]domain.Reading, 0, len(onlyIDs))
		for _, id := range onlyIDs {
			r, ok := byID[id]
			if !ok {
				return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("receipt %s does not belong to this customer", id))
			}
			selected = append(selected, r)
		}
		readings = selected
	}

	paid, err := h.paymentRepo.PaidAmounts(ctx, readingIDs(readings))
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	debts := make([]domain.Debt, 0, len(readings))
	for _, r := range readings {
		debts = append(debts, domain.Debt{
			ReadingID: r.ID,
			Period:    r.EffectivePeriod(),
			Balance:   domain.ReceiptBalance(r.TotalToPay, paid[r.ID]),
		})
	}
	return debts, nil
}
