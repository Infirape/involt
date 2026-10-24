package excel

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

func collectionsFixture() ports.CollectionsWorkbookData {
	return ports.CollectionsWorkbookData{
		Report: &involtv1.GetCollectionsDashboardResponse{
			FromPeriod: "2026-08", ToPeriod: "2026-09",
			Totals: &involtv1.CollectionsDashboardTotals{Billed: 30, Collected: 18, TotalDebt: 12, OverdueDebt: 12, DebtorCount: 1,
				TemporaryCutCount: 2, NoPowerCount: 1},
			ByPeriod: []*involtv1.PeriodCollectionSummary{
				{Period: "2026-08", Billed: 20, Collected: 8}, {Period: "2026-09", Billed: 10, Collected: 10, CashIn: 18},
			},
			BySector: []*involtv1.SectorCollectionSummary{{SectorName: "Centro", CommunityName: "Chetilla", Billed: 30, Collected: 18, Debt: 12, Customers: 2, Debtors: 1}},
			Aging:    []*involtv1.AgingTotal{{Bucket: involtv1.AgingBucket_AGING_BUCKET_1_30, Amount: 12, Receipts: 1, Customers: 1}},
		},
		Receipts: []domain.ReceiptLine{
			{CustomerCode: "CHE001", CustomerName: "Ana", CommunityName: "Chetilla", SectorName: "Centro", Period: "2026-08",
				ServiceStatus: "TEMPORARY_CUT", Total: 20, Paid: 8, ExpirationDate: time.Date(2026, 9, 15, 0, 0, 0, 0, time.UTC)},
			{CustomerCode: "CHE002", CustomerName: "Beto", CommunityName: "Chetilla", SectorName: "Centro", Period: "2026-09",
				Total: 10, Paid: 10, ExpirationDate: time.Date(2026, 10, 15, 0, 0, 0, 0, time.UTC)},
		},
		Customers: []domain.CustomerLine{
			{CustomerCode: "CHE001", CustomerName: "Ana", CommunityName: "Chetilla", SectorName: "Centro", ServiceStatus: "TEMPORARY_CUT"},
			{CustomerCode: "CHE002", CustomerName: "Beto", CommunityName: "Chetilla", SectorName: "Centro"},
			{CustomerCode: "CHE003", CustomerName: "Caro", CommunityName: "Chetilla", SectorName: "Centro", ServiceStatus: "NO_POWER"},
		},
		Payments: []domain.PaymentLine{
			{ReceiptNumber: 7, PaidAt: time.Date(2026, 9, 2, 15, 0, 0, 0, time.UTC), Method: "CASH", CollectedByEmail: "caja@x.pe",
				CustomerCode: "CHE001", CustomerName: "Ana", CommunityName: "Chetilla", SectorName: "Centro", Period: "2026-08", Amount: 7, LateFee: 1,
				ServiceStatus: "TEMPORARY_CUT"},
			{ReceiptNumber: 8, PaidAt: time.Date(2026, 10, 1, 4, 0, 0, 0, time.UTC), Method: "YAPE", CollectedByEmail: "caja@x.pe",
				CustomerCode: "CHE002", CustomerName: "Beto", CommunityName: "Chetilla", SectorName: "Centro", Period: "2026-09", Amount: 10},
		},
	}
}

func TestCollectionsWorkbook(t *testing.T) {
	data, err := NewGenerator().CollectionsWorkbook(context.Background(), collectionsFixture(), testMeta("Resumen de cobranza"))
	if err != nil {
		t.Fatalf("CollectionsWorkbook: %v", err)
	}
	f, charts := openWorkbook(t, data)
	// The weekly treasury report is its own workbook (RemittanceWorkbook), not a sheet here.
	want := "Resumen,PorCaserio,Suministros,Pagos,TD_Pagos,TD_Suministros"
	if got := strings.Join(f.GetSheetList(), ","); got != want {
		t.Fatalf("sheets = %s", got)
	}
	if f.GetActiveSheetIndex() != 0 {
		t.Fatal("the workbook must open on Resumen")
	}
	if len(charts) != 3 {
		t.Fatalf("charts = %v, want 3", charts)
	}
	for _, sheet := range []string{"TD_Pagos", "TD_Suministros"} {
		if pivots, err := f.GetPivotTables(sheet); err != nil || len(pivots) != 1 {
			t.Fatalf("%s pivots = %d (%v), want 1", sheet, len(pivots), err)
		}
	}
	if pivots, _ := f.GetPivotTables("TD_Suministros"); len(pivots[0].Data) != 2 {
		t.Fatalf("TD_Suministros must sum paid and balance, got %v", pivots[0].Data)
	}
	if panes, _ := f.GetPanes("PorCaserio"); panes.Freeze {
		t.Fatal("sheets with charts must not freeze panes")
	}
}

func TestSuministrosSheetHasEverySupplyForEveryMonth(t *testing.T) {
	data, _ := NewGenerator().CollectionsWorkbook(context.Background(), collectionsFixture(), testMeta("x"))
	f, _ := openWorkbook(t, data)
	rows, _ := f.GetRows("Suministros")
	if len(rows) != 1+3*2 {
		t.Fatalf("rows = %d, want header + 3 supplies × 2 months", len(rows)-1)
	}
	// Columns: Caserío, Comunidad, Código, Cliente, Suministro, Periodo, Mes, Facturado, Pagado, Saldo,
	// Estado, Servicio, Vencimiento, Días de atraso, Servicio desde
	byKey := map[string][]string{}
	for _, r := range rows[1:] {
		byKey[r[2]+"|"+r[5]] = r
	}
	if r := byKey["CHE001|2026-08"]; r[10] != "Vencido" || r[9] != "S/ 12.00" || r[4] != "CHE001 - Ana" {
		t.Fatalf("Ana Aug = %v", r)
	}
	if r := byKey["CHE001|2026-08"]; r[12] != "15/09/2026" || r[13] != "28" {
		t.Fatalf("due date and days overdue (merged from the old Recibos sheet) = %v", r)
	}
	if r := byKey["CHE003|2026-09"]; r[11] != "Sin energía" {
		t.Fatalf("service status column = %v", r)
	}
	if r := byKey["CHE003|2026-09"]; r[10] != "Sin recibo" || r[8] != "S/ 0.00" {
		t.Fatalf("supply without receipts must still appear: %v", r)
	}
}

func TestPagosSheetUsesLimaPaymentMonthAndWeek(t *testing.T) {
	data, _ := NewGenerator().CollectionsWorkbook(context.Background(), collectionsFixture(), testMeta("x"))
	f, _ := openWorkbook(t, data)
	rows, _ := f.GetRows("Pagos")
	if len(rows) != 3 {
		t.Fatalf("payment rows = %v", rows)
	}
	// Columns: Fecha, Semana, Mes de pago, N°, Código, Cliente, Caserío, Comunidad, Periodo, Medio,
	// Cobrado por, Monto, Mora, Total, Servicio, Suministro
	if rows[1][0] != "02/09/2026" || rows[1][1] != "SEM 1 · 1 al 6 de septiembre de 2026" || rows[1][2] != "2026-09" ||
		rows[1][3] != "000007" || rows[1][13] != "S/ 8.00" || rows[1][9] != "Efectivo" {
		t.Fatalf("first payment = %v", rows[1])
	}
	if rows[2][2] != "2026-09" || rows[2][1] != "SEM 5 · 28 al 30 de septiembre de 2026" {
		t.Fatalf("04:00 UTC on Oct 1 is still Sep 30 in Lima, got %v", rows[2])
	}
}
