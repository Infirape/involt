package excel

import (
	"fmt"
	"time"

	"github.com/infira/involt/backend/internal/domain"
)

var monthsEs = []string{"enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto",
	"septiembre", "octubre", "noviembre", "diciembre"}

// week is a treasury week: Monday to Sunday in Lima time, cut at month ends (and at the
// report range), numbered within its month ("SEM 1 · 1 al 6 de septiembre de 2026").
type week struct {
	label    string // "SEM 1 · 1 al 6 de septiembre de 2026"
	span     string // "1 al 6 de septiembre de 2026"
	number   int
	from, to time.Time
}

func dateOnly(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, time.UTC)
}

// weekOf returns the week of instant t; rangeFrom/rangeTo (inclusive dates, zero = open) clip it.
func weekOf(t, rangeFrom, rangeTo time.Time) week {
	day := dateOnly(t.In(lima))
	first := time.Date(day.Year(), day.Month(), 1, 0, 0, 0, 0, time.UTC)
	mondayOffset := func(d time.Time) int { return (int(d.Weekday()) + 6) % 7 } // Monday = 0
	start := day.AddDate(0, 0, -mondayOffset(day))
	end := start.AddDate(0, 0, 6)
	if start.Before(first) {
		start = first
	}
	if last := first.AddDate(0, 1, -1); end.After(last) {
		end = last
	}
	if !rangeFrom.IsZero() && start.Before(dateOnly(rangeFrom)) {
		start = dateOnly(rangeFrom)
	}
	if !rangeTo.IsZero() && end.After(dateOnly(rangeTo)) {
		end = dateOnly(rangeTo)
	}
	n := (mondayOffset(first)+day.Day()-1)/7 + 1
	days := fmt.Sprintf("%d al %d", start.Day(), end.Day())
	if start.Equal(end) {
		days = fmt.Sprint(start.Day())
	}
	span := fmt.Sprintf("%s de %s de %d", days, monthsEs[day.Month()-1], day.Year())
	return week{label: fmt.Sprintf("SEM %d · %s", n, span), span: span, number: n, from: start, to: end}
}

// writePaymentLinesSheet writes every valid payment allocation, date first, ready to filter by
// week (Monday to Sunday) or month, both in Lima time.
func writePaymentLinesSheet(b *book, lines []domain.PaymentLine, rangeFrom, rangeTo time.Time) (string, error) {
	cols := []column{
		{"Fecha de pago", 12, b.day}, {"Semana", 24, 0}, {"Mes de pago", 11, 0}, {"N° comprobante", 12, 0},
		{"Código", 10, 0}, {"Cliente", 30, 0}, {"Caserío", 18, 0}, {"Comunidad", 16, 0}, {"Periodo del recibo", 12, 0},
		{"Medio", 13, 0}, {"Cobrado por", 26, 0}, {"Monto recibo", 12, b.money}, {"Mora", 10, b.money}, {"Total", 12, b.money},
		{"Servicio", 14, 0}, {"Suministro", 38, 0},
	}
	rows := make([][]any, 0, len(lines))
	for _, l := range lines {
		paid := l.PaidAt.In(lima)
		rows = append(rows, []any{
			time.Date(paid.Year(), paid.Month(), paid.Day(), 0, 0, 0, 0, time.UTC), weekOf(l.PaidAt, rangeFrom, rangeTo).label,
			paid.Format("2006-01"), fmt.Sprintf("%06d", l.ReceiptNumber), l.CustomerCode, l.CustomerName,
			l.SectorName, l.CommunityName, l.Period, methodLabel(paymentMethodFromString(l.Method)), l.CollectedByEmail,
			l.Amount, l.LateFee, l.Amount + l.LateFee, serviceLabel(l.ServiceStatus), supplyLabel(l.CustomerCode, l.CustomerName),
		})
	}
	ref, _, err := b.writeTable("Pagos", "TablaPagosDetalle", 1, cols, rows)
	if err != nil {
		return "", err
	}
	b.freezeHeader("Pagos", 1)
	return "Pagos!" + ref, nil
}
