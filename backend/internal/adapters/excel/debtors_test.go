package excel

import (
	"archive/zip"
	"bytes"
	"context"
	"io"
	"strings"
	"testing"
	"time"

	"github.com/xuri/excelize/v2"

	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

func testMeta(title string) ports.WorkbookMeta {
	return ports.WorkbookMeta{
		Entity: "MUNICIPALIDAD DISTRITAL DE CHETILLA", Company: "HIDROELECTRICA QARWAQIRU", Title: title,
		Filters:     [][2]string{{"Comunidad", "Todas"}},
		GeneratedAt: time.Date(2026, 10, 13, 15, 0, 0, 0, time.UTC), GeneratedBy: "admin@infira.pe",
	}
}

// openWorkbook re-reads the generated file and lists the chart parts inside the zip.
func openWorkbook(t *testing.T, data []byte) (*excelize.File, []string) {
	t.Helper()
	f, err := excelize.OpenReader(bytes.NewReader(data))
	if err != nil {
		t.Fatalf("generated workbook does not open: %v", err)
	}
	zr, err := zip.NewReader(bytes.NewReader(data), int64(len(data)))
	if err != nil {
		t.Fatalf("not a zip: %v", err)
	}
	var charts []string
	for _, zf := range zr.File {
		if !strings.HasPrefix(zf.Name, "xl/charts/chart") {
			continue
		}
		charts = append(charts, zf.Name)
		rc, _ := zf.Open()
		xml, _ := io.ReadAll(rc)
		_ = rc.Close()
		if strings.Contains(string(xml), `<barDir val="bar">`) {
			t.Fatalf("%s is a horizontal bar chart; Numbers crashes rendering excelize bar charts", zf.Name)
		}
		if strings.Contains(string(xml), `<varyColors val="1">`) {
			t.Fatalf("%s varies colors per point; Numbers crashes styling those series", zf.Name)
		}
	}
	return f, charts
}

func TestDebtorsWorkbook(t *testing.T) {
	report := &involtv1.GetDebtorsResponse{
		Debtors: []*involtv1.DebtorRow{
			{CustomerCode: "CHE001", CustomerName: "Ana Luz", CommunityName: "Chetilla", SectorName: "Centro",
				TotalDebt: 26, OverdueDebt: 16, PendingReceipts: 3, OverdueReceipts: 2, OldestOverduePeriod: "2026-06",
				DaysOverdue: 90, LastPaymentAt: "2026-09-01T15:00:00Z", CutCandidate: true},
			{CustomerCode: "ALT001", CustomerName: "Caro", CommunityName: "Chetilla", SectorName: "Alto",
				TotalDebt: 12, OverdueDebt: 12, PendingReceipts: 1, OverdueReceipts: 1, OldestOverduePeriod: "2026-08",
				DaysOverdue: 23, InAgreement: true, ServiceStatus: involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT},
		},
		TotalDebt: 38, OverdueDebt: 28, CutCandidates: 1,
	}

	data, err := NewGenerator().DebtorsWorkbook(context.Background(), report, testMeta("Reporte de morosos"))
	if err != nil {
		t.Fatalf("DebtorsWorkbook: %v", err)
	}
	f, charts := openWorkbook(t, data)

	if got := f.GetSheetList(); strings.Join(got, ",") != "Resumen,Morosos,Dinamica" {
		t.Fatalf("sheets = %v", got)
	}
	rows, _ := f.GetRows("Morosos")
	if len(rows) != 3 || rows[1][1] != "Ana Luz" {
		t.Fatalf("detail rows = %v", rows)
	}
	summary, _ := f.GetRows("Resumen")
	kpis := map[string]string{}
	for _, r := range summary {
		if len(r) >= 2 {
			kpis[r[0]] = r[1]
		}
	}
	if kpis["Morosos en corte temporal"] != "1" || kpis["Morosos sin energía"] != "0" {
		t.Fatalf("debtor summary must count service statuses, got %v", kpis)
	}
	if rows[1][14] != "Con servicio" || rows[2][14] != "Corte temporal" {
		t.Fatalf("service status column = %q / %q", rows[1][14], rows[2][14])
	}
	if rows[1][10] != "61-90 días" || rows[2][12] != "Al día" {
		t.Fatalf("derived columns = %v / %v", rows[1], rows[2])
	}
	pivots, err := f.GetPivotTables("Dinamica")
	if err != nil || len(pivots) != 2 {
		t.Fatalf("pivot tables = %d (%v), want 2", len(pivots), err)
	}
	if len(charts) != 2 {
		t.Fatalf("charts = %v, want 2", charts)
	}
}

func TestDebtorsWorkbookWithoutRows(t *testing.T) {
	data, err := NewGenerator().DebtorsWorkbook(context.Background(), &involtv1.GetDebtorsResponse{}, testMeta("Reporte de morosos"))
	if err != nil {
		t.Fatalf("empty report should still render: %v", err)
	}
	f, _ := openWorkbook(t, data)
	if v, _ := f.GetCellValue("Dinamica", "A3"); v == "" {
		t.Fatal("empty pivot sheet should explain there is no data")
	}
}

func TestAgingRangeLabel(t *testing.T) {
	cases := map[int32]string{0: "Por vencer", 1: "1-30 días", 30: "1-30 días", 31: "31-60 días", 90: "61-90 días", 91: "Más de 90 días"}
	for days, want := range cases {
		if got := agingRange(days); got != want {
			t.Fatalf("agingRange(%d) = %q, want %q", days, got, want)
		}
	}
}

// hasLogo reports whether the sheet has a picture anchored at cell.
func hasLogo(t *testing.T, f *excelize.File, sheet, cell string) bool {
	t.Helper()
	pics, err := f.GetPictures(sheet, cell)
	return err == nil && len(pics) == 1
}

func TestWorkbooksCarryTheMunicipalLogo(t *testing.T) {
	g := NewGenerator()
	ctx := context.Background()
	debtors, _ := g.DebtorsWorkbook(ctx, &involtv1.GetDebtorsResponse{}, testMeta("x"))
	closing, _ := g.CashClosingWorkbook(ctx, &involtv1.GetCashClosingResponse{}, testMeta("x"))
	collections, _ := g.CollectionsWorkbook(ctx, collectionsFixture(), testMeta("x"))
	remit, _ := g.RemittanceWorkbook(ctx, ports.RemittanceData{Lines: collectionsFixture().Payments}, testMeta("x"))
	for name, c := range map[string]struct {
		data        []byte
		sheet, cell string
	}{
		"morosos": {debtors, "Resumen", "F1"}, "cierre": {closing, "Resumen", "F1"},
		"cobranzas": {collections, "Resumen", "F1"}, "rendición": {remit, "Rendición", "J2"},
	} {
		f, _ := openWorkbook(t, c.data)
		if !hasLogo(t, f, c.sheet, c.cell) {
			t.Fatalf("%s: no logo at %s!%s", name, c.sheet, c.cell)
		}
	}
}
