package domain

import (
	"errors"
	"fmt"
	"math"
	"time"
)

// LateFeeMode is how mora is charged on overdue receipts.
type LateFeeMode string

const (
	LateFeeNone            LateFeeMode = "NONE"
	LateFeeFixed           LateFeeMode = "FIXED"            // Value soles per overdue receipt, once
	LateFeePercent         LateFeeMode = "PERCENT"          // Value % of the outstanding balance, once
	LateFeeMonthlyInterest LateFeeMode = "MONTHLY_INTEREST" // Value % of the balance per started month overdue
)

var ErrInvalidPolicy = errors.New("invalid collection policy")

// LateFeePolicy configures mora. Days before StartDate never accrue, so enabling mora
// does not retroactively charge old debt.
type LateFeePolicy struct {
	Mode      LateFeeMode
	Value     float64
	StartDate time.Time
}

func (p LateFeePolicy) Validate() error {
	switch p.Mode {
	case LateFeeNone:
		return nil
	case LateFeeFixed:
		if p.Value <= 0 {
			return fmt.Errorf("%w: fixed late fee must be greater than zero", ErrInvalidPolicy)
		}
	case LateFeePercent, LateFeeMonthlyInterest:
		if p.Value <= 0 || p.Value > 100 {
			return fmt.Errorf("%w: late fee percentage must be between 0 and 100", ErrInvalidPolicy)
		}
	default:
		return fmt.Errorf("%w: unknown late fee mode %q", ErrInvalidPolicy, p.Mode)
	}
	return nil
}

// ComputeLateFee returns the mora accrued today on a receipt with the given outstanding balance.
// Settled receipts (balance 0) never accrue.
func ComputeLateFee(p LateFeePolicy, balance float64, expiration, today time.Time) float64 {
	if p.Mode == LateFeeNone || toCents(balance) <= 0 || expiration.IsZero() {
		return 0
	}
	effectiveDue := expiration
	if !p.StartDate.IsZero() {
		if dayBeforeStart := p.StartDate.AddDate(0, 0, -1); dayBeforeStart.After(effectiveDue) {
			effectiveDue = dayBeforeStart
		}
	}
	days := DaysOverdue(effectiveDue, today)
	if days == 0 {
		return 0
	}

	var fee float64
	switch p.Mode {
	case LateFeeFixed:
		fee = p.Value
	case LateFeePercent:
		fee = balance * p.Value / 100
	case LateFeeMonthlyInterest:
		months := math.Ceil(float64(days) / 30)
		fee = balance * p.Value / 100 * months
	}
	return fromCents(toCents(fee))
}

// CollectionPolicy groups the configurable collection rules (mora + convenios).
type CollectionPolicy struct {
	LateFee   LateFeePolicy
	Agreement AgreementPolicy
	UpdatedAt time.Time
	UpdatedBy string
}

func (p CollectionPolicy) Validate() error {
	if err := p.LateFee.Validate(); err != nil {
		return err
	}
	return p.Agreement.Validate()
}

// LateFeeOwed is the unpaid mora of a receipt: zero if waived; the amount frozen at signing
// while an on-track agreement protects it; otherwise what has accrued minus what was paid.
func LateFeeOwed(p LateFeePolicy, balance float64, expiration, today time.Time, feePaid float64, waived bool, frozen *float64) float64 {
	if waived {
		return 0
	}
	accrued := ComputeLateFee(p, balance, expiration, today)
	if frozen != nil {
		accrued = *frozen
	}
	owed := toCents(accrued) - toCents(feePaid)
	if owed < 0 {
		return 0
	}
	return fromCents(owed)
}
