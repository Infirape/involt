package excel

import (
	"fmt"
	"sort"
	"strings"

	"github.com/xuri/excelize/v2"

	"github.com/infira/involt/backend/internal/ports"
)

const rendicionSheet = "Rendición"

// Ledger columns: A..F describe the payment, G..I are its amounts, J..K the running totals.
var rendicionCols = []struct {
	name  string
	width float64
}{
	{"FECHA", 12}, {"N° COMPROBANTE", 14}, {"SUMINISTRO", 38}, {"CASERÍO", 18}, {"PERIODOS", 17}, {"MEDIO", 13},
	{"MONTO", 14}, {"MORA", 12}, {"TOTAL", 14}, {"ACUMULADO SEMANA", 15}, {"ACUMULADO GENERAL", 15},
}

const (
	colDesc  = 6  // last descriptive column (F)
	colMonto = 7  // G
	colTotal = 9  // I
	colWeek  = 10 // J
	colAll   = 11 // K
)

// writeRendicion lays the weekly report out like the accounting ledger template: big title,
// info block, a two-level header once, then per week a section row, zebra payment rows with
// running totals and a subtotal row; finally the grand total and the totals per method.
func writeRendicion(b *book, data ports.RemittanceData, meta ports.WorkbookMeta) error {
	const sheet = rendicionSheet
	f := b.f
	_ = f.SetSheetView(sheet, 0, &excelize.ViewOptions{ShowGridLines: boolPtr(false)})
	for i, c := range rendicionCols {
		_ = f.SetColWidth(sheet, colName(i+1), colName(i+1), c.width)
	}

	b.band(sheet, 1, colAll, 1, "RENDICIÓN SEMANAL DE COBRANZA", cellStyle{bold: true, size: 22, color: ledgerTitle})
	_ = f.SetRowHeight(sheet, 1, 34)
	b.addLogo(sheet, "J2", 118, 40, 4) // right of the info block, like the ledger template
	row := writeRendicionInfo(b, sheet, 3, meta)

	headerRow := row + 1
	b.band(sheet, colMonto, colTotal, row, "MONTOS", cellStyle{bold: true, align: "center", fill: ledgerGroupBlue, color: ledgerNavy})
	b.band(sheet, colWeek, colAll, row, "ACUMULADO", cellStyle{bold: true, align: "center", fill: ledgerGroupGray, color: ledgerNavy})
	for i, c := range rendicionCols {
		fill := ledgerNavy
		switch {
		case i+1 >= colWeek:
			fill = ledgerCharcoal
		case i+1 >= colMonto:
			fill = ledgerSteel
		}
		b.band(sheet, i+1, i+1, headerRow, c.name, cellStyle{bold: true, size: 9, color: "FFFFFF", fill: fill, wrap: true})
	}
	_ = f.SetRowHeight(sheet, headerRow, 30)
	b.freezeHeader(sheet, headerRow)
	_ = f.SetDefinedName(&excelize.DefinedName{
		Name: "_xlnm.Print_Titles", Scope: sheet, RefersTo: fmt.Sprintf("'%s'!$%d:$%d", sheet, headerRow-1, headerRow),
	})
	_ = f.SetPageLayout(sheet, &excelize.PageLayoutOptions{Orientation: strPtr("landscape"), FitToWidth: intPtr(1), FitToHeight: intPtr(0)})

	row = headerRow + 1
	receipts := groupByReceipt(data.Lines)
	var all ledgerSums
	for _, w := range weekBlocks(receipts, data.From, data.To) {
		row = writeRendicionWeek(b, sheet, row, w, &all)
	}
	totals := cellStyle{bold: true, color: "FFFFFF", fill: ledgerNavy, size: 11}
	b.band(sheet, 1, colDesc, row, "TOTAL GENERAL · "+paymentsLabel(len(receipts)), totals)
	all.write(b, sheet, row, totals)
	b.band(sheet, colWeek, colAll, row, "", totals)
	return writeRendicionMethods(b, sheet, row+2, receipts)
}

func writeRendicionInfo(b *book, sheet string, row int, meta ports.WorkbookMeta) int {
	info := [][2]string{{"ENTIDAD", meta.Entity}, {"EMPRESA", meta.Company}}
	var from, to string
	for _, kv := range meta.Filters {
		switch kv[0] {
		case "Desde":
			from = kv[1]
		case "Hasta":
			to = kv[1]
		default:
			info = append(info, [2]string{strings.ToUpper(kv[0]), kv[1]})
		}
	}
	if from != "" {
		info = append(info[:2], append([][2]string{{"PERIODO", from + " al " + to}}, info[2:]...)...)
	}
	info = append(info, [2]string{"GENERADO", meta.GeneratedAt.In(lima).Format("02/01/2006 15:04") + " por " + meta.GeneratedBy})
	for _, kv := range info {
		b.band(sheet, 1, 2, row, kv[0], cellStyle{bold: true, size: 9, align: "right", color: ledgerNavy})
		b.band(sheet, 3, 5, row, kv[1], cellStyle{border: true})
		_ = b.f.SetRowHeight(sheet, row, 20)
		row++
	}
	return row + 1
}

// ledgerSums accumulates amount, late fee and total.
type ledgerSums struct{ amount, fee, total float64 }

func (s *ledgerSums) add(r *receiptRow) {
	s.amount, s.fee, s.total = s.amount+r.amount, s.fee+r.lateFee, s.total+r.total
}

func (s ledgerSums) write(b *book, sheet string, row int, style cellStyle) {
	style.money = true
	for i, v := range []float64{s.amount, s.fee, s.total} {
		_ = b.f.SetCellValue(sheet, cell(colMonto+i, row), v)
		b.paint(sheet, colMonto+i, row, style)
	}
}

func writeRendicionWeek(b *book, sheet string, row int, w *weekBlock, all *ledgerSums) int {
	b.band(sheet, 1, colDesc, row, fmt.Sprintf("SEMANA %d", w.number), cellStyle{bold: true, size: 11, fill: ledgerSection, border: true})
	b.band(sheet, colMonto, colAll, row, "DEL "+strings.ToUpper(w.span), cellStyle{bold: true, size: 12, align: "right", border: true})
	_ = b.f.SetRowHeight(sheet, row, 22)
	row++
	if len(w.receipts) == 0 {
		b.band(sheet, 1, colDesc, row, "Sin pagos en esta semana", cellStyle{italic: true, color: "898781", border: true})
		ledgerSums{}.write(b, sheet, row, cellStyle{border: true})
		b.band(sheet, colWeek, colAll, row, "", cellStyle{border: true})
		row++
	}
	var week ledgerSums
	for i, r := range w.receipts {
		week.add(r)
		all.add(r)
		zebra := ""
		accWeek, accAll := ledgerSection, ledgerSection
		if i%2 == 0 {
			zebra, accWeek, accAll = ledgerZebra, ledgerAccGray, ledgerAccBlue
		}
		l := r.line
		values := []any{
			dateOnly(l.PaidAt.In(lima)), fmt.Sprintf("%06d", l.ReceiptNumber), supplyLabel(l.CustomerCode, l.CustomerName),
			l.SectorName, strings.Join(r.periods, ", "), methodLabel(paymentMethodFromString(l.Method)),
			r.amount, r.lateFee, r.total, week.total, all.total,
		}
		_ = b.f.SetSheetRow(sheet, cell(1, row), &values)
		for c := 1; c <= colAll; c++ {
			s := cellStyle{fill: zebra, border: true, day: c == 1, money: c >= colMonto}
			switch c {
			case colWeek:
				s.fill = accWeek
			case colAll:
				s.fill = accAll
			}
			b.paint(sheet, c, row, s)
		}
		row++
	}
	sub := cellStyle{bold: true, fill: ledgerGroupBlue, topRule: true}
	b.band(sheet, 1, colDesc, row, fmt.Sprintf("TOTAL SEMANA %d · %s", w.number, paymentsLabel(len(w.receipts))), sub)
	week.write(b, sheet, row, sub)
	b.band(sheet, colWeek, colAll, row, "", sub)
	return row + 1
}

// writeRendicionMethods lists how much came in through each payment method (cash to deposit, etc.).
func writeRendicionMethods(b *book, sheet string, row int, receipts []*receiptRow) error {
	if len(receipts) == 0 {
		return nil
	}
	count, total := map[string]int{}, map[string]float64{}
	var methods []string
	for _, r := range receipts {
		m := methodLabel(paymentMethodFromString(r.line.Method))
		if _, ok := count[m]; !ok {
			methods = append(methods, m)
		}
		count[m]++
		total[m] += r.total
	}
	sort.Strings(methods)
	b.band(sheet, 1, colDesc, row, "TOTALES POR MEDIO DE PAGO", cellStyle{bold: true, size: 11, fill: ledgerSection, border: true})
	b.band(sheet, colMonto, colTotal, row, "", cellStyle{fill: ledgerSection, border: true})
	row++
	for i, m := range methods {
		zebra := ""
		if i%2 == 0 {
			zebra = ledgerZebra
		}
		b.band(sheet, 1, colDesc, row, m+" · "+paymentsLabel(count[m]), cellStyle{fill: zebra, border: true})
		b.band(sheet, colMonto, colMonto+1, row, "", cellStyle{fill: zebra, border: true})
		_ = b.f.SetCellValue(sheet, cell(colTotal, row), total[m])
		b.paint(sheet, colTotal, row, cellStyle{fill: zebra, border: true, money: true, bold: true})
		row++
	}
	return nil
}

func strPtr(v string) *string { return &v }
func intPtr(v int) *int       { return &v }
