package excel

import (
	"context"
	"fmt"

	"github.com/xuri/excelize/v2"

	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

var monthsShort = []string{"Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"}

func periodLabel(period string) string {
	var y, m int
	if _, err := fmt.Sscanf(period, "%d-%d", &y, &m); err != nil || m < 1 || m > 12 {
		return period
	}
	return fmt.Sprintf("%s %d", monthsShort[m-1], y)
}

var agingLabels = map[involtv1.AgingBucket]string{
	involtv1.AgingBucket_AGING_BUCKET_CURRENT: "Por vencer",
	involtv1.AgingBucket_AGING_BUCKET_1_30:    "1-30 días",
	involtv1.AgingBucket_AGING_BUCKET_31_60:   "31-60 días",
	involtv1.AgingBucket_AGING_BUCKET_61_90:   "61-90 días",
	involtv1.AgingBucket_AGING_BUCKET_OVER_90: "Más de 90 días",
}

var statusLabels = map[domain.ReceiptStatus]string{
	domain.ReceiptStatusPaid: "Pagado", domain.ReceiptStatusPartial: "Parcial",
	domain.ReceiptStatusPending: "Pendiente", domain.ReceiptStatusOverdue: "Vencido",
}

func ratio(part, whole float64) float64 {
	if whole <= 0 {
		return 0
	}
	return part / whole
}

// CollectionsWorkbook: Resumen (KPIs, monthly and aging tables + charts), PorCaserio, the
// detail sheets (Suministros, Pagos, Recibos) and one pivot table per TD_* sheet.
func (g *Generator) CollectionsWorkbook(_ context.Context, data ports.CollectionsWorkbookData, meta ports.WorkbookMeta) ([]byte, error) {
	b, err := newBook()
	if err != nil {
		return nil, err
	}
	f := b.f
	_ = f.SetSheetName("Sheet1", "Resumen")
	for _, s := range []string{"PorCaserio", "Suministros", "Pagos", "Recibos"} {
		_, _ = f.NewSheet(s)
	}
	if err := writeCollectionsSummary(b, data.Report, meta); err != nil {
		return nil, err
	}
	if err := writeSectorSheet(b, data.Report.BySector); err != nil {
		return nil, err
	}
	if err := writeCollectionsDetail(b, data, meta); err != nil {
		return nil, err
	}
	return b.bytes()
}

func writeCollectionsSummary(b *book, r *involtv1.GetCollectionsDashboardResponse, meta ports.WorkbookMeta) error {
	const sheet = "Resumen"
	t := r.GetTotals()
	row := b.writeHeader(sheet, meta)
	kpiStart := row
	row = b.writeKPIs(sheet, row, []kpi{
		{"Facturado", t.GetBilled(), true}, {"Cobrado", t.GetCollected(), true},
		{"% de cobranza", ratio(t.GetCollected(), t.GetBilled()), false},
		{"Deuda total (todos los periodos)", t.GetTotalDebt(), true}, {"Deuda vencida", t.GetOverdueDebt(), true},
		{"Clientes con deuda", t.GetDebtorCount(), false}, {"Candidatos a corte", t.GetCutCandidates(), false},
	})
	_ = b.f.SetCellStyle(sheet, cell(2, kpiStart+2), cell(2, kpiStart+2), b.pct)
	_ = b.f.SetColWidth(sheet, "A", "A", 30)
	_ = b.f.SetColWidth(sheet, "B", "E", 15)

	cols := []column{{"Mes", 0, 0}, {"Facturado", 0, b.money}, {"Cobrado", 0, b.money}, {"% cobranza", 0, b.pct}, {"Ingresó a caja", 0, b.money}}
	monthRows := make([][]any, len(r.ByPeriod))
	for i, p := range r.ByPeriod {
		monthRows[i] = []any{periodLabel(p.Period), p.Billed, p.Collected, ratio(p.Collected, p.Billed), p.CashIn}
	}
	start := row
	_, next, err := b.writeTable(sheet, "PorMes", start, cols, monthRows)
	if err != nil {
		return err
	}
	if err := b.barChart(sheet, "G5", "Facturado vs cobrado por mes", excelize.Col, start, start+1, start+len(monthRows), 1, []int{2, 3}); err != nil {
		return err
	}

	agingCols := []column{{"Antigüedad", 0, 0}, {"Monto (S/)", 0, b.money}, {"Recibos", 0, b.int}, {"Clientes", 0, b.int}}
	agingRows := make([][]any, len(r.Aging))
	for i, a := range r.Aging {
		agingRows[i] = []any{agingLabels[a.Bucket], a.Amount, a.Receipts, a.Customers}
	}
	if _, _, err := b.writeTable(sheet, "Antiguedad", next, agingCols, agingRows); err != nil {
		return err
	}
	return b.barChart(sheet, "G22", "Antigüedad de la deuda", excelize.Col, next, next+1, next+len(agingRows), 1, []int{2})
}

func writeSectorSheet(b *book, sectors []*involtv1.SectorCollectionSummary) error {
	const sheet = "PorCaserio"
	cols := []column{
		{"Comunidad", 16, 0}, {"Caserío", 22, 0}, {"Facturado", 13, b.money}, {"Cobrado", 13, b.money},
		{"% cobranza", 11, b.pct}, {"Deuda", 13, b.money}, {"Clientes", 10, b.int}, {"Morosos", 10, b.int},
	}
	rows := make([][]any, len(sectors))
	for i, s := range sectors {
		rows[i] = []any{s.CommunityName, s.SectorName, s.Billed, s.Collected, ratio(s.Collected, s.Billed), s.Debt, s.Customers, s.Debtors}
	}
	if _, _, err := b.writeTable(sheet, "TablaCaserios", 1, cols, rows); err != nil {
		return err
	}
	return b.barChart(sheet, "J2", "Cobrado vs facturado por caserío", excelize.Col, 1, 2, 1+len(rows), 2, []int{3, 4})
}
