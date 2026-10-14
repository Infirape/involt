package domain

import (
	"errors"
	"testing"
	"time"
)

func TestComputeLateFee(t *testing.T) {
	today := day(2026, 10, 13)
	due := day(2026, 8, 15) // 59 days overdue → 2 started months

	cases := []struct {
		name    string
		policy  LateFeePolicy
		balance float64
		due     time.Time
		want    float64
	}{
		{"none", LateFeePolicy{Mode: LateFeeNone, Value: 5}, 10, due, 0},
		{"fixed", LateFeePolicy{Mode: LateFeeFixed, Value: 1.5}, 10, due, 1.5},
		{"percent once", LateFeePolicy{Mode: LateFeePercent, Value: 2}, 12.5, due, 0.25},
		{"monthly interest counts started months", LateFeePolicy{Mode: LateFeeMonthlyInterest, Value: 1}, 100, due, 2},
		{"not overdue yet", LateFeePolicy{Mode: LateFeeFixed, Value: 1}, 10, day(2026, 10, 13), 0},
		{"settled receipts never accrue", LateFeePolicy{Mode: LateFeeFixed, Value: 1}, 0, due, 0},
		{"no due date", LateFeePolicy{Mode: LateFeeFixed, Value: 1}, 10, time.Time{}, 0},
		{"start date in the future", LateFeePolicy{Mode: LateFeeFixed, Value: 1, StartDate: day(2026, 11, 1)}, 10, due, 0},
		{
			"interest only counts days after start date",
			LateFeePolicy{Mode: LateFeeMonthlyInterest, Value: 1, StartDate: day(2026, 10, 1)}, 100, due, 1,
		},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := ComputeLateFee(tc.policy, tc.balance, tc.due, today); got != tc.want {
				t.Fatalf("fee = %v, want %v", got, tc.want)
			}
		})
	}
}

func TestLateFeePolicyValidate(t *testing.T) {
	valid := []LateFeePolicy{
		{Mode: LateFeeNone},
		{Mode: LateFeeFixed, Value: 2},
		{Mode: LateFeePercent, Value: 10},
		{Mode: LateFeeMonthlyInterest, Value: 1.5},
	}
	for _, p := range valid {
		if err := p.Validate(); err != nil {
			t.Fatalf("%+v should be valid: %v", p, err)
		}
	}
	invalid := []LateFeePolicy{
		{Mode: "WEEKLY", Value: 1},
		{Mode: LateFeeFixed, Value: 0},
		{Mode: LateFeePercent, Value: 101},
		{Mode: LateFeeMonthlyInterest, Value: -1},
	}
	for _, p := range invalid {
		if err := p.Validate(); !errors.Is(err, ErrInvalidPolicy) {
			t.Fatalf("%+v err = %v, want ErrInvalidPolicy", p, err)
		}
	}
}

func TestAllocatePaymentPaysLateFeeBeforePrincipal(t *testing.T) {
	debts := []Debt{
		{ReadingID: "sep", Period: "2026-09", Balance: 10, LateFee: 0},
		{ReadingID: "aug", Period: "2026-08", Balance: 10, LateFee: 1},
	}

	allocations, err := AllocatePayment(5, debts)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(allocations) != 1 || allocations[0].ReadingID != "aug" || allocations[0].LateFee != 1 || allocations[0].Amount != 4 {
		t.Fatalf("allocations = %+v, want aug fee 1 + principal 4", allocations)
	}

	if _, err := AllocatePayment(21.01, debts); !errors.Is(err, ErrPaymentExceedsDebt) {
		t.Fatalf("overpayment including fees err = %v", err)
	}
	full, _ := AllocatePayment(21, debts)
	if len(full) != 2 || full[1].ReadingID != "sep" || full[1].Amount != 10 {
		t.Fatalf("full allocation = %+v", full)
	}
}

func TestAllocationCanBeFeeOnly(t *testing.T) {
	allocations, err := AllocatePayment(0.5, []Debt{{ReadingID: "aug", Period: "2026-08", Balance: 10, LateFee: 1}})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if allocations[0].Amount != 0 || allocations[0].LateFee != 0.5 {
		t.Fatalf("allocation = %+v, want fee-only 0.5", allocations[0])
	}
}

func TestLateFeeOwed(t *testing.T) {
	p := LateFeePolicy{Mode: LateFeeFixed, Value: 2}
	today, due := day(2026, 10, 13), day(2026, 8, 15)
	frozen := 0.5

	if got := LateFeeOwed(p, 10, due, today, 0.5, false, nil); got != 1.5 {
		t.Fatalf("partially paid fee = %v, want 1.5", got)
	}
	if got := LateFeeOwed(p, 10, due, today, 0, true, nil); got != 0 {
		t.Fatalf("waived fee = %v, want 0", got)
	}
	if got := LateFeeOwed(p, 10, due, today, 0, false, &frozen); got != 0.5 {
		t.Fatalf("frozen fee = %v, want 0.5", got)
	}
	if got := LateFeeOwed(p, 10, due, today, 3, false, nil); got != 0 {
		t.Fatalf("overpaid fee = %v, want 0", got)
	}
}
