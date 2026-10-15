package excel

import (
	"fmt"
	"time"

	"github.com/xuri/excelize/v2"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

const statusNoReceipt = "Sin recibo"

func supplyLabel(code, name string) string { return code + " - " + name }

// writeCollectionsDetail writes the per-supply, per-payment and per-receipt sheets and one pivot
// table per TD_* sheet (separate sheets so pivots can grow on refresh without overlapping).
func writeCollectionsDetail(b *book, data ports.CollectionsWorkbookData, meta ports.WorkbookMeta) error {
	today := meta.GeneratedAt.In(lima)
	supplies, err := writeSuppliesSheet(b, data, today)
	if err != nil {
		return err
	}
	padron, err := writeServiceSheet(b, data.Customers)
	if err != nil {
		return err
	}
	payments, err := writePaymentLinesSheet(b, data.Payments)
	if err != nil {
		return err
	}
	receipts, err := writeReceiptDetail(b, data.Receipts, today)
	if err != nil {
		return err
	}

	sum := func(field, name string) []excelize.PivotTableField {
		return []excelize.PivotTableField{{Data: field, Name: name, Subtotal: "Sum"}}
	}
	bySupply := []excelize.PivotTableField{{Data: "Caserío"}, {Data: "Suministro"}}
	pivots := []struct {
		sheet, title, name, source string
		rows, cols, values         []excelize.PivotTableField
		has                        bool
	}{
		{"TD_PagosMes", "Pagos por suministro y mes de pago", "PagosPorMes", payments, bySupply,
			[]excelize.PivotTableField{{Data: "Mes de pago"}}, sum("Total", "Pagado (S/)"), len(data.Payments) > 0},
		{"TD_Suministros", "Pagado por suministro y periodo facturado (todos los suministros)", "SuministrosPeriodo", supplies, bySupply,
			[]excelize.PivotTableField{{Data: "Periodo"}}, sum("Pagado", "Pagado (S/)"), len(data.Customers) > 0},
		{"TD_Saldos", "Saldo pendiente por caserío y periodo", "SaldoCaserioMes", receipts,
			[]excelize.PivotTableField{{Data: "Caserío"}}, []excelize.PivotTableField{{Data: "Periodo"}},
			sum("Saldo", "Saldo pendiente (S/)"), len(data.Receipts) > 0},
		{"TD_Estados", "Suministros por estado y periodo", "EstadoSuministros", supplies,
			[]excelize.PivotTableField{{Data: "Caserío"}, {Data: "Periodo"}}, []excelize.PivotTableField{{Data: "Estado"}},
			[]excelize.PivotTableField{{Data: "Código", Name: "Suministros", Subtotal: "Count"}}, len(data.Customers) > 0},
		{"TD_Servicio", "Suministros por estado de servicio", "ServicioCaserio", padron,
			[]excelize.PivotTableField{{Data: "Caserío"}}, []excelize.PivotTableField{{Data: "Servicio"}},
			[]excelize.PivotTableField{{Data: "Código", Name: "Suministros", Subtotal: "Count"}}, len(data.Customers) > 0},
	}
	for _, p := range pivots {
		_, _ = b.f.NewSheet(p.sheet)
		_ = b.f.SetCellValue(p.sheet, "A1", p.title)
		_ = b.f.SetCellStyle(p.sheet, "A1", "A1", b.title)
		if err := b.pivot(p.sheet, "A3", p.source, p.name, p.has, p.rows, p.cols, p.values); err != nil {
			return fmt.Errorf("%s pivot: %w", p.name, err)
		}
	}
	return nil
}

type monthCell struct {
	billed, paid float64
	expiration   time.Time
	found        bool
}

// writeSuppliesSheet writes one row per supply × month of the report range, including months
// (and supplies) without receipts, so pivots list every suministro.
func writeSuppliesSheet(b *book, data ports.CollectionsWorkbookData, today time.Time) (string, error) {
	cells := map[string]*monthCell{}
	for _, r := range data.Receipts {
		key := r.CustomerCode + "|" + r.Period
		c, ok := cells[key]
		if !ok {
			c = &monthCell{expiration: r.ExpirationDate, found: true}
			cells[key] = c
		}
		c.billed += r.Total
		c.paid += r.Paid
	}
	cols := []column{
		{"Caserío", 18, 0}, {"Comunidad", 16, 0}, {"Código", 10, 0}, {"Cliente", 30, 0}, {"Suministro", 38, 0},
		{"Periodo", 10, 0}, {"Mes", 10, 0}, {"Facturado", 12, b.money}, {"Pagado", 12, b.money},
		{"Saldo", 12, b.money}, {"Estado", 11, 0}, {"Servicio", 14, 0},
	}
	rows := make([][]any, 0, len(data.Customers)*len(data.Report.GetByPeriod()))
	for _, cust := range data.Customers {
		for _, month := range data.Report.GetByPeriod() {
			c := cells[cust.CustomerCode+"|"+month.Period]
			if c == nil {
				c = &monthCell{}
			}
			status := statusNoReceipt
			if c.found {
				status = statusLabels[domain.ComputeReceiptStatus(c.billed, c.paid, c.expiration, today)]
			}
			rows = append(rows, []any{
				cust.SectorName, cust.CommunityName, cust.CustomerCode, cust.CustomerName,
				supplyLabel(cust.CustomerCode, cust.CustomerName), month.Period, periodLabel(month.Period),
				c.billed, c.paid, domain.ReceiptBalance(c.billed, c.paid), status, serviceLabel(cust.ServiceStatus),
			})
		}
	}
	ref, _, err := b.writeTable("Suministros", "TablaSuministros", 1, cols, rows)
	if err != nil {
		return "", err
	}
	b.freezeHeader("Suministros", 1)
	return "Suministros!" + ref, nil
}

// writeServiceSheet lists every supply once with its current service status (padrón).
func writeServiceSheet(b *book, customers []domain.CustomerLine) (string, error) {
	cols := []column{
		{"Caserío", 18, 0}, {"Comunidad", 16, 0}, {"Código", 10, 0}, {"Cliente", 30, 0},
		{"Servicio", 15, 0}, {"Estado desde", 13, b.day},
	}
	rows := make([][]any, 0, len(customers))
	for _, c := range customers {
		var since any = ""
		if c.ServiceStatusChangedAt != nil {
			l := c.ServiceStatusChangedAt.In(lima)
			since = time.Date(l.Year(), l.Month(), l.Day(), 0, 0, 0, 0, time.UTC)
		}
		rows = append(rows, []any{c.SectorName, c.CommunityName, c.CustomerCode, c.CustomerName, serviceLabel(c.ServiceStatus), since})
	}
	ref, _, err := b.writeTable("Servicio", "TablaServicio", 1, cols, rows)
	if err != nil {
		return "", err
	}
	b.freezeHeader("Servicio", 1)
	return "Servicio!" + ref, nil
}

// writePaymentLinesSheet writes every valid payment allocation; "Mes de pago" is the Lima month.
func writePaymentLinesSheet(b *book, lines []domain.PaymentLine) (string, error) {
	cols := []column{
		{"Caserío", 18, 0}, {"Comunidad", 16, 0}, {"Código", 10, 0}, {"Cliente", 30, 0}, {"Suministro", 38, 0},
		{"N° comprobante", 12, 0}, {"Fecha de pago", 12, b.day}, {"Mes de pago", 11, 0}, {"Periodo del recibo", 12, 0},
		{"Medio", 13, 0}, {"Cobrado por", 26, 0}, {"Monto recibo", 12, b.money}, {"Mora", 10, b.money}, {"Total", 12, b.money},
		{"Servicio", 14, 0},
	}
	rows := make([][]any, 0, len(lines))
	for _, l := range lines {
		paid := l.PaidAt.In(lima)
		rows = append(rows, []any{
			l.SectorName, l.CommunityName, l.CustomerCode, l.CustomerName, supplyLabel(l.CustomerCode, l.CustomerName),
			fmt.Sprintf("%06d", l.ReceiptNumber), time.Date(paid.Year(), paid.Month(), paid.Day(), 0, 0, 0, 0, time.UTC),
			paid.Format("2006-01"), l.Period, methodLabel(paymentMethodFromString(l.Method)), l.CollectedByEmail,
			l.Amount, l.LateFee, l.Amount + l.LateFee, serviceLabel(l.ServiceStatus),
		})
	}
	ref, _, err := b.writeTable("Pagos", "TablaPagosDetalle", 1, cols, rows)
	if err != nil {
		return "", err
	}
	b.freezeHeader("Pagos", 1)
	return "Pagos!" + ref, nil
}

func writeReceiptDetail(b *book, lines []domain.ReceiptLine, today time.Time) (string, error) {
	cols := []column{
		{"Caserío", 18, 0}, {"Comunidad", 16, 0}, {"Código", 10, 0}, {"Cliente", 30, 0}, {"Periodo", 10, 0},
		{"Total", 11, b.money}, {"Pagado", 11, b.money}, {"Saldo", 11, b.money}, {"Vencimiento", 12, b.day},
		{"Estado", 11, 0}, {"Días de atraso", 10, b.int}, {"Servicio", 14, 0},
	}
	rows := make([][]any, 0, len(lines))
	for _, l := range lines {
		var due any = ""
		if !l.ExpirationDate.IsZero() {
			due = l.ExpirationDate
		}
		balance := domain.ReceiptBalance(l.Total, l.Paid)
		days := 0
		if balance > 0 {
			days = domain.DaysOverdue(l.ExpirationDate, today)
		}
		rows = append(rows, []any{
			l.SectorName, l.CommunityName, l.CustomerCode, l.CustomerName, l.Period, l.Total, l.Paid, balance, due,
			statusLabels[domain.ComputeReceiptStatus(l.Total, l.Paid, l.ExpirationDate, today)], days,
			serviceLabel(l.ServiceStatus),
		})
	}
	ref, _, err := b.writeTable("Recibos", "TablaRecibos", 1, cols, rows)
	if err != nil {
		return "", err
	}
	b.freezeHeader("Recibos", 1)
	return "Recibos!" + ref, nil
}
