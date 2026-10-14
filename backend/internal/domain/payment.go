package domain

import (
	"errors"
	"fmt"
	"math"
	"sort"
	"time"
)

// PaymentMethod is how a customer paid at the cash desk.
type PaymentMethod string

const (
	PaymentMethodCash     PaymentMethod = "CASH"
	PaymentMethodYape     PaymentMethod = "YAPE"
	PaymentMethodPlin     PaymentMethod = "PLIN"
	PaymentMethodTransfer PaymentMethod = "TRANSFER"
	PaymentMethodOther    PaymentMethod = "OTHER"
)

// ParsePaymentMethod validates a raw method string.
func ParsePaymentMethod(raw string) (PaymentMethod, bool) {
	switch m := PaymentMethod(raw); m {
	case PaymentMethodCash, PaymentMethodYape, PaymentMethodPlin, PaymentMethodTransfer, PaymentMethodOther:
		return m, true
	}
	return "", false
}

// ReceiptStatus is the collection state of a single receipt (reading).
type ReceiptStatus string

const (
	ReceiptStatusPaid    ReceiptStatus = "PAID"
	ReceiptStatusPartial ReceiptStatus = "PARTIAL"
	ReceiptStatusPending ReceiptStatus = "PENDING"
	ReceiptStatusOverdue ReceiptStatus = "OVERDUE"
)

var (
	ErrInvalidPaymentAmount = errors.New("payment amount must be greater than zero")
	ErrPaymentExceedsDebt   = errors.New("payment amount exceeds the outstanding debt")
	ErrPaymentAlreadyVoided = errors.New("payment is already voided")
	ErrPaymentNotFound      = errors.New("payment not found")
)

// Payment is money received from a customer, applied to one or more receipts.
type Payment struct {
	ID               string              `db:"id"`
	ReceiptNumber    int64               `db:"receipt_number"`
	CustomerID       string              `db:"customer_id"`
	CustomerName     string              `db:"customer_name"`
	CustomerCode     string              `db:"customer_code"`
	Amount           float64             `db:"amount"`
	Method           string              `db:"method"`
	Reference        string              `db:"reference"`
	Observation      string              `db:"observation"`
	CollectedBy      string              `db:"collected_by"`
	CollectedByEmail string              `db:"collected_by_email"`
	PaidAt           time.Time           `db:"paid_at"`
	VoidedAt         *time.Time          `db:"voided_at"`
	VoidedBy         string              `db:"voided_by"`
	VoidReason       string              `db:"void_reason"`
	Allocations      []PaymentAllocation `db:"-"`
}

// IsVoided reports whether the payment was annulled.
func (p Payment) IsVoided() bool {
	return p.VoidedAt != nil
}

// PaymentAllocation is the portion of a payment applied to one receipt.
type PaymentAllocation struct {
	ReadingID string  `db:"reading_id"`
	Period    string  `db:"period"`
	Amount    float64 `db:"amount"`
}

// Debt is the outstanding balance of a receipt.
type Debt struct {
	ReadingID string
	Period    string
	Balance   float64
}

// toCents converts soles to integer cents to avoid float drift.
func toCents(v float64) int64 {
	return int64(math.Round(v * 100))
}

func fromCents(c int64) float64 {
	return float64(c) / 100
}

// ReceiptBalance returns what is still owed on a receipt, never negative.
func ReceiptBalance(total, paid float64) float64 {
	balance := toCents(total) - toCents(paid)
	if balance < 0 {
		return 0
	}
	return fromCents(balance)
}

// ComputeReceiptStatus derives the collection status of a receipt.
// A receipt is overdue once the calendar day after its expiration date begins.
func ComputeReceiptStatus(total, paid float64, expiration, now time.Time) ReceiptStatus {
	balance := toCents(total) - toCents(paid)
	if balance <= 0 {
		return ReceiptStatusPaid
	}

	if !expiration.IsZero() {
		today := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, time.UTC)
		due := time.Date(expiration.Year(), expiration.Month(), expiration.Day(), 0, 0, 0, 0, time.UTC)
		if today.After(due) {
			return ReceiptStatusOverdue
		}
	}

	if toCents(paid) > 0 {
		return ReceiptStatusPartial
	}
	return ReceiptStatusPending
}

// AllocatePayment distributes an amount across debts, settling the oldest period first.
func AllocatePayment(amount float64, debts []Debt) ([]PaymentAllocation, error) {
	remaining := toCents(amount)
	if remaining <= 0 {
		return nil, ErrInvalidPaymentAmount
	}

	sorted := make([]Debt, 0, len(debts))
	var totalDebt int64
	for _, d := range debts {
		if toCents(d.Balance) > 0 {
			sorted = append(sorted, d)
			totalDebt += toCents(d.Balance)
		}
	}
	if remaining > totalDebt {
		return nil, ErrPaymentExceedsDebt
	}

	sort.SliceStable(sorted, func(i, j int) bool { return sorted[i].Period < sorted[j].Period })

	allocations := make([]PaymentAllocation, 0, len(sorted))
	for _, d := range sorted {
		if remaining == 0 {
			break
		}
		applied := min(toCents(d.Balance), remaining)
		allocations = append(allocations, PaymentAllocation{ReadingID: d.ReadingID, Amount: fromCents(applied)})
		remaining -= applied
	}
	return allocations, nil
}

// EffectivePeriod returns the YYYY-MM billing period, deriving it for legacy rows without one.
func (r Reading) EffectivePeriod() string {
	return deriveReadingPeriod(r.Period, r.PeriodStart, r.Timestamp, r.ID)
}

// BillingDatesForPeriod returns the period bounds and due date for a YYYY-MM period.
// The due date is day diasVencimiento (default 15) of the following month, matching sync.
func BillingDatesForPeriod(period string, diasVencimiento int) (start, end, expiration time.Time, err error) {
	t, err := time.Parse("2006-01", period)
	if err != nil {
		return time.Time{}, time.Time{}, time.Time{}, fmt.Errorf("invalid period %q, expected YYYY-MM", period)
	}
	if diasVencimiento <= 0 || diasVencimiento > 28 {
		diasVencimiento = 15
	}
	start = time.Date(t.Year(), t.Month(), 1, 0, 0, 0, 0, time.UTC)
	end = start.AddDate(0, 1, -1)
	next := start.AddDate(0, 1, 0)
	expiration = time.Date(next.Year(), next.Month(), diasVencimiento, 0, 0, 0, 0, time.UTC)
	return start, end, expiration, nil
}
