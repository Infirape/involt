package excel

import (
	"context"
	"fmt"
	"sort"
	"time"

	"github.com/xuri/excelize/v2"

	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

var agingRanges = []string{"Por vencer", "1-30 días", "31-60 días", "61-90 días", "Más de 90 días"}

func agingRange(days int32) string {
	switch {
	case days <= 0:
		return agingRanges[0]
	case days <= 30:
		return agingRanges[1]
	case days <= 60:
		return agingRanges[2]
	case days <= 90:
		return agingRanges[3]
	}
	return agingRanges[4]
}

func agreementLabel(d *involtv1.DebtorRow) string {
	switch {
	case d.AgreementInDefault:
		return "En mora"
	case d.InAgreement:
		return "Al día"
	}
	return "Sin convenio"
}

func yesNo(v bool) string {
	if v {
		return "Sí"
	}
	return "No"
}

// isoToTime parses RFC3339 timestamps into Lima dates for Excel date cells ("" stays empty).
func isoToTime(iso string) any {
	t, err := time.Parse(time.RFC3339, iso)
	if err != nil {
		return ""
	}
	l := t.In(lima)
	return time.Date(l.Year(), l.Month(), l.Day(), 0, 0, 0, 0, time.UTC)
}

// DebtorsWorkbook: Resumen (KPIs, debt by caserío and by aging + charts), Morosos (detail
// table) and Dinamica (pivot tables).
func (g *Generator) DebtorsWorkbook(_ context.Context, report *involtv1.GetDebtorsResponse, meta ports.WorkbookMeta) ([]byte, error) {
	b, err := newBook()
	if err != nil {
		return nil, err
	}
	f := b.f
	_ = f.SetSheetName("Sheet1", "Resumen")
	_, _ = f.NewSheet("Morosos")
	_, _ = f.NewSheet("Dinamica")

	detailRange, err := writeDebtorDetail(b, report.Debtors)
	if err != nil {
		return nil, err
	}
	if err := writeDebtorSummary(b, report, meta); err != nil {
		return nil, err
	}

	_ = f.SetCellValue("Dinamica", "A1", "Tablas dinámicas (actualizables desde Excel)")
	_ = f.SetCellStyle("Dinamica", "A1", "A1", b.title)
	has := len(report.Debtors) > 0
	if err := b.pivot("Dinamica", "A3", detailRange, "DeudaPorCaserio", has,
		[]excelize.PivotTableField{{Data: "Comunidad"}, {Data: "Caserío"}},
		[]excelize.PivotTableField{{Data: "Rango de atraso"}},
		[]excelize.PivotTableField{{Data: "Deuda total", Name: "Deuda total (S/)", Subtotal: "Sum"}},
	); err != nil {
		return nil, fmt.Errorf("debt pivot: %w", err)
	}
	if err := b.pivot("Dinamica", "J3", detailRange, "CortePorCaserio", has,
		[]excelize.PivotTableField{{Data: "Caserío"}},
		[]excelize.PivotTableField{{Data: "Candidato a corte"}},
		[]excelize.PivotTableField{{Data: "Código", Name: "Clientes", Subtotal: "Count"}},
	); err != nil {
		return nil, fmt.Errorf("cut pivot: %w", err)
	}
	return b.bytes()
}

func writeDebtorDetail(b *book, debtors []*involtv1.DebtorRow) (string, error) {
	cols := []column{
		{"Código", 10, 0}, {"Cliente", 34, 0}, {"Comunidad", 16, 0}, {"Caserío", 18, 0},
		{"Deuda total", 13, b.money}, {"Deuda vencida", 13, b.money}, {"Recibos pendientes", 10, b.int},
		{"Recibos vencidos", 10, b.int}, {"Vencido desde", 13, 0}, {"Días de atraso", 10, b.int},
		{"Rango de atraso", 15, 0}, {"Último pago", 13, b.day}, {"Convenio", 13, 0}, {"Candidato a corte", 12, 0},
		{"Estado de servicio", 15, 0},
	}
	rows := make([][]any, 0, len(debtors))
	for _, d := range debtors {
		rows = append(rows, []any{
			d.CustomerCode, d.CustomerName, d.CommunityName, d.SectorName, d.TotalDebt, d.OverdueDebt,
			d.PendingReceipts, d.OverdueReceipts, d.OldestOverduePeriod, d.DaysOverdue, agingRange(d.DaysOverdue),
			isoToTime(d.LastPaymentAt), agreementLabel(d), yesNo(d.CutCandidate), protoServiceLabel(d.ServiceStatus),
		})
	}
	ref, _, err := b.writeTable("Morosos", "TablaMorosos", 1, cols, rows)
	if err != nil {
		return "", err
	}
	b.freezeHeader("Morosos", 1)
	return "Morosos!" + ref, nil
}

type bucketTotal struct {
	label     string
	debt      float64
	customers int
}

func writeDebtorSummary(b *book, report *involtv1.GetDebtorsResponse, meta ports.WorkbookMeta) error {
	const sheet = "Resumen"
	row := b.writeHeader(sheet, meta)
	var cut, noPower int
	for _, d := range report.Debtors {
		switch d.ServiceStatus {
		case involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT:
			cut++
		case involtv1.ServiceStatus_SERVICE_STATUS_NO_POWER:
			noPower++
		}
	}
	row = b.writeKPIs(sheet, row, []kpi{
		{"Clientes con deuda", len(report.Debtors), false},
		{"Deuda total", report.TotalDebt, true},
		{"Deuda vencida", report.OverdueDebt, true},
		{"Candidatos a corte", report.CutCandidates, false},
		{"Morosos en corte temporal", cut, false},
		{"Morosos sin energía", noPower, false},
	})
	_ = b.f.SetColWidth(sheet, "A", "A", 24)
	_ = b.f.SetColWidth(sheet, "B", "D", 16)

	bySector := map[string]*bucketTotal{}
	aging := make([]bucketTotal, len(agingRanges))
	for i, r := range agingRanges {
		aging[i].label = r
	}
	for _, d := range report.Debtors {
		s, ok := bySector[d.SectorName]
		if !ok {
			s = &bucketTotal{label: d.SectorName}
			bySector[d.SectorName] = s
		}
		s.debt += d.TotalDebt
		s.customers++
		for i, r := range agingRanges {
			if r == agingRange(d.DaysOverdue) {
				aging[i].debt += d.TotalDebt
				aging[i].customers++
			}
		}
	}
	sectors := make([]bucketTotal, 0, len(bySector))
	for _, s := range bySector {
		sectors = append(sectors, *s)
	}
	sort.Slice(sectors, func(i, j int) bool { return sectors[i].debt > sectors[j].debt })

	cols := []column{{"Caserío", 0, 0}, {"Deuda (S/)", 0, b.money}, {"Clientes", 0, b.int}}
	sectorStart := row
	sectorRows := make([][]any, len(sectors))
	for i, s := range sectors {
		sectorRows[i] = []any{s.label, s.debt, s.customers}
	}
	_, next, err := b.writeTable(sheet, "DeudaCaserio", row, cols, sectorRows)
	if err != nil {
		return err
	}
	if err := b.barChart(sheet, "F5", "Deuda por caserío", excelize.Col, sectorStart, sectorStart+1, sectorStart+len(sectors), 1, []int{2}); err != nil {
		return err
	}

	agingStart := next
	agingRows := make([][]any, len(aging))
	for i, a := range aging {
		agingRows[i] = []any{a.label, a.debt, a.customers}
	}
	cols[0].name = "Rango de atraso"
	if _, _, err := b.writeTable(sheet, "DeudaAtraso", agingStart, cols, agingRows); err != nil {
		return err
	}
	return b.barChart(sheet, "F22", "Deuda por antigüedad", excelize.Col, agingStart, agingStart+1, agingStart+len(aging), 1, []int{2})
}

var serviceLabels = map[string]string{"ACTIVE": "Con servicio", "TEMPORARY_CUT": "Corte temporal", "NO_POWER": "Sin energía"}

// serviceLabel names a stored service status; empty (older rows) means active.
func serviceLabel(raw string) string {
	if l, ok := serviceLabels[raw]; ok {
		return l
	}
	return serviceLabels["ACTIVE"]
}

func protoServiceLabel(s involtv1.ServiceStatus) string {
	switch s {
	case involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT:
		return serviceLabels["TEMPORARY_CUT"]
	case involtv1.ServiceStatus_SERVICE_STATUS_NO_POWER:
		return serviceLabels["NO_POWER"]
	}
	return serviceLabels["ACTIVE"]
}
