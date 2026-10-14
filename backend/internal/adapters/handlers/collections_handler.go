package handlers

import (
	"context"
	"fmt"
	"math"

	"connectrpc.com/connect"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// TogglePaymentStatus is kept for older clients. Marking as paid registers a cash payment for the
// receipt's outstanding balance (creating a flat charge if the period has no reading); un-paying is
// no longer allowed because it would erase the audit trail — use VoidPayment instead.
func (h *AdminHandler) TogglePaymentStatus(
	ctx context.Context,
	req *connect.Request[involtv1.TogglePaymentStatusRequest],
) (*connect.Response[involtv1.TogglePaymentStatusResponse], error) {
	if !req.Msg.IsPaid {
		return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("payments can no longer be unmarked; void the payment instead"))
	}

	customerID := req.Msg.CustomerId
	if req.Msg.ReadingId != "" {
		reading, err := h.readingRepo.GetByID(ctx, req.Msg.ReadingId)
		if err != nil || reading == nil {
			return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("reading %s not found", req.Msg.ReadingId))
		}
		customerID = reading.CustomerID
	} else if customerID == "" || req.Msg.Period == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("reading_id or both customer_id and period are required"))
	}

	user, customer, err := h.authorizeCustomer(ctx, customerID)
	if err != nil {
		return nil, err
	}

	readingID := req.Msg.ReadingId
	if readingID == "" {
		reading, err := h.readingRepo.GetByCustomerAndPeriod(ctx, customerID, req.Msg.Period)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		if reading == nil {
			reading, err = h.createFlatCharge(ctx, customerID, req.Msg.Period, req.Msg.TotalToPay, req.Msg.Observation)
			if err != nil {
				return nil, err
			}
		}
		readingID = reading.ID
	}

	debts, err := h.outstandingDebts(ctx, customerID, []string{readingID})
	if err != nil {
		return nil, err
	}
	if owed := roundCents(debts[0].Balance + debts[0].LateFee); owed > 0 {
		if _, err := h.recordPayment(ctx, user, customer, []string{readingID}, owed, domain.PaymentMethodCash, "", req.Msg.Observation); err != nil {
			return nil, err
		}
	}

	return connect.NewResponse(&involtv1.TogglePaymentStatusResponse{ReadingId: readingID, IsPaid: true}), nil
}

// GetCollections returns the payment matrix for a sector across the given periods, with each
// receipt's balance and status, every customer's total debt and the billed/collected totals.
func (h *AdminHandler) GetCollections(
	ctx context.Context,
	req *connect.Request[involtv1.GetCollectionsRequest],
) (*connect.Response[involtv1.GetCollectionsResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("authentication required"))
	}
	if req.Msg.SectorId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("sector_id is required"))
	}
	if !canAccessSector(user, req.Msg.SectorId) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("sector not assigned"))
	}

	customers, err := h.customerRepo.ListBySector(ctx, req.Msg.SectorId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	readings, err := h.readingRepo.ListBySector(ctx, req.Msg.SectorId, req.Msg.Periods)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	sectorCustomerIDs := make([]string, len(customers))
	for i, c := range customers {
		sectorCustomerIDs[i] = c.ID
	}
	state, err := h.loadCollectionState(ctx, sectorCustomerIDs, readings)
	if err != nil {
		return nil, err
	}
	paid := state.paid
	debts, err := h.paymentRepo.DebtByCustomer(ctx, req.Msg.SectorId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	customerNamesByID := make(map[string]string, len(customers))
	for _, customer := range customers {
		customerNamesByID[customer.ID] = customer.Name
	}

	resp := &involtv1.GetCollectionsResponse{}
	readingsByCustomer := make(map[string][]domain.Reading, len(customers))
	protoByCustomer := make(map[string][]*involtv1.Reading, len(customers))
	var billedCents, collectedCents int64
	for i := range readings {
		r := &readings[i]
		if r.CustomerName == "" {
			r.CustomerName = customerNamesByID[r.CustomerID]
		}
		protoReading := domain.MapReadingToProto(r)
		resp.Readings = append(resp.Readings, protoReading)
		readingsByCustomer[r.CustomerID] = append(readingsByCustomer[r.CustomerID], *r)
		protoByCustomer[r.CustomerID] = append(protoByCustomer[r.CustomerID], protoReading)

		billedCents += toCentsRounded(r.TotalToPay)
		collectedCents += toCentsRounded(min(paid[r.ID], r.TotalToPay))
	}
	resp.TotalBilled = float64(billedCents) / 100
	resp.TotalCollected = float64(collectedCents) / 100

	for i := range customers {
		customer := &customers[i]
		resp.Customers = append(resp.Customers, &involtv1.CollectionCustomer{
			Customer:  domain.MapCustomerToProto(customer),
			Readings:  protoByCustomer[customer.ID],
			Receipts:  state.receiptBalances(readingsByCustomer[customer.ID]),
			TotalDebt: debts[customer.ID],
		})
	}
	return connect.NewResponse(resp), nil
}

func toCentsRounded(v float64) int64 {
	return int64(math.Round(v * 100))
}
