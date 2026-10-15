package repositories

import (
	"context"
	"testing"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

func seedReportData(t *testing.T) *PostgresCollectionsReportRepository {
	t.Helper()
	db := openPaymentsTestDB(t)
	db.MustExec(`INSERT INTO sectors (id, community_id, name) VALUES ('sec-2', 'com-1', 'Alto')`)
	db.MustExec(`INSERT INTO customers (id, code, name, community_id, sector_id, connection_type, tariff, meter_number)
	             VALUES ('cust-2', 'CHE002', 'Beto Sol', 'com-1', 'sec-2', 'RESIDENTIAL', 0.25, 'M-2'),
	                    ('cust-del', 'CHE003', 'Borrado', 'com-1', 'sec-2', 'RESIDENTIAL', 0.25, 'M-3')`)
	db.MustExec(`UPDATE customers SET deleted_at = NOW() WHERE id = 'cust-del'`)
	db.MustExec(`INSERT INTO readings (id, customer_id, previous_value, current_value, consumption,
	               cargo_fijo, alumbrado_publico, saldo_redondeo, subtotal, total_to_pay, period, period_start, expiration_date)
	             VALUES ('r-b1', 'cust-2', 0, 0, 0, 0, 0, 0, 7, 7, NULL, '2026-09-01', '2026-10-15'),
	                    ('r-del', 'cust-del', 0, 0, 0, 0, 0, 0, 9, 9, '2026-09', '2026-09-01', '2026-10-15')`)

	payments := NewPostgresPaymentRepository(db)
	if err := payments.Create(context.Background(), &domain.Payment{ID: "pay-1", CustomerID: "cust-1", Amount: 10, Method: "CASH",
		Allocations: []domain.PaymentAllocation{{ReadingID: "r-1", Amount: 10}}}); err != nil {
		t.Fatalf("Create payment: %v", err)
	}
	return NewPostgresCollectionsReportRepository(db)
}

func TestReceiptLinesJoinContextAndPaidAmounts(t *testing.T) {
	repo := seedReportData(t)

	lines, err := repo.ListReceiptLines(context.Background(), ports.ReceiptLineFilter{})
	if err != nil {
		t.Fatalf("ListReceiptLines: %v", err)
	}
	if len(lines) != 3 {
		t.Fatalf("lines = %d, want 3 (deleted customer excluded)", len(lines))
	}
	byID := map[string]domain.ReceiptLine{}
	for _, l := range lines {
		byID[l.ReadingID] = l
	}
	r1 := byID["r-1"]
	if r1.Paid != 10 || r1.CustomerCode != "CHE001" || r1.SectorName != "Centro" || r1.CommunityName != "Chetilla" {
		t.Fatalf("r-1 = %+v", r1)
	}
	if byID["r-b1"].Period != "2026-09" {
		t.Fatalf("legacy reading without period should derive it from period_start, got %q", byID["r-b1"].Period)
	}
}

func TestReceiptLinesFilters(t *testing.T) {
	repo := seedReportData(t)
	ctx := context.Background()

	cases := []struct {
		name   string
		filter ports.ReceiptLineFilter
		want   int
	}{
		{"only outstanding", ports.ReceiptLineFilter{OnlyOutstanding: true}, 2},
		{"period range", ports.ReceiptLineFilter{FromPeriod: "2026-09", ToPeriod: "2026-09"}, 2},
		{"single sector", ports.ReceiptLineFilter{SectorID: "sec-2"}, 1},
		{"allowed sectors", ports.ReceiptLineFilter{AllowedSectorIDs: []string{"sec-1"}}, 2},
		{"community", ports.ReceiptLineFilter{CommunityID: "com-x"}, 0},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			lines, err := repo.ListReceiptLines(ctx, tc.filter)
			if err != nil {
				t.Fatalf("ListReceiptLines: %v", err)
			}
			if len(lines) != tc.want {
				t.Fatalf("lines = %d, want %d", len(lines), tc.want)
			}
		})
	}
}

func TestLastPaymentDatesAndCashIn(t *testing.T) {
	repo := seedReportData(t)
	ctx := context.Background()

	last, err := repo.LastPaymentDates(ctx, []string{"cust-1", "cust-2"})
	if err != nil {
		t.Fatalf("LastPaymentDates: %v", err)
	}
	if last["cust-1"].IsZero() || !last["cust-2"].IsZero() {
		t.Fatalf("last payments = %+v", last)
	}

	month := time.Now().In(time.FixedZone("Lima", -5*3600)).Format("2006-01")
	cash, err := repo.CashInByMonth(ctx, ports.ReceiptLineFilter{FromPeriod: month, ToPeriod: month})
	if err != nil {
		t.Fatalf("CashInByMonth: %v", err)
	}
	if cash[month] != 10 {
		t.Fatalf("cash in %s = %v, want 10", month, cash[month])
	}
	other, _ := repo.CashInByMonth(ctx, ports.ReceiptLineFilter{SectorID: "sec-2"})
	if len(other) != 0 {
		t.Fatalf("sector filter should exclude cust-1 payments, got %+v", other)
	}
}

func TestListCustomersIncludesSuppliesWithoutReceipts(t *testing.T) {
	repo := seedReportData(t)
	ctx := context.Background()

	all, err := repo.ListCustomers(ctx, ports.ReceiptLineFilter{FromPeriod: "2030-01"})
	if err != nil {
		t.Fatalf("ListCustomers: %v", err)
	}
	if len(all) != 2 || all[0].SectorName != "Alto" || all[1].CustomerCode != "CHE001" {
		t.Fatalf("customers = %+v (deleted excluded, ordered by sector then code, periods ignored)", all)
	}
	scoped, _ := repo.ListCustomers(ctx, ports.ReceiptLineFilter{SectorID: "sec-1"})
	if len(scoped) != 1 || scoped[0].CommunityName != "Chetilla" {
		t.Fatalf("scoped customers = %+v", scoped)
	}
}

func TestListPaymentLines(t *testing.T) {
	repo := seedReportData(t)
	ctx := context.Background()
	month := time.Now().In(time.FixedZone("Lima", -5*3600)).Format("2006-01")

	lines, err := repo.ListPaymentLines(ctx, ports.ReceiptLineFilter{FromPeriod: month, ToPeriod: month})
	if err != nil {
		t.Fatalf("ListPaymentLines: %v", err)
	}
	if len(lines) != 1 {
		t.Fatalf("lines = %+v", lines)
	}
	l := lines[0]
	if l.CustomerCode != "CHE001" || l.SectorName != "Centro" || l.Period != "2026-08" || l.Amount != 10 || l.ReceiptNumber == 0 || l.Method != "CASH" {
		t.Fatalf("line = %+v", l)
	}
	if other, _ := repo.ListPaymentLines(ctx, ports.ReceiptLineFilter{SectorID: "sec-2"}); len(other) != 0 {
		t.Fatalf("sector filter ignored: %+v", other)
	}
	if past, _ := repo.ListPaymentLines(ctx, ports.ReceiptLineFilter{ToPeriod: "2020-01"}); len(past) != 0 {
		t.Fatalf("period filter ignored: %+v", past)
	}
}
