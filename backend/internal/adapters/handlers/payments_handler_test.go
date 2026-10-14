package handlers

import (
	"context"
	"database/sql"
	"fmt"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

var fixedNow = time.Date(2026, 10, 13, 12, 0, 0, 0, limaZone)

// newPaymentsTestHandler wires a customer in sector "sec-1" with three receipts:
// Aug (overdue, 10), Sep (due 2026-10-15, 12.5) and an Oct flat charge of 6.
func newPaymentsTestHandler() (*AdminHandler, *fakePaymentRepo, *collectionsReadingRepoStub) {
	customer := &domain.Customer{ID: "cust-1", Code: "CHE001", Name: "Ana Luz", SectorID: "sec-1"}
	customerRepo := &collectionsCustomerRepoStub{
		getByIDFunc: func(_ context.Context, id string) (*domain.Customer, error) {
			if id != customer.ID {
				return nil, fmt.Errorf("error getting customer by id: %w", sql.ErrNoRows)
			}
			return customer, nil
		},
	}
	readings := []domain.Reading{
		{ID: "r-sep", CustomerID: "cust-1", Period: "2026-09", TotalToPay: 12.5, ExpirationDate: time.Date(2026, 10, 15, 0, 0, 0, 0, time.UTC)},
		{ID: "r-aug", CustomerID: "cust-1", Period: "2026-08", TotalToPay: 10, ExpirationDate: time.Date(2026, 9, 15, 0, 0, 0, 0, time.UTC)},
	}
	readingRepo := &collectionsReadingRepoStub{}
	readingRepo.listByCustomerFunc = func(context.Context, string) ([]domain.Reading, error) {
		all := append([]domain.Reading{}, readings...)
		for _, r := range readingRepo.saved {
			all = append(all, *r)
		}
		return all, nil
	}
	readingRepo.getByCustomerAndPeriodFunc = func(_ context.Context, _ string, period string) (*domain.Reading, error) {
		for i := range readings {
			if readings[i].Period == period {
				return &readings[i], nil
			}
		}
		return nil, nil
	}
	payments := &fakePaymentRepo{}
	h := &AdminHandler{
		customerRepo: customerRepo,
		readingRepo:  readingRepo,
		paymentRepo:  payments,
		metaRepo:     &settingsMetaStub{settings: &domain.Settings{CargoFijo: 5, Alumbrado: 1, DiasVencimiento: 20}},
		clock:        func() time.Time { return fixedNow },
	}
	return h, payments, readingRepo
}

func TestRegisterPaymentAppliesOldestDebtFirst(t *testing.T) {
	h, payments, _ := newPaymentsTestHandler()
	ctx := contextWithUser("cajero-1", "SUPERVISOR", "sec-1")

	resp, err := h.RegisterPayment(ctx, connect.NewRequest(&involtv1.RegisterPaymentRequest{
		CustomerId: "cust-1", Amount: 15, Method: involtv1.PaymentMethod_PAYMENT_METHOD_YAPE, Reference: "OP-9",
	}))
	if err != nil {
		t.Fatalf("RegisterPayment: %v", err)
	}

	p := resp.Msg.GetPayment()
	if p.GetReceiptNumber() != 1 || p.GetMethod() != involtv1.PaymentMethod_PAYMENT_METHOD_YAPE || p.GetReference() != "OP-9" {
		t.Fatalf("payment = %+v", p)
	}
	stored := payments.payments[0]
	if stored.CollectedBy != "cajero-1" || stored.CollectedByEmail != "cajero-1@infira.pe" {
		t.Fatalf("collector not recorded: %+v", stored)
	}
	if len(stored.Allocations) != 2 || stored.Allocations[0].ReadingID != "r-aug" || stored.Allocations[0].Amount != 10 ||
		stored.Allocations[1].ReadingID != "r-sep" || stored.Allocations[1].Amount != 5 {
		t.Fatalf("allocations = %+v", stored.Allocations)
	}
}

func TestRegisterPaymentRestrictsToSelectedReceipts(t *testing.T) {
	h, payments, _ := newPaymentsTestHandler()
	ctx := contextWithUser("admin-1", "ADMIN")

	_, err := h.RegisterPayment(ctx, connect.NewRequest(&involtv1.RegisterPaymentRequest{
		CustomerId: "cust-1", ReadingIds: []string{"r-sep"}, Amount: 12.5,
	}))
	if err != nil {
		t.Fatalf("RegisterPayment: %v", err)
	}
	if a := payments.payments[0].Allocations; len(a) != 1 || a[0].ReadingID != "r-sep" {
		t.Fatalf("allocations = %+v", a)
	}
	if payments.payments[0].Method != string(domain.PaymentMethodCash) {
		t.Fatalf("unspecified method should default to CASH, got %s", payments.payments[0].Method)
	}
}

func TestRegisterPaymentValidation(t *testing.T) {
	h, _, _ := newPaymentsTestHandler()
	admin := contextWithUser("admin-1", "ADMIN")

	cases := []struct {
		name string
		ctx  context.Context
		req  *involtv1.RegisterPaymentRequest
		code connect.Code
	}{
		{"overpayment", admin, &involtv1.RegisterPaymentRequest{CustomerId: "cust-1", Amount: 23}, connect.CodeFailedPrecondition},
		{"zero amount", admin, &involtv1.RegisterPaymentRequest{CustomerId: "cust-1", Amount: 0}, connect.CodeInvalidArgument},
		{"foreign receipt", admin, &involtv1.RegisterPaymentRequest{CustomerId: "cust-1", ReadingIds: []string{"r-other"}, Amount: 1}, connect.CodeInvalidArgument},
		{"missing customer", admin, &involtv1.RegisterPaymentRequest{Amount: 1}, connect.CodeInvalidArgument},
		{"unknown customer", admin, &involtv1.RegisterPaymentRequest{CustomerId: "ghost", Amount: 1}, connect.CodeNotFound},
		{"sector not assigned", contextWithUser("u", "SUPERVISOR", "sec-9"), &involtv1.RegisterPaymentRequest{CustomerId: "cust-1", Amount: 1}, connect.CodePermissionDenied},
		{"unauthenticated", context.Background(), &involtv1.RegisterPaymentRequest{CustomerId: "cust-1", Amount: 1}, connect.CodePermissionDenied},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			_, err := h.RegisterPayment(tc.ctx, connect.NewRequest(tc.req))
			if connect.CodeOf(err) != tc.code {
				t.Fatalf("code = %v (err %v), want %v", connect.CodeOf(err), err, tc.code)
			}
		})
	}
}

func TestGetCustomerAccountComputesBalancesAndStatus(t *testing.T) {
	h, _, _ := newPaymentsTestHandler()
	ctx := contextWithUser("admin-1", "ADMIN")
	if _, err := h.RegisterPayment(ctx, connect.NewRequest(&involtv1.RegisterPaymentRequest{CustomerId: "cust-1", Amount: 4})); err != nil {
		t.Fatalf("RegisterPayment: %v", err)
	}

	resp, err := h.GetCustomerAccount(ctx, connect.NewRequest(&involtv1.GetCustomerAccountRequest{CustomerId: "cust-1"}))
	if err != nil {
		t.Fatalf("GetCustomerAccount: %v", err)
	}
	m := resp.Msg
	if m.GetCustomer().GetName() != "Ana Luz" || len(m.GetPayments()) != 1 {
		t.Fatalf("account = %+v", m)
	}
	if m.GetTotalDebt() != 18.5 || m.GetOverdueCount() != 1 {
		t.Fatalf("total debt = %v overdue = %d, want 18.5 / 1", m.GetTotalDebt(), m.GetOverdueCount())
	}
	receipts := m.GetReceipts()
	if len(receipts) != 2 || receipts[0].GetReading().GetId() != "r-aug" {
		t.Fatalf("receipts should be oldest first: %+v", receipts)
	}
	if receipts[0].GetStatus() != involtv1.ReceiptStatus_RECEIPT_STATUS_OVERDUE || receipts[0].GetPaidAmount() != 4 || receipts[0].GetBalance() != 6 {
		t.Fatalf("aug receipt = %+v", receipts[0])
	}
	if receipts[1].GetStatus() != involtv1.ReceiptStatus_RECEIPT_STATUS_PENDING {
		t.Fatalf("sep receipt status = %v, want PENDING (due 2026-10-15)", receipts[1].GetStatus())
	}
}

func TestVoidPaymentRequiresManagerAndReason(t *testing.T) {
	h, payments, _ := newPaymentsTestHandler()
	admin := contextWithUser("admin-1", "ADMIN")
	if _, err := h.RegisterPayment(admin, connect.NewRequest(&involtv1.RegisterPaymentRequest{CustomerId: "cust-1", Amount: 4})); err != nil {
		t.Fatalf("RegisterPayment: %v", err)
	}
	id := payments.payments[0].ID

	_, err := h.VoidPayment(contextWithUser("r", "READER", "sec-1"), connect.NewRequest(&involtv1.VoidPaymentRequest{PaymentId: id, Reason: "x"}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("reader void code = %v, want PermissionDenied", connect.CodeOf(err))
	}
	_, err = h.VoidPayment(admin, connect.NewRequest(&involtv1.VoidPaymentRequest{PaymentId: id, Reason: "  "}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("blank reason code = %v, want InvalidArgument", connect.CodeOf(err))
	}

	resp, err := h.VoidPayment(admin, connect.NewRequest(&involtv1.VoidPaymentRequest{PaymentId: id, Reason: "Cobro duplicado"}))
	if err != nil {
		t.Fatalf("VoidPayment: %v", err)
	}
	if !resp.Msg.GetPayment().GetVoided() || resp.Msg.GetPayment().GetVoidReason() != "Cobro duplicado" {
		t.Fatalf("voided payment = %+v", resp.Msg.GetPayment())
	}

	_, err = h.VoidPayment(admin, connect.NewRequest(&involtv1.VoidPaymentRequest{PaymentId: id, Reason: "otra"}))
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("double void code = %v, want FailedPrecondition", connect.CodeOf(err))
	}
}

func TestCreateFlatChargeUsesSettingsAndDueDate(t *testing.T) {
	h, _, readingRepo := newPaymentsTestHandler()
	ctx := contextWithUser("admin-1", "ADMIN")

	resp, err := h.CreateFlatCharge(ctx, connect.NewRequest(&involtv1.CreateFlatChargeRequest{CustomerId: "cust-1", Period: "2026-10"}))
	if err != nil {
		t.Fatalf("CreateFlatCharge: %v", err)
	}
	if len(readingRepo.saved) != 1 {
		t.Fatalf("expected one saved reading, got %d", len(readingRepo.saved))
	}
	r := readingRepo.saved[0]
	if r.TotalToPay != 6 || r.CargoFijo != 5 || r.AlumbradoPublico != 1 || r.Period != "2026-10" {
		t.Fatalf("flat charge = %+v", r)
	}
	if !r.ExpirationDate.Equal(time.Date(2026, 11, 20, 0, 0, 0, 0, time.UTC)) {
		t.Fatalf("expiration = %v, want 2026-11-20", r.ExpirationDate)
	}
	if resp.Msg.GetReading().GetId() != r.ID {
		t.Fatalf("response reading id mismatch")
	}

	_, err = h.CreateFlatCharge(ctx, connect.NewRequest(&involtv1.CreateFlatChargeRequest{CustomerId: "cust-1", Period: "2026-09", Amount: 8}))
	if connect.CodeOf(err) != connect.CodeAlreadyExists {
		t.Fatalf("existing period code = %v, want AlreadyExists", connect.CodeOf(err))
	}
}
