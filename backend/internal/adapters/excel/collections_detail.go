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

// writeCollectionsDetail writes the per-payment and per-supply sheets and one pivot table per
// TD_* sheet (separate sheets so pivots can grow on refresh without overlapping).
func writeCollectionsDetail(b *book, data ports.CollectionsWorkbookData, meta ports.WorkbookMeta) error {
	today := meta.GeneratedAt.In(lima)
	payments, err := writePaymentLinesSheet(b, data.Payments, time.Time{}, time.Time{})
	if err != nil {
		return err
	}
	supplies, err := writeSuppliesSheet(b, data, today)
	if err != nil {
		return err
	}

	sum := func(field, name string) excelize.PivotTableField {
		return excelize.PivotTableField{Data: field, Name: name, Subtotal: "Sum"}
	}
	bySupply := []excelize.PivotTableField{{Data: "Caserío"}, {Data: "Suministro"}}
	pivots := []struct {
		sheet, title, name, source string
		rows, cols, values         []excelize.PivotTableField
		has                        bool
	}{
		{"TD_Pagos", "Pagos por suministro y mes de pago", "PagosPorMes", payments, bySupply,
			[]excelize.PivotTableField{{Data: "Mes de pago"}}, []excelize.PivotTableField{sum("Total", "Pagado (S/)")},
			len(data.Payments) > 0},
		{"TD_Suministros", "Pagado y saldo por suministro y periodo facturado (todos los suministros)", "SuministrosPeriodo",
			supplies, bySupply, []excelize.PivotTableField{{Data: "Periodo"}},
			[]excelize.PivotTableField{sum("Pagado", "Pagado (S/)"), sum("Saldo", "Saldo (S/)")}, len(data.Customers) > 0},
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
		{"Saldo", 12, b.money}, {"Estado", 11, 0}, {"Servicio", 14, 0}, {"Vencimiento", 12, b.day},
		{"Días de atraso", 10, b.int}, {"Servicio desde", 13, b.day},
	}
	rows := make([][]any, 0, len(data.Customers)*len(data.Report.GetByPeriod()))
	for _, cust := range data.Customers {
		since := limaDay(cust.ServiceStatusChangedAt)
		for _, month := range data.Report.GetByPeriod() {
			c := cells[cust.CustomerCode+"|"+month.Period]
			if c == nil {
				c = &monthCell{}
			}
			status := statusNoReceipt
			var due any = ""
			days := 0
			if c.found {
				status = statusLabels[domain.ComputeReceiptStatus(c.billed, c.paid, c.expiration, today)]
				if !c.expiration.IsZero() {
					due = c.expiration
				}
				if domain.ReceiptBalance(c.billed, c.paid) > 0 {
					days = domain.DaysOverdue(c.expiration, today)
				}
			}
			rows = append(rows, []any{
				cust.SectorName, cust.CommunityName, cust.CustomerCode, cust.CustomerName,
				supplyLabel(cust.CustomerCode, cust.CustomerName), month.Period, periodLabel(month.Period),
				c.billed, c.paid, domain.ReceiptBalance(c.billed, c.paid), status, serviceLabel(cust.ServiceStatus),
				due, days, since,
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

// limaDay turns a timestamp into its Lima calendar date for Excel date cells ("" when unset).
func limaDay(t *time.Time) any {
	if t == nil {
		return ""
	}
	l := t.In(lima)
	return time.Date(l.Year(), l.Month(), l.Day(), 0, 0, 0, 0, time.UTC)
}
