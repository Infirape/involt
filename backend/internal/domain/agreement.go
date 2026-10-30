package domain

import (
	"errors"
	"fmt"
	"time"
)

// AgreementStatus: ACTIVE and CANCELLED are stored; COMPLETED and IN_DEFAULT are derived.
type AgreementStatus string

const (
	AgreementActive    AgreementStatus = "ACTIVE"
	AgreementCancelled AgreementStatus = "CANCELLED"
	AgreementCompleted AgreementStatus = "COMPLETED"
	AgreementInDefault AgreementStatus = "IN_DEFAULT"
)

var (
	ErrInvalidAgreement   = errors.New("invalid payment agreement")
	ErrAgreementsDisabled = errors.New("payment agreements are disabled")
	ErrAgreementNotFound  = errors.New("payment agreement not found")
	ErrReceiptInAgreement = errors.New("receipt already belongs to an active agreement")
)

// AgreementPolicy configures convenios de pago. MaxInstallments 0 disables them.
type AgreementPolicy struct {
	MaxInstallments   int
	MinInitialPercent float64
	GraceDays         int
	WaiveLateFees     bool
}

func (p AgreementPolicy) Validate() error {
	if p.MaxInstallments < 0 || p.MaxInstallments > 60 {
		return fmt.Errorf("%w: max installments must be between 0 and 60", ErrInvalidPolicy)
	}
	if p.MinInitialPercent < 0 || p.MinInitialPercent >= 100 {
		return fmt.Errorf("%w: minimum initial payment must be between 0 and 99%%", ErrInvalidPolicy)
	}
	if p.GraceDays < 0 || p.GraceDays > 90 {
		return fmt.Errorf("%w: grace days must be between 0 and 90", ErrInvalidPolicy)
	}
	return nil
}

// CheckRequest validates a new agreement against the policy.
func (p AgreementPolicy) CheckRequest(total, initial float64, installments int) error {
	if p.MaxInstallments == 0 {
		return ErrAgreementsDisabled
	}
	if installments < 1 || installments > p.MaxInstallments {
		return fmt.Errorf("%w: installments must be between 1 and %d", ErrInvalidAgreement, p.MaxInstallments)
	}
	if minInitial := toCents(total * p.MinInitialPercent / 100); toCents(initial) < minInitial {
		return fmt.Errorf("%w: initial payment must be at least %.2f", ErrInvalidAgreement, fromCents(minInitial))
	}
	return nil
}

type AgreementReceipt struct {
	ReadingID string  `db:"reading_id"`
	Period    string  `db:"period"`
	Principal float64 `db:"principal"`
	LateFee   float64 `db:"late_fee"` // frozen at signing (0 if waived)
}

type Installment struct {
	Number  int       `db:"number"`
	DueDate time.Time `db:"due_date"`
	Amount  float64   `db:"amount"`
}

// Agreement (convenio de pago) groups a customer's receipts into an installment plan.
type Agreement struct {
	ID             string          `db:"id"`
	Number         int64           `db:"number"`
	CustomerID     string          `db:"customer_id"`
	CustomerName   string          `db:"customer_name"`
	CustomerCode   string          `db:"customer_code"`
	Status         AgreementStatus `db:"status"`
	Total          float64         `db:"total"`
	InitialAmount  float64         `db:"initial_amount"`
	Notes          string          `db:"notes"`
	LateFeesWaived bool            `db:"late_fees_waived"`
	CreatedBy      string          `db:"created_by"`
	CreatedByEmail string          `db:"created_by_email"`
	CreatedAt      time.Time       `db:"created_at"`
	CancelledAt    *time.Time      `db:"cancelled_at"`
	CancelledBy    string          `db:"cancelled_by"`
	CancelReason   string          `db:"cancel_reason"`
	// PaidSinceSigning is the sum of non-voided allocations (principal + fee) on the covered
	// receipts from payments made at or after CreatedAt.
	PaidSinceSigning float64            `db:"paid_since_signing"`
	Receipts         []AgreementReceipt `db:"-"`
	Installments     []Installment      `db:"-"`
}

// BuildInstallments splits (total - initial) into monthly installments, the remainder cents
// going to the last one. Due days are clamped to 28 so they exist every month.
func BuildInstallments(total, initial float64, count int, firstDue time.Time) ([]Installment, error) {
	totalC, initialC := toCents(total), toCents(initial)
	if totalC <= 0 || initialC < 0 || initialC >= totalC || count < 1 {
		return nil, fmt.Errorf("%w: total must exceed the initial payment and installments must be >= 1", ErrInvalidAgreement)
	}
	rest := totalC - initialC
	each := rest / int64(count)
	dueDay := min(firstDue.Day(), 28)

	out := make([]Installment, count)
	for i := range out {
		amount := each
		if i == count-1 {
			amount = rest - each*int64(count-1)
		}
		month := time.Date(firstDue.Year(), firstDue.Month()+time.Month(i), 1, 0, 0, 0, 0, time.UTC)
		out[i] = Installment{
			Number:  i + 1,
			DueDate: time.Date(month.Year(), month.Month(), dueDay, 0, 0, 0, 0, time.UTC),
			Amount:  fromCents(amount),
		}
	}
	return out, nil
}

// AgreementProgress is the derived state of an agreement on a given day.
type AgreementProgress struct {
	Status           AgreementStatus
	Paid             float64
	PaidInstallments int          // fully covered installments
	Next             *Installment // first installment not fully covered
	NextAmount       float64      // what is still owed on Next
	InDefault        bool
	OverdueAmount    float64 // scheduled amount past due (beyond grace) not yet paid
}

// ProtectsReceipts reports whether covered receipts are shielded from cut and mora.
func (p AgreementProgress) ProtectsReceipts() bool {
	return p.Status == AgreementActive
}

// ComputeAgreementProgress derives status from what was paid since signing. The initial
// payment is due at signing; installment N is in default once its due date + grace has passed
// without the cumulative scheduled amount being covered.
func ComputeAgreementProgress(a Agreement, paidSinceSigning float64, today time.Time, graceDays int) AgreementProgress {
	paid := toCents(paidSinceSigning)
	progress := AgreementProgress{Status: a.Status, Paid: fromCents(paid)}
	if a.Status == AgreementCancelled {
		return progress
	}
	if paid >= toCents(a.Total) {
		progress.Status = AgreementCompleted
		return progress
	}

	cumulative := toCents(a.InitialAmount)
	var overdue int64
	for i := range a.Installments {
		inst := a.Installments[i]
		cumulative += toCents(inst.Amount)
		if paid >= cumulative {
			progress.PaidInstallments++
			continue
		}
		if progress.Next == nil {
			progress.Next = &inst
			progress.NextAmount = fromCents(min(cumulative-paid, toCents(inst.Amount)))
		}
		if DaysOverdue(inst.DueDate.AddDate(0, 0, graceDays), today) > 0 {
			overdue = cumulative - paid
		}
	}
	if overdue > 0 {
		progress.InDefault = true
		progress.Status = AgreementInDefault
		progress.OverdueAmount = fromCents(overdue)
	}
	return progress
}
