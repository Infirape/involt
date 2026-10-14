package domain

import (
	"errors"
	"testing"
)

func TestBuildInstallmentsSplitsRemainderInCents(t *testing.T) {
	inst, err := BuildInstallments(100, 10, 3, day(2026, 11, 15))
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(inst) != 3 {
		t.Fatalf("installments = %d, want 3", len(inst))
	}
	// 90 / 3 = 30 each.
	for i, want := range []float64{30, 30, 30} {
		if inst[i].Amount != want || inst[i].Number != i+1 {
			t.Fatalf("installment %d = %+v", i, inst[i])
		}
	}
	if !inst[2].DueDate.Equal(day(2027, 1, 15)) {
		t.Fatalf("third due date = %v, want 2027-01-15", inst[2].DueDate)
	}

	odd, _ := BuildInstallments(10, 0, 3, day(2026, 11, 30))
	if odd[0].Amount != 3.33 || odd[1].Amount != 3.33 || odd[2].Amount != 3.34 {
		t.Fatalf("remainder should go to the last installment: %+v", odd)
	}
	if !odd[2].DueDate.Equal(day(2027, 1, 28)) {
		t.Fatalf("due days clamp to 28 to exist every month, got %v", odd[2].DueDate)
	}
}

func TestBuildInstallmentsValidation(t *testing.T) {
	for _, tc := range []struct {
		total, initial float64
		count          int
	}{{0, 0, 3}, {10, 10, 3}, {10, -1, 3}, {10, 0, 0}} {
		if _, err := BuildInstallments(tc.total, tc.initial, tc.count, day(2026, 11, 1)); !errors.Is(err, ErrInvalidAgreement) {
			t.Fatalf("%+v err = %v, want ErrInvalidAgreement", tc, err)
		}
	}
}

func TestAgreementPolicyCheck(t *testing.T) {
	p := AgreementPolicy{MaxInstallments: 6, MinInitialPercent: 20, GraceDays: 10}
	if err := p.CheckRequest(100, 20, 6); err != nil {
		t.Fatalf("valid request rejected: %v", err)
	}
	if err := p.CheckRequest(100, 19.99, 6); !errors.Is(err, ErrInvalidAgreement) {
		t.Fatalf("low initial err = %v", err)
	}
	if err := p.CheckRequest(100, 50, 7); !errors.Is(err, ErrInvalidAgreement) {
		t.Fatalf("too many installments err = %v", err)
	}
	if err := (AgreementPolicy{}).CheckRequest(100, 0, 1); !errors.Is(err, ErrAgreementsDisabled) {
		t.Fatalf("disabled err = %v", err)
	}
}

func agreementFixture() Agreement {
	inst, _ := BuildInstallments(90, 30, 3, day(2026, 9, 15))
	return Agreement{Total: 90, InitialAmount: 30, Status: AgreementActive, Installments: inst} // 20 each: 9/15, 10/15, 11/15
}

func TestAgreementProgress(t *testing.T) {
	a := agreementFixture()
	grace := 5

	onTrack := ComputeAgreementProgress(a, 50, day(2026, 10, 13), grace)
	if onTrack.Status != AgreementActive || onTrack.InDefault || onTrack.PaidInstallments != 1 {
		t.Fatalf("on track = %+v", onTrack)
	}
	if onTrack.Next == nil || onTrack.Next.Number != 2 || onTrack.NextAmount != 20 {
		t.Fatalf("next installment = %+v / %v", onTrack.Next, onTrack.NextAmount)
	}

	partial := ComputeAgreementProgress(a, 60, day(2026, 10, 13), grace)
	if partial.NextAmount != 10 {
		t.Fatalf("partially paid installment should ask for the rest, got %v", partial.NextAmount)
	}

	// Installment 2 due 10/15 + 5 grace days → in default from 10/21.
	if p := ComputeAgreementProgress(a, 50, day(2026, 10, 20), grace); p.InDefault {
		t.Fatalf("still within grace: %+v", p)
	}
	late := ComputeAgreementProgress(a, 50, day(2026, 10, 21), grace)
	if !late.InDefault || late.Status != AgreementInDefault || late.OverdueAmount != 20 {
		t.Fatalf("late = %+v", late)
	}

	done := ComputeAgreementProgress(a, 90, day(2026, 12, 30), grace)
	if done.Status != AgreementCompleted || done.Next != nil {
		t.Fatalf("completed = %+v", done)
	}

	a.Status = AgreementCancelled
	if p := ComputeAgreementProgress(a, 0, day(2027, 1, 1), grace); p.Status != AgreementCancelled || p.InDefault {
		t.Fatalf("cancelled = %+v", p)
	}
}

func TestAgreementProtectsReceipts(t *testing.T) {
	a := agreementFixture()
	if !ComputeAgreementProgress(a, 30, day(2026, 9, 1), 5).ProtectsReceipts() {
		t.Fatal("on-track agreement should protect its receipts from cut and mora")
	}
	if ComputeAgreementProgress(a, 30, day(2026, 12, 1), 5).ProtectsReceipts() {
		t.Fatal("agreement in default must not protect receipts")
	}
}
