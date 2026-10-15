package repositories

import (
	"context"
	"os"
	"testing"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

// Integration tests run only when INVOLT_TEST_DATABASE_URL points at a disposable database.
func openPaymentsTestDB(t *testing.T) *sqlx.DB {
	t.Helper()
	url := os.Getenv("INVOLT_TEST_DATABASE_URL")
	if url == "" {
		t.Skip("INVOLT_TEST_DATABASE_URL not set; skipping Postgres integration test")
	}
	db, err := sqlx.Connect("postgres", url)
	if err != nil {
		t.Fatalf("connect: %v", err)
	}
	t.Cleanup(func() { db.Close() })

	for _, file := range []string{"../../../cmd/server/schema.sql", "../../../cmd/server/payments_schema.sql", "../../../cmd/server/collections_schema.sql"} {
		sqlBytes, err := os.ReadFile(file)
		if err != nil {
			t.Fatalf("read %s: %v", file, err)
		}
		if _, err := db.Exec(string(sqlBytes)); err != nil {
			t.Fatalf("apply %s: %v", file, err)
		}
	}

	db.MustExec(`TRUNCATE agreement_installments, agreement_receipts, payment_agreements, late_fee_waivers, payment_allocations, payments, readings, customers, sectors, communities CASCADE`)
	db.MustExec(`DELETE FROM collection_policy`)
	db.MustExec(`INSERT INTO collection_policy (id) VALUES ('main')`)
	db.MustExec(`INSERT INTO communities (id, name) VALUES ('com-1', 'Chetilla')`)
	db.MustExec(`INSERT INTO sectors (id, community_id, name) VALUES ('sec-1', 'com-1', 'Centro')`)
	db.MustExec(`INSERT INTO customers (id, code, name, community_id, sector_id, connection_type, tariff, meter_number)
	             VALUES ('cust-1', 'CHE001', 'Ana Luz', 'com-1', 'sec-1', 'RESIDENTIAL', 0.25, 'M-1')`)
	for _, r := range []struct {
		id, period string
		total      float64
	}{{"r-1", "2026-08", 10}, {"r-2", "2026-09", 12.5}} {
		db.MustExec(`INSERT INTO readings (id, customer_id, previous_value, current_value, consumption,
		               cargo_fijo, alumbrado_publico, saldo_redondeo, subtotal, total_to_pay, period)
		             VALUES ($1, 'cust-1', 0, 0, 0, 0, 0, 0, $2, $2, $3)`, r.id, r.total, r.period)
	}
	return db
}

func readingPaidState(t *testing.T, db *sqlx.DB, id string) (bool, *time.Time) {
	t.Helper()
	var row struct {
		IsPaid      bool       `db:"is_paid"`
		PaymentDate *time.Time `db:"payment_date"`
	}
	if err := db.Get(&row, `SELECT is_paid, payment_date FROM readings WHERE id = $1`, id); err != nil {
		t.Fatalf("read reading %s: %v", id, err)
	}
	return row.IsPaid, row.PaymentDate
}

func TestPaymentRepositoryCreateSyncsReadings(t *testing.T) {
	db := openPaymentsTestDB(t)
	repo := NewPostgresPaymentRepository(db)
	ctx := context.Background()

	p := &domain.Payment{
		ID: "pay-1", CustomerID: "cust-1", Amount: 15, Method: string(domain.PaymentMethodYape),
		Reference: "OP-123", CollectedBy: "user-1", CollectedByEmail: "caja@infira.pe",
		Allocations: []domain.PaymentAllocation{{ReadingID: "r-1", Amount: 10}, {ReadingID: "r-2", Amount: 5}},
	}
	if err := repo.Create(ctx, p); err != nil {
		t.Fatalf("Create: %v", err)
	}
	if p.ReceiptNumber == 0 || p.PaidAt.IsZero() {
		t.Fatalf("Create should fill receipt number and paid_at, got %d / %v", p.ReceiptNumber, p.PaidAt)
	}

	if paid, date := readingPaidState(t, db, "r-1"); !paid || date == nil {
		t.Fatalf("r-1 should be fully paid with a payment date")
	}
	if paid, _ := readingPaidState(t, db, "r-2"); paid {
		t.Fatalf("r-2 is only partially paid and must stay unpaid")
	}

	amounts, err := repo.PaidAmounts(ctx, []string{"r-1", "r-2", "r-unknown"})
	if err != nil {
		t.Fatalf("PaidAmounts: %v", err)
	}
	if amounts["r-1"] != 10 || amounts["r-2"] != 5 || amounts["r-unknown"] != 0 {
		t.Fatalf("PaidAmounts = %#v", amounts)
	}

	got, err := repo.GetByID(ctx, "pay-1")
	if err != nil {
		t.Fatalf("GetByID: %v", err)
	}
	if got.CustomerName != "Ana Luz" || got.CustomerCode != "CHE001" || len(got.Allocations) != 2 {
		t.Fatalf("GetByID = %#v", got)
	}
	if got.Allocations[0].Period != "2026-08" {
		t.Fatalf("allocations should be ordered by period with period filled, got %#v", got.Allocations)
	}
}

func TestPaymentRepositoryVoidRestoresDebt(t *testing.T) {
	db := openPaymentsTestDB(t)
	repo := NewPostgresPaymentRepository(db)
	ctx := context.Background()

	p := &domain.Payment{ID: "pay-1", CustomerID: "cust-1", Amount: 10, Method: "CASH",
		Allocations: []domain.PaymentAllocation{{ReadingID: "r-1", Amount: 10}}}
	if err := repo.Create(ctx, p); err != nil {
		t.Fatalf("Create: %v", err)
	}

	if err := repo.Void(ctx, "pay-1", "admin-1", "Cobro duplicado"); err != nil {
		t.Fatalf("Void: %v", err)
	}
	if paid, date := readingPaidState(t, db, "r-1"); paid || date != nil {
		t.Fatalf("r-1 must be unpaid again after voiding")
	}
	amounts, _ := repo.PaidAmounts(ctx, []string{"r-1"})
	if amounts["r-1"] != 0 {
		t.Fatalf("voided allocations must not count, got %v", amounts["r-1"])
	}

	if err := repo.Void(ctx, "pay-1", "admin-1", "otra vez"); err != domain.ErrPaymentAlreadyVoided {
		t.Fatalf("second void err = %v, want ErrPaymentAlreadyVoided", err)
	}
	if err := repo.Void(ctx, "nope", "admin-1", "x"); err != domain.ErrPaymentNotFound {
		t.Fatalf("missing void err = %v, want ErrPaymentNotFound", err)
	}
}

func TestPaymentRepositoryListFilters(t *testing.T) {
	db := openPaymentsTestDB(t)
	repo := NewPostgresPaymentRepository(db)
	ctx := context.Background()

	for _, p := range []*domain.Payment{
		{ID: "pay-a", CustomerID: "cust-1", Amount: 4, Method: "CASH", CollectedBy: "u-1",
			Allocations: []domain.PaymentAllocation{{ReadingID: "r-1", Amount: 4}}},
		{ID: "pay-b", CustomerID: "cust-1", Amount: 3, Method: "YAPE", CollectedBy: "u-2",
			Allocations: []domain.PaymentAllocation{{ReadingID: "r-1", Amount: 3}}},
	} {
		if err := repo.Create(ctx, p); err != nil {
			t.Fatalf("Create %s: %v", p.ID, err)
		}
	}
	if err := repo.Void(ctx, "pay-b", "admin", "error"); err != nil {
		t.Fatalf("Void: %v", err)
	}

	from := time.Now().Add(-time.Hour)
	to := time.Now().Add(time.Hour)

	active, err := repo.List(ctx, ports.PaymentFilter{From: from, To: to})
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if len(active) != 1 || active[0].ID != "pay-a" {
		t.Fatalf("active list = %#v", active)
	}

	all, _ := repo.List(ctx, ports.PaymentFilter{CustomerID: "cust-1", IncludeVoided: true})
	if len(all) != 2 {
		t.Fatalf("list with voided = %d, want 2", len(all))
	}

	byCollector, _ := repo.List(ctx, ports.PaymentFilter{CollectedBy: "u-2", IncludeVoided: true})
	if len(byCollector) != 1 || byCollector[0].ID != "pay-b" || !byCollector[0].IsVoided() {
		t.Fatalf("collector list = %#v", byCollector)
	}

	outOfRange, _ := repo.List(ctx, ports.PaymentFilter{From: to, To: to.Add(time.Hour)})
	if len(outOfRange) != 0 {
		t.Fatalf("out-of-range list = %d, want 0", len(outOfRange))
	}
}

func TestPaymentsSchemaBackfillsLegacyPaidReadings(t *testing.T) {
	db := openPaymentsTestDB(t)
	db.MustExec(`UPDATE readings SET is_paid = TRUE, payment_date = '2026-09-05T10:00:00Z' WHERE id = 'r-1'`)

	schema, err := os.ReadFile("../../../cmd/server/payments_schema.sql")
	if err != nil {
		t.Fatalf("read schema: %v", err)
	}
	// Running twice must not duplicate the legacy payment.
	db.MustExec(string(schema))
	db.MustExec(string(schema))

	repo := NewPostgresPaymentRepository(db)
	payments, err := repo.List(context.Background(), ports.PaymentFilter{CustomerID: "cust-1"})
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if len(payments) != 1 || payments[0].ID != "legacy-r-1" || payments[0].Amount != 10 {
		t.Fatalf("legacy payments = %#v", payments)
	}
	if !payments[0].PaidAt.Equal(time.Date(2026, 9, 5, 10, 0, 0, 0, time.UTC)) {
		t.Fatalf("legacy paid_at = %v, want original payment_date", payments[0].PaidAt)
	}
	if len(payments[0].Allocations) != 1 || payments[0].Allocations[0].ReadingID != "r-1" {
		t.Fatalf("legacy allocations = %#v", payments[0].Allocations)
	}
}

func TestPaymentRepositoryDebtByCustomer(t *testing.T) {
	db := openPaymentsTestDB(t)
	repo := NewPostgresPaymentRepository(db)
	ctx := context.Background()

	db.MustExec(`INSERT INTO customers (id, code, name, community_id, sector_id, connection_type, tariff, meter_number)
	             VALUES ('cust-2', 'CHE002', 'Beto Sol', 'com-1', 'sec-1', 'RESIDENTIAL', 0.25, 'M-2')`)

	p := &domain.Payment{ID: "pay-1", CustomerID: "cust-1", Amount: 12.5, Method: "CASH",
		Allocations: []domain.PaymentAllocation{{ReadingID: "r-1", Amount: 10}, {ReadingID: "r-2", Amount: 2.5}}}
	if err := repo.Create(ctx, p); err != nil {
		t.Fatalf("Create: %v", err)
	}

	debts, err := repo.DebtByCustomer(ctx, "sec-1")
	if err != nil {
		t.Fatalf("DebtByCustomer: %v", err)
	}
	if debts["cust-1"] != 10 {
		t.Fatalf("cust-1 debt = %v, want 10 (22.5 billed - 12.5 paid)", debts["cust-1"])
	}
	if debts["cust-2"] != 0 {
		t.Fatalf("customer without readings debt = %v, want 0", debts["cust-2"])
	}
}

func TestPaymentsSchemaBackfillAvoidsZeroTimestamps(t *testing.T) {
	db := openPaymentsTestDB(t)
	// Dummy readings created by the old toggle had no timestamp and no payment_date.
	db.MustExec(`UPDATE readings SET is_paid = TRUE, payment_date = NULL, "timestamp" = '0001-01-01T00:00:00Z' WHERE id = 'r-2'`)

	schema, err := os.ReadFile("../../../cmd/server/payments_schema.sql")
	if err != nil {
		t.Fatalf("read schema: %v", err)
	}
	db.MustExec(string(schema))

	p, err := NewPostgresPaymentRepository(db).GetByID(context.Background(), "legacy-r-2")
	if err != nil {
		t.Fatalf("GetByID: %v", err)
	}
	if p.PaidAt.Year() < 2000 {
		t.Fatalf("legacy paid_at = %v, must not be a zero timestamp", p.PaidAt)
	}
	if month := p.PaidAt.In(time.FixedZone("Lima", -5*3600)).Format("2006-01"); month != "2026-09" {
		t.Fatalf("legacy payment falls in %s in Lima, want its billing period 2026-09", month)
	}
}
