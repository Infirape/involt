package handlers

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

func TestGetCollectionsReturnsCustomersWithoutReadings(t *testing.T) {
	ctx := authenticatedTestContext()
	customerRepo := &collectionsCustomerRepoStub{
		listBySectorFunc: func(_ context.Context, sectorID string) ([]domain.Customer, error) {
			if sectorID != "sector-achupampa" {
				t.Fatalf("expected sector-achupampa, got %s", sectorID)
			}
			return []domain.Customer{
				{ID: "cust-001", Code: "ACH001", Name: "Ana Luz", SectorID: sectorID},
				{ID: "cust-002", Code: "ACH002", Name: "Beto Sol", SectorID: sectorID},
			}, nil
		},
	}
	readingRepo := &collectionsReadingRepoStub{
		listBySectorFunc: func(_ context.Context, sectorID string, periods []string) ([]domain.Reading, error) {
			if sectorID != "sector-achupampa" {
				t.Fatalf("expected readings query to use sector_id, got %s", sectorID)
			}
			if len(periods) != 2 || periods[0] != "2026-05" || periods[1] != "2026-04" {
				t.Fatalf("unexpected periods: %#v", periods)
			}
			return nil, nil
		},
	}
	handler := &AdminHandler{customerRepo: customerRepo, readingRepo: readingRepo, paymentRepo: &fakePaymentRepo{}}

	resp, err := handler.GetCollections(ctx, connect.NewRequest(&involtv1.GetCollectionsRequest{
		SectorId: "sector-achupampa",
		Periods:  []string{"2026-05", "2026-04"},
	}))
	if err != nil {
		t.Fatalf("GetCollections returned error: %v", err)
	}

	if got := len(resp.Msg.GetReadings()); got != 0 {
		t.Fatalf("legacy readings length = %d, want 0", got)
	}
	if got := len(resp.Msg.GetCustomers()); got != 2 {
		t.Fatalf("customers length = %d, want 2", got)
	}
	if resp.Msg.GetCustomers()[0].GetCustomer().GetId() != "cust-001" {
		t.Fatalf("first customer id = %s, want cust-001", resp.Msg.GetCustomers()[0].GetCustomer().GetId())
	}
	if got := len(resp.Msg.GetCustomers()[0].GetReadings()); got != 0 {
		t.Fatalf("customer readings length = %d, want 0", got)
	}
}

func TestGetCollectionsAttachesRequestedPeriodReadingsToCustomerRows(t *testing.T) {
	ctx := authenticatedTestContext()
	customerRepo := &collectionsCustomerRepoStub{
		listBySectorFunc: func(_ context.Context, sectorID string) ([]domain.Customer, error) {
			return []domain.Customer{
				{ID: "cust-001", Code: "ACH001", Name: "Ana Luz", SectorID: sectorID},
				{ID: "cust-002", Code: "ACH002", Name: "Beto Sol", SectorID: sectorID},
			}, nil
		},
	}
	readingRepo := &collectionsReadingRepoStub{
		listBySectorFunc: func(_ context.Context, _ string, _ []string) ([]domain.Reading, error) {
			return []domain.Reading{
				{ID: "read-001", CustomerID: "cust-001", CustomerName: "Ana Luz", Period: "2026-05", TotalToPay: 45.5, IsPaid: false},
			}, nil
		},
	}
	handler := &AdminHandler{customerRepo: customerRepo, readingRepo: readingRepo, paymentRepo: &fakePaymentRepo{}}

	resp, err := handler.GetCollections(ctx, connect.NewRequest(&involtv1.GetCollectionsRequest{
		SectorId: "sector-achupampa",
		Periods:  []string{"2026-05", "2026-04"},
	}))
	if err != nil {
		t.Fatalf("GetCollections returned error: %v", err)
	}

	if got := len(resp.Msg.GetReadings()); got != 1 {
		t.Fatalf("legacy readings length = %d, want 1", got)
	}
	customers := resp.Msg.GetCustomers()
	if got := len(customers); got != 2 {
		t.Fatalf("customers length = %d, want 2", got)
	}
	if got := len(customers[0].GetReadings()); got != 1 {
		t.Fatalf("first customer readings length = %d, want 1", got)
	}
	if got := customers[0].GetReadings()[0].GetId(); got != "read-001" {
		t.Fatalf("attached reading id = %s, want read-001", got)
	}
	if got := len(customers[1].GetReadings()); got != 0 {
		t.Fatalf("second customer readings length = %d, want 0", got)
	}
}

func TestGetCollectionsReportsReceiptBalancesDebtAndTotals(t *testing.T) {
	ctx := authenticatedTestContext()
	customerRepo := &collectionsCustomerRepoStub{
		listBySectorFunc: func(_ context.Context, sectorID string) ([]domain.Customer, error) {
			return []domain.Customer{{ID: "cust-001", Name: "Ana Luz", SectorID: sectorID}}, nil
		},
	}
	readingRepo := &collectionsReadingRepoStub{
		listBySectorFunc: func(context.Context, string, []string) ([]domain.Reading, error) {
			return []domain.Reading{
				{ID: "r-1", CustomerID: "cust-001", Period: "2026-09", TotalToPay: 10},
				{ID: "r-2", CustomerID: "cust-001", Period: "2026-10", TotalToPay: 8},
			}, nil
		},
	}
	payments := &fakePaymentRepo{
		payments: []*domain.Payment{{ID: "p", Amount: 13, Allocations: []domain.PaymentAllocation{
			{ReadingID: "r-1", Amount: 10}, {ReadingID: "r-2", Amount: 3},
		}}},
		debts: map[string]float64{"cust-001": 25},
	}
	handler := &AdminHandler{customerRepo: customerRepo, readingRepo: readingRepo, paymentRepo: payments,
		clock: func() time.Time { return fixedNow }}

	resp, err := handler.GetCollections(ctx, connect.NewRequest(&involtv1.GetCollectionsRequest{
		SectorId: "sec-1", Periods: []string{"2026-09", "2026-10"},
	}))
	if err != nil {
		t.Fatalf("GetCollections: %v", err)
	}
	if resp.Msg.GetTotalBilled() != 18 || resp.Msg.GetTotalCollected() != 13 {
		t.Fatalf("totals = %v / %v, want 18 / 13", resp.Msg.GetTotalBilled(), resp.Msg.GetTotalCollected())
	}
	row := resp.Msg.GetCustomers()[0]
	if row.GetTotalDebt() != 25 {
		t.Fatalf("total debt = %v, want 25 (all periods)", row.GetTotalDebt())
	}
	receipts := row.GetReceipts()
	if len(receipts) != 2 || receipts[0].GetStatus() != involtv1.ReceiptStatus_RECEIPT_STATUS_PAID ||
		receipts[1].GetStatus() != involtv1.ReceiptStatus_RECEIPT_STATUS_PARTIAL || receipts[1].GetBalance() != 5 {
		t.Fatalf("receipts = %+v", receipts)
	}
}

func TestGetCollectionsDeniesUnassignedSector(t *testing.T) {
	handler := &AdminHandler{}
	_, err := handler.GetCollections(contextWithUser("s", "SUPERVISOR", "sec-2"), connect.NewRequest(&involtv1.GetCollectionsRequest{SectorId: "sec-1"}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("code = %v, want PermissionDenied", connect.CodeOf(err))
	}
}

func TestTogglePaymentStatusRegistersBalanceAsCashPayment(t *testing.T) {
	h, payments, _ := newPaymentsTestHandler()
	ctx := contextWithUser("admin-1", "ADMIN")

	resp, err := h.TogglePaymentStatus(ctx, connect.NewRequest(&involtv1.TogglePaymentStatusRequest{
		CustomerId: "cust-1", Period: "2026-09", IsPaid: true,
	}))
	if err != nil {
		t.Fatalf("TogglePaymentStatus: %v", err)
	}
	if resp.Msg.GetReadingId() != "r-sep" || !resp.Msg.GetIsPaid() {
		t.Fatalf("response = %+v", resp.Msg)
	}
	if len(payments.payments) != 1 || payments.payments[0].Amount != 12.5 || payments.payments[0].Allocations[0].ReadingID != "r-sep" {
		t.Fatalf("payments = %+v", payments.payments)
	}
}

func TestTogglePaymentStatusCreatesFlatChargeWhenPeriodHasNoReading(t *testing.T) {
	h, payments, readingRepo := newPaymentsTestHandler()
	ctx := contextWithUser("admin-1", "ADMIN")

	_, err := h.TogglePaymentStatus(ctx, connect.NewRequest(&involtv1.TogglePaymentStatusRequest{
		CustomerId: "cust-1", Period: "2026-10", IsPaid: true, TotalToPay: 7,
	}))
	if err != nil {
		t.Fatalf("TogglePaymentStatus: %v", err)
	}
	if len(readingRepo.saved) != 1 || readingRepo.saved[0].TotalToPay != 7 {
		t.Fatalf("flat charge not created: %+v", readingRepo.saved)
	}
	if len(payments.payments) != 1 || payments.payments[0].Amount != 7 {
		t.Fatalf("payments = %+v", payments.payments)
	}
}

func TestTogglePaymentStatusRejectsUnpay(t *testing.T) {
	h, _, _ := newPaymentsTestHandler()
	_, err := h.TogglePaymentStatus(contextWithUser("admin-1", "ADMIN"), connect.NewRequest(&involtv1.TogglePaymentStatusRequest{
		CustomerId: "cust-1", Period: "2026-09", IsPaid: false,
	}))
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("code = %v, want FailedPrecondition", connect.CodeOf(err))
	}
}
