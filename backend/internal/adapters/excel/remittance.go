package excel

import (
	"context"
	"fmt"
	"slices"
	"sort"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

// RemittanceWorkbook is the weekly treasury report for a payment-date range: Rendición (a
// printable ledger: each week's payments with running totals and a subtotal) and Pagos (every
// payment line as a filterable table).
func (g *Generator) RemittanceWorkbook(_ context.Context, data ports.RemittanceData, meta ports.WorkbookMeta) ([]byte, error) {
	b, err := newBook()
	if err != nil {
		return nil, err
	}
	_ = b.f.SetSheetName("Sheet1", rendicionSheet)
	_, _ = b.f.NewSheet("Pagos")
	if err := writeRendicion(b, data, meta); err != nil {
		return nil, err
	}
	if _, err := writePaymentLinesSheet(b, data.Lines, data.From, data.To); err != nil {
		return nil, err
	}
	return b.bytes()
}

// receiptRow is one payment (comprobante); a payment split across bills has several lines.
type receiptRow struct {
	line                   domain.PaymentLine
	periods                []string
	amount, lateFee, total float64
}

type weekBlock struct {
	week
	receipts []*receiptRow
}

func groupByReceipt(lines []domain.PaymentLine) []*receiptRow {
	byNumber := map[int64]*receiptRow{}
	var out []*receiptRow
	for _, l := range lines {
		r, ok := byNumber[l.ReceiptNumber]
		if !ok {
			r = &receiptRow{line: l}
			byNumber[l.ReceiptNumber] = r
			out = append(out, r)
		}
		if !slices.Contains(r.periods, l.Period) {
			r.periods = append(r.periods, l.Period)
		}
		r.amount += l.Amount
		r.lateFee += l.LateFee
		r.total += l.Amount + l.LateFee
	}
	sort.SliceStable(out, func(i, j int) bool { return out[i].line.PaidAt.Before(out[j].line.PaidAt) })
	return out
}

// weekBlocks lists every week of the range (even without payments) or, with no range, the
// weeks that have payments; chronological.
func weekBlocks(receipts []*receiptRow, from, to time.Time) []*weekBlock {
	byLabel := map[string]*weekBlock{}
	var blocks []*weekBlock
	add := func(w week) *weekBlock {
		if b, ok := byLabel[w.label]; ok {
			return b
		}
		b := &weekBlock{week: w}
		byLabel[w.label] = b
		blocks = append(blocks, b)
		return b
	}
	if !from.IsZero() && !to.IsZero() {
		for d := dateOnly(from); !d.After(dateOnly(to)); d = d.AddDate(0, 0, 1) {
			add(weekOf(time.Date(d.Year(), d.Month(), d.Day(), 12, 0, 0, 0, lima), from, to))
		}
	}
	for _, r := range receipts {
		w := add(weekOf(r.line.PaidAt, from, to))
		w.receipts = append(w.receipts, r)
	}
	sort.SliceStable(blocks, func(i, j int) bool { return blocks[i].from.Before(blocks[j].from) })
	return blocks
}

func paymentsLabel(n int) string {
	if n == 1 {
		return "1 pago"
	}
	return fmt.Sprintf("%d pagos", n)
}
