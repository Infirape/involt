package excel

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/xuri/excelize/v2"

	"github.com/infira/involt/backend/internal/ports"
)

// remittance renders the workbook and indexes the Rendición rows (raw values) by their first
// and second cells, so tests can find section, payment and total rows.
func remittance(t *testing.T, data ports.RemittanceData) map[string][]string {
	t.Helper()
	out, err := NewGenerator().RemittanceWorkbook(context.Background(), data, testMeta("Rendición semanal"))
	if err != nil {
		t.Fatalf("RemittanceWorkbook: %v", err)
	}
	f, _ := openWorkbook(t, out)
	if got := strings.Join(f.GetSheetList(), ","); got != "Rendición,Pagos" {
		t.Fatalf("sheets = %s", got)
	}
	if f.GetActiveSheetIndex() != 0 {
		t.Fatal("the workbook must open on Rendición")
	}
	rows, _ := f.GetRows("Rendición", excelize.Options{RawCellValue: true})
	byKey := map[string][]string{}
	for _, r := range rows {
		for i := 0; i < len(r) && i < 2; i++ {
			if r[i] != "" {
				byKey[r[i]] = append(r, make([]string, 11)...)
			}
		}
	}
	return byKey
}

func TestRendicionLayoutFollowsTheLedgerTemplate(t *testing.T) {
	out, _ := NewGenerator().RemittanceWorkbook(context.Background(), ports.RemittanceData{Lines: collectionsFixture().Payments}, testMeta("x"))
	f, _ := openWorkbook(t, out)
	rows, _ := f.GetRows("Rendición")
	var groups, header []string
	for _, r := range rows {
		if len(r) > 0 && r[0] == "FECHA" {
			header = r
		}
		if len(r) > 6 && r[6] == "MONTOS" {
			groups = r
		}
	}
	if strings.Join(header, "|") != "FECHA|N° COMPROBANTE|SUMINISTRO|CASERÍO|PERIODOS|MEDIO|MONTO|MORA|TOTAL|ACUMULADO SEMANA|ACUMULADO GENERAL" {
		t.Fatalf("column header = %v", header)
	}
	if len(groups) < 10 || groups[9] != "ACUMULADO" {
		t.Fatalf("group header = %v", groups)
	}
	if v, _ := f.GetCellValue("Rendición", "A1"); v != "RENDICIÓN SEMANAL DE COBRANZA" {
		t.Fatalf("title = %q", v)
	}
	if show, _ := f.GetSheetView("Rendición", 0); show.ShowGridLines == nil || *show.ShowGridLines {
		t.Fatal("the ledger sheet hides gridlines")
	}
}

func TestRendicionListsEveryPaymentUnderItsWeek(t *testing.T) {
	rows := remittance(t, ports.RemittanceData{Lines: collectionsFixture().Payments})
	if r := rows["SEMANA 1"]; r[6] != "DEL 1 AL 6 DE SEPTIEMBRE DE 2026" {
		t.Fatalf("week 1 section = %v", r)
	}
	if r := rows["SEMANA 5"]; r[6] != "DEL 28 AL 30 DE SEPTIEMBRE DE 2026" {
		t.Fatalf("week 5 must stop at the end of the month: %v", r)
	}
	// Columns: Fecha, N° comprobante, Suministro, Caserío, Periodos, Medio, Monto, Mora, Total, Acum. semana, Acum. general
	if r := rows["000007"]; r[2] != "CHE001 - Ana" || r[5] != "Efectivo" || r[6] != "7" || r[7] != "1" || r[8] != "8" || r[10] != "8" {
		t.Fatalf("payment row = %v", r)
	}
	if r := rows["000008"]; r[9] != "10" || r[10] != "18" {
		t.Fatalf("running totals (week, general) = %v", r)
	}
	if r := rows["TOTAL SEMANA 1 · 1 pago"]; r[8] != "8" {
		t.Fatalf("week subtotal = %v", r)
	}
	if r := rows["TOTAL GENERAL · 2 pagos"]; r[6] != "17" || r[7] != "1" || r[8] != "18" {
		t.Fatalf("grand total = %v", r)
	}
	if r := rows["Yape · 1 pago"]; r[8] != "10" {
		t.Fatalf("total by method = %v", r)
	}
}

func TestRendicionGroupsSplitPaymentsIntoOneRow(t *testing.T) {
	fx := collectionsFixture()
	// One payment (receipt 7) that covered two monthly bills is two allocation lines.
	extra := fx.Payments[0]
	extra.Period, extra.Amount, extra.LateFee = "2026-09", 3, 0
	fx.Payments = append(fx.Payments, extra)
	rows := remittance(t, ports.RemittanceData{Lines: fx.Payments})
	if r := rows["000007"]; r[4] != "2026-08, 2026-09" || r[8] != "11" {
		t.Fatalf("split payment = %v, want one row for both periods", r)
	}
	if _, ok := rows["TOTAL GENERAL · 2 pagos"]; !ok {
		t.Fatalf("grand total must count receipts: %v", rows)
	}
}

func TestRendicionListsEachPeriodOnce(t *testing.T) {
	fx := collectionsFixture()
	fx.Payments = append(fx.Payments, fx.Payments[0]) // receipt 7 again, another bill of the same period
	rows := remittance(t, ports.RemittanceData{Lines: fx.Payments})
	if r := rows["000007"]; r[4] != "2026-08" || r[8] != "16" {
		t.Fatalf("periods must not repeat (amounts still add up): %v", r)
	}
}

func TestRendicionFollowsTheChosenRange(t *testing.T) {
	day := func(d int) time.Time { return time.Date(2026, 9, d, 0, 0, 0, 0, time.UTC) }
	rows := remittance(t, ports.RemittanceData{Lines: collectionsFixture().Payments[:1], From: day(2), To: day(9)})
	if r := rows["SEMANA 1"]; r[6] != "DEL 2 AL 6 DE SEPTIEMBRE DE 2026" {
		t.Fatalf("week 1 must start at the range start: %v", r)
	}
	if r := rows["SEMANA 2"]; r[6] != "DEL 7 AL 9 DE SEPTIEMBRE DE 2026" {
		t.Fatalf("week 2 must end at the range end: %v", r)
	}
	if _, ok := rows["TOTAL SEMANA 2 · 0 pagos"]; !ok {
		t.Fatal("an empty week still shows its subtotal")
	}
	if _, ok := rows["Sin pagos en esta semana"]; !ok {
		t.Fatal("an empty week says so")
	}
}

func TestRemittanceWorkbookWithoutPayments(t *testing.T) {
	if _, err := NewGenerator().RemittanceWorkbook(context.Background(), ports.RemittanceData{}, testMeta("x")); err != nil {
		t.Fatalf("an empty range must still render: %v", err)
	}
}

func TestWeekOfRunsMondayToSundayWithinTheMonth(t *testing.T) {
	cases := map[time.Time]string{
		time.Date(2026, 10, 5, 12, 0, 0, 0, time.UTC): "SEM 2 · 5 al 11 de octubre de 2026", // Monday
		time.Date(2026, 10, 12, 4, 0, 0, 0, time.UTC): "SEM 2 · 5 al 11 de octubre de 2026", // Sunday 23:00 in Lima
		time.Date(2026, 10, 1, 12, 0, 0, 0, time.UTC): "SEM 1 · 1 al 4 de octubre de 2026",  // Thursday
		time.Date(2026, 8, 31, 12, 0, 0, 0, time.UTC): "SEM 6 · 31 de agosto de 2026",       // a lone Monday
		time.Date(2027, 1, 1, 12, 0, 0, 0, time.UTC):  "SEM 1 · 1 al 3 de enero de 2027",
	}
	for at, want := range cases {
		if got := weekOf(at, time.Time{}, time.Time{}).label; got != want {
			t.Fatalf("weekOf(%v) = %q, want %q", at, got, want)
		}
	}
}
