package excel

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/xuri/excelize/v2"

	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

var methodLabels = map[involtv1.PaymentMethod]string{
	involtv1.PaymentMethod_PAYMENT_METHOD_CASH:     "Efectivo",
	involtv1.PaymentMethod_PAYMENT_METHOD_YAPE:     "Yape",
	involtv1.PaymentMethod_PAYMENT_METHOD_PLIN:     "Plin",
	involtv1.PaymentMethod_PAYMENT_METHOD_TRANSFER: "Transferencia",
	involtv1.PaymentMethod_PAYMENT_METHOD_OTHER:    "Otro",
}

func methodLabel(m involtv1.PaymentMethod) string {
	if l, ok := methodLabels[m]; ok {
		return l
	}
	return "—"
}

// CashClosingWorkbook: Resumen (KPIs, totals by method and collector + charts), Pagos (detail)
// and Dinamica (collector × method and daily pivots over valid amounts).
func (g *Generator) CashClosingWorkbook(_ context.Context, report *involtv1.GetCashClosingResponse, meta ports.WorkbookMeta) ([]byte, error) {
	b, err := newBook()
	if err != nil {
		return nil, err
	}
	f := b.f
	_ = f.SetSheetName("Sheet1", "Resumen")
	_, _ = f.NewSheet("Pagos")
	_, _ = f.NewSheet("Dinamica")

	detail, err := writePaymentDetail(b, report.Payments)
	if err != nil {
		return nil, err
	}
	if err := writeClosingSummary(b, report, meta); err != nil {
		return nil, err
	}

	_ = f.SetCellValue("Dinamica", "A1", "Tablas dinámicas (solo pagos válidos)")
	_ = f.SetCellStyle("Dinamica", "A1", "A1", b.title)
	has := len(report.Payments) > 0
	valid := []excelize.PivotTableField{{Data: "Monto válido", Name: "Cobrado (S/)", Subtotal: "Sum"}}
	if err := b.pivot("Dinamica", "A3", detail, "CobradorMedio", has,
		[]excelize.PivotTableField{{Data: "Cobrado por"}}, []excelize.PivotTableField{{Data: "Medio"}}, valid); err != nil {
		return nil, fmt.Errorf("collector pivot: %w", err)
	}
	if err := b.pivot("Dinamica", "J3", detail, "CobroDiario", has,
		[]excelize.PivotTableField{{Data: "Fecha"}}, nil, valid); err != nil {
		return nil, fmt.Errorf("daily pivot: %w", err)
	}
	return b.bytes()
}

func writePaymentDetail(b *book, payments []*involtv1.Payment) (string, error) {
	cols := []column{
		{"N° comprobante", 12, 0}, {"Fecha", 12, b.day}, {"Hora", 8, 0}, {"Código", 10, 0}, {"Cliente", 32, 0},
		{"Periodos", 22, 0}, {"Medio", 13, 0}, {"Referencia", 14, 0}, {"Cobrado por", 26, 0},
		{"Monto", 12, b.money}, {"Mora incluida", 12, b.money}, {"Monto válido", 12, b.money},
		{"Estado", 10, 0}, {"Motivo anulación", 24, 0},
	}
	rows := make([][]any, 0, len(payments))
	for _, p := range payments {
		var periods []string
		var fee float64
		for _, a := range p.Allocations {
			periods = append(periods, a.Period)
			fee += a.LateFee
		}
		paidAt, _ := time.Parse(time.RFC3339, p.PaidAt)
		valid, status := p.Amount, "Válido"
		if p.Voided {
			valid, status = 0, "Anulado"
		}
		rows = append(rows, []any{
			fmt.Sprintf("%06d", p.ReceiptNumber), isoToTime(p.PaidAt), paidAt.In(lima).Format("15:04"),
			p.CustomerCode, p.CustomerName, strings.Join(periods, ", "), methodLabel(p.Method), p.Reference,
			p.CollectedByEmail, p.Amount, fee, valid, status, p.VoidReason,
		})
	}
	ref, _, err := b.writeTable("Pagos", "TablaPagos", 1, cols, rows)
	if err != nil {
		return "", err
	}
	b.freezeHeader("Pagos", 1)
	return "Pagos!" + ref, nil
}

func writeClosingSummary(b *book, report *involtv1.GetCashClosingResponse, meta ports.WorkbookMeta) error {
	const sheet = "Resumen"
	row := b.writeHeader(sheet, meta)
	row = b.writeKPIs(sheet, row, []kpi{
		{"Total cobrado", report.TotalAmount, true},
		{"Pagos válidos", report.PaymentCount, false},
		{"Monto anulado (no suma)", report.VoidedAmount, true},
		{"Comprobantes anulados", report.VoidedCount, false},
	})
	_ = b.f.SetColWidth(sheet, "A", "A", 26)
	_ = b.f.SetColWidth(sheet, "B", "C", 16)

	cols := []column{{"Medio de pago", 0, 0}, {"Monto (S/)", 0, b.money}, {"Pagos", 0, b.int}}
	methodRows := make([][]any, len(report.ByMethod))
	for i, m := range report.ByMethod {
		methodRows[i] = []any{methodLabel(m.Method), m.Amount, m.Count}
	}
	start := row
	_, next, err := b.writeTable(sheet, "PorMedio", start, cols, methodRows)
	if err != nil {
		return err
	}
	if err := b.barChart(sheet, "F5", "Cobrado por medio de pago", excelize.Col, start, start+1, start+len(methodRows), 1, []int{2}); err != nil {
		return err
	}

	cols[0].name = "Cobrador"
	collectorRows := make([][]any, len(report.ByCollector))
	for i, c := range report.ByCollector {
		collectorRows[i] = []any{c.CollectedByEmail, c.Amount, c.Count}
	}
	if _, _, err := b.writeTable(sheet, "PorCobrador", next, cols, collectorRows); err != nil {
		return err
	}
	return b.barChart(sheet, "F22", "Cobrado por cobrador", excelize.Col, next, next+1, next+len(collectorRows), 1, []int{2})
}

var methodsByName = map[string]involtv1.PaymentMethod{
	"CASH": involtv1.PaymentMethod_PAYMENT_METHOD_CASH, "YAPE": involtv1.PaymentMethod_PAYMENT_METHOD_YAPE,
	"PLIN": involtv1.PaymentMethod_PAYMENT_METHOD_PLIN, "TRANSFER": involtv1.PaymentMethod_PAYMENT_METHOD_TRANSFER,
	"OTHER": involtv1.PaymentMethod_PAYMENT_METHOD_OTHER,
}

// paymentMethodFromString maps the stored domain method name to the wire enum.
func paymentMethodFromString(m string) involtv1.PaymentMethod { return methodsByName[m] }
