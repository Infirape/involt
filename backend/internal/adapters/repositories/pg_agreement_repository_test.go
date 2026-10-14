package repositories

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

func TestCollectionPolicyRoundTrip(t *testing.T) {
	db := openPaymentsTestDB(t)
	repo := NewPostgresCollectionPolicyRepository(db)
	ctx := context.Background()

	def, err := repo.Get(ctx)
	if err != nil {
		t.Fatalf("Get default: %v", err)
	}
	if def.LateFee.Mode != domain.LateFeeNone || def.Agreement.MaxInstallments != 12 || !def.Agreement.WaiveLateFees {
		t.Fatalf("default policy = %+v", def)
	}

	start := time.Date(2026, 11, 1, 0, 0, 0, 0, time.UTC)
	p := &domain.CollectionPolicy{
		LateFee:   domain.LateFeePolicy{Mode: domain.LateFeeMonthlyInterest, Value: 1.5, StartDate: start},
		Agreement: domain.AgreementPolicy{MaxInstallments: 6, MinInitialPercent: 20, GraceDays: 10},
		UpdatedBy: "admin@infira.pe",
	}
	if err := repo.Save(ctx, p); err != nil {
		t.Fatalf("Save: %v", err)
	}
	got, _ := repo.Get(ctx)
	if got.LateFee != p.LateFee || got.Agreement != p.Agreement || got.UpdatedBy != "admin@infira.pe" {
		t.Fatalf("saved policy = %+v", got)
	}

	p.LateFee = domain.LateFeePolicy{Mode: domain.LateFeeNone}
	_ = repo.Save(ctx, p)
	if got, _ := repo.Get(ctx); !got.LateFee.StartDate.IsZero() {
		t.Fatalf("clearing the start date should persist NULL, got %v", got.LateFee.StartDate)
	}
}

func newAgreement(id string, readingIDs ...string) *domain.Agreement {
	inst, _ := domain.BuildInstallments(22.5, 2.5, 2, time.Date(2026, 11, 15, 0, 0, 0, 0, time.UTC))
	a := &domain.Agreement{
		ID: id, CustomerID: "cust-1", Status: domain.AgreementActive, Total: 22.5, InitialAmount: 2.5,
		CreatedBy: "u-1", CreatedByEmail: "caja@infira.pe", Installments: inst,
	}
	for _, r := range readingIDs {
		a.Receipts = append(a.Receipts, domain.AgreementReceipt{ReadingID: r, Principal: 10, LateFee: 0.5})
	}
	return a
}

func TestAgreementRepositoryLifecycle(t *testing.T) {
	db := openPaymentsTestDB(t)
	repo := NewPostgresAgreementRepository(db)
	payments := NewPostgresPaymentRepository(db)
	ctx := context.Background()

	// A payment before signing must not count towards the agreement.
	_ = payments.Create(ctx, &domain.Payment{ID: "pay-before", CustomerID: "cust-1", Amount: 1, Method: "CASH",
		Allocations: []domain.PaymentAllocation{{ReadingID: "r-1", Amount: 1}}})
	time.Sleep(10 * time.Millisecond)

	a := newAgreement("ag-1", "r-1", "r-2")
	if err := repo.Create(ctx, a); err != nil {
		t.Fatalf("Create: %v", err)
	}
	if a.Number == 0 || a.CreatedAt.IsZero() {
		t.Fatalf("Create should fill number and created_at: %+v", a)
	}
	if err := repo.Create(ctx, newAgreement("ag-2", "r-2")); !errors.Is(err, domain.ErrReceiptInAgreement) {
		t.Fatalf("overlapping agreement err = %v, want ErrReceiptInAgreement", err)
	}

	_ = payments.Create(ctx, &domain.Payment{ID: "pay-after", CustomerID: "cust-1", Amount: 3, Method: "CASH",
		Allocations: []domain.PaymentAllocation{{ReadingID: "r-1", Amount: 2.5, LateFee: 0.5}}})

	got, err := repo.GetByID(ctx, "ag-1")
	if err != nil {
		t.Fatalf("GetByID: %v", err)
	}
	if got.CustomerName != "Ana Luz" || len(got.Receipts) != 2 || len(got.Installments) != 2 || got.Receipts[0].Period != "2026-08" {
		t.Fatalf("agreement = %+v", got)
	}
	if got.PaidSinceSigning != 3 {
		t.Fatalf("paid since signing = %v, want 3 (principal + fee after signing only)", got.PaidSinceSigning)
	}

	active, _ := repo.List(ctx, []string{"cust-1"}, true)
	if len(active) != 1 || active[0].ID != "ag-1" || len(active[0].Installments) != 2 {
		t.Fatalf("active list = %+v", active)
	}

	if err := repo.Cancel(ctx, "ag-1", "admin", "Cliente desistió"); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	if err := repo.Cancel(ctx, "ag-1", "admin", "otra vez"); !errors.Is(err, domain.ErrInvalidAgreement) {
		t.Fatalf("double cancel err = %v", err)
	}
	if err := repo.Cancel(ctx, "nope", "admin", "x"); !errors.Is(err, domain.ErrAgreementNotFound) {
		t.Fatalf("missing cancel err = %v", err)
	}
	if active, _ := repo.List(ctx, nil, true); len(active) != 0 {
		t.Fatalf("cancelled agreement still active: %+v", active)
	}
	if err := repo.Create(ctx, newAgreement("ag-3", "r-2")); err != nil {
		t.Fatalf("receipts of a cancelled agreement can be renegotiated: %v", err)
	}
}

func TestLateFeeWaivers(t *testing.T) {
	db := openPaymentsTestDB(t)
	repo := NewPostgresAgreementRepository(db)
	ctx := context.Background()

	err := repo.Waive(ctx, []ports.LateFeeWaiver{{ReadingID: "r-1", Reason: "Adulto mayor", WaivedBy: "admin"}})
	if err != nil {
		t.Fatalf("Waive: %v", err)
	}
	// Waiving twice is idempotent.
	if err := repo.Waive(ctx, []ports.LateFeeWaiver{{ReadingID: "r-1", Reason: "dup"}}); err != nil {
		t.Fatalf("second Waive: %v", err)
	}
	waived, err := repo.WaivedReadings(ctx, []string{"r-1", "r-2"})
	if err != nil {
		t.Fatalf("WaivedReadings: %v", err)
	}
	if !waived["r-1"] || waived["r-2"] {
		t.Fatalf("waived = %+v", waived)
	}
}

func TestPaymentAllocationsStoreLateFees(t *testing.T) {
	db := openPaymentsTestDB(t)
	payments := NewPostgresPaymentRepository(db)
	ctx := context.Background()

	err := payments.Create(ctx, &domain.Payment{ID: "p", CustomerID: "cust-1", Amount: 0.75, Method: "CASH",
		Allocations: []domain.PaymentAllocation{{ReadingID: "r-1", Amount: 0, LateFee: 0.75}}})
	if err != nil {
		t.Fatalf("fee-only allocation should be accepted: %v", err)
	}
	fees, _ := payments.LateFeesPaid(ctx, []string{"r-1"})
	principal, _ := payments.PaidAmounts(ctx, []string{"r-1"})
	if fees["r-1"] != 0.75 || principal["r-1"] != 0 {
		t.Fatalf("fees = %+v principal = %+v", fees, principal)
	}
	got, _ := payments.GetByID(ctx, "p")
	if got.Allocations[0].LateFee != 0.75 {
		t.Fatalf("allocation late fee not loaded: %+v", got.Allocations)
	}
}
