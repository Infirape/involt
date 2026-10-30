package domain

import (
	"errors"
	"testing"
	"time"
)

func TestComputeReceiptStatus(t *testing.T) {
	now := time.Date(2026, 10, 13, 10, 0, 0, 0, time.UTC)
	future := time.Date(2026, 10, 20, 0, 0, 0, 0, time.UTC)
	past := time.Date(2026, 10, 1, 0, 0, 0, 0, time.UTC)
	today := time.Date(2026, 10, 13, 0, 0, 0, 0, time.UTC)

	cases := []struct {
		name       string
		total      float64
		paid       float64
		expiration time.Time
		want       ReceiptStatus
	}{
		{"fully paid", 12.5, 12.5, past, ReceiptStatusPaid},
		{"paid within rounding", 12.5, 12.499, past, ReceiptStatusPaid},
		{"zero total counts as paid", 0, 0, past, ReceiptStatusPaid},
		{"nothing paid, not due", 12.5, 0, future, ReceiptStatusPending},
		{"partial, not due", 12.5, 5, future, ReceiptStatusPartial},
		{"nothing paid, overdue", 12.5, 0, past, ReceiptStatusOverdue},
		{"partial, overdue", 12.5, 5, past, ReceiptStatusOverdue},
		{"due today is not overdue", 12.5, 0, today, ReceiptStatusPending},
		{"no expiration is never overdue", 12.5, 0, time.Time{}, ReceiptStatusPending},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := ComputeReceiptStatus(tc.total, tc.paid, tc.expiration, now); got != tc.want {
				t.Fatalf("status = %s, want %s", got, tc.want)
			}
		})
	}
}

func TestReceiptBalance(t *testing.T) {
	if got := ReceiptBalance(12.5, 5.2); got != 7.3 {
		t.Fatalf("balance = %v, want 7.3", got)
	}
	if got := ReceiptBalance(10, 11); got != 0 {
		t.Fatalf("overpaid balance = %v, want 0", got)
	}
}

func TestAllocatePaymentOldestFirst(t *testing.T) {
	debts := []Debt{
		{ReadingID: "r-may", Period: "2026-05", Balance: 10},
		{ReadingID: "r-mar", Period: "2026-03", Balance: 8},
		{ReadingID: "r-apr", Period: "2026-04", Balance: 9.5},
	}

	allocations, err := AllocatePayment(20, debts)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	want := []PaymentAllocation{
		{ReadingID: "r-mar", Amount: 8},
		{ReadingID: "r-apr", Amount: 9.5},
		{ReadingID: "r-may", Amount: 2.5},
	}
	if len(allocations) != len(want) {
		t.Fatalf("allocations = %#v, want %#v", allocations, want)
	}
	for i := range want {
		if allocations[i] != want[i] {
			t.Fatalf("allocation[%d] = %#v, want %#v", i, allocations[i], want[i])
		}
	}
}

func TestAllocatePaymentSkipsSettledDebts(t *testing.T) {
	debts := []Debt{
		{ReadingID: "r-1", Period: "2026-01", Balance: 0},
		{ReadingID: "r-2", Period: "2026-02", Balance: 6},
	}

	allocations, err := AllocatePayment(6, debts)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(allocations) != 1 || allocations[0].ReadingID != "r-2" {
		t.Fatalf("allocations = %#v, want only r-2", allocations)
	}
}

func TestAllocatePaymentAvoidsFloatDrift(t *testing.T) {
	debts := []Debt{
		{ReadingID: "a", Period: "2026-01", Balance: 0.1},
		{ReadingID: "b", Period: "2026-02", Balance: 0.2},
	}

	allocations, err := AllocatePayment(0.3, debts)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(allocations) != 2 || allocations[1].Amount != 0.2 {
		t.Fatalf("allocations = %#v", allocations)
	}
}

func TestAllocatePaymentRejectsInvalidAmounts(t *testing.T) {
	debts := []Debt{{ReadingID: "a", Period: "2026-01", Balance: 5}}

	if _, err := AllocatePayment(0, debts); !errors.Is(err, ErrInvalidPaymentAmount) {
		t.Fatalf("zero amount err = %v, want ErrInvalidPaymentAmount", err)
	}
	if _, err := AllocatePayment(-1, debts); !errors.Is(err, ErrInvalidPaymentAmount) {
		t.Fatalf("negative amount err = %v, want ErrInvalidPaymentAmount", err)
	}
	if _, err := AllocatePayment(5.01, debts); !errors.Is(err, ErrPaymentExceedsDebt) {
		t.Fatalf("overpayment err = %v, want ErrPaymentExceedsDebt", err)
	}
	if _, err := AllocatePayment(1, nil); !errors.Is(err, ErrPaymentExceedsDebt) {
		t.Fatalf("no debt err = %v, want ErrPaymentExceedsDebt", err)
	}
}

func TestParsePaymentMethod(t *testing.T) {
	if m, ok := ParsePaymentMethod("YAPE"); !ok || m != PaymentMethodYape {
		t.Fatalf("YAPE parsed as %q, %v", m, ok)
	}
	if _, ok := ParsePaymentMethod("BITCOIN"); ok {
		t.Fatal("unknown method should not parse")
	}
}

func TestPaymentIsVoided(t *testing.T) {
	p := Payment{}
	if p.IsVoided() {
		t.Fatal("new payment should not be voided")
	}
	now := time.Now()
	p.VoidedAt = &now
	if !p.IsVoided() {
		t.Fatal("payment with voided_at should be voided")
	}
}

func TestBillingDatesForPeriod(t *testing.T) {
	start, end, expiration, err := BillingDatesForPeriod("2026-09", 20)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !start.Equal(time.Date(2026, 9, 1, 0, 0, 0, 0, time.UTC)) ||
		!end.Equal(time.Date(2026, 9, 30, 0, 0, 0, 0, time.UTC)) ||
		!expiration.Equal(time.Date(2026, 10, 20, 0, 0, 0, 0, time.UTC)) {
		t.Fatalf("dates = %v %v %v", start, end, expiration)
	}

	_, _, expiration, _ = BillingDatesForPeriod("2026-12", 0)
	if !expiration.Equal(time.Date(2027, 1, 15, 0, 0, 0, 0, time.UTC)) {
		t.Fatalf("default due day expiration = %v, want 2027-01-15", expiration)
	}

	if _, _, _, err := BillingDatesForPeriod("sept-2026", 15); err == nil {
		t.Fatal("invalid period should fail")
	}
}

func TestReadingEffectivePeriod(t *testing.T) {
	r := Reading{PeriodStart: time.Date(2026, 7, 1, 0, 0, 0, 0, time.UTC)}
	if got := r.EffectivePeriod(); got != "2026-07" {
		t.Fatalf("effective period = %q, want 2026-07", got)
	}
	r.Period = "2026-08"
	if got := r.EffectivePeriod(); got != "2026-08" {
		t.Fatalf("explicit period = %q, want 2026-08", got)
	}
}
