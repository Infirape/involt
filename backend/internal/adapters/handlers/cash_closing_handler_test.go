package handlers

import (
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

func seedClosingPayments() *fakePaymentRepo {
	// 15:00 UTC = 10:00 in Lima on 2026-10-13; 04:00 UTC on the 14th is still the 13th in Lima.
	day := time.Date(2026, 10, 13, 15, 0, 0, 0, time.UTC)
	lateNight := time.Date(2026, 10, 14, 4, 0, 0, 0, time.UTC)
	nextDay := time.Date(2026, 10, 14, 15, 0, 0, 0, time.UTC)
	voidedAt := day.Add(time.Hour)
	return &fakePaymentRepo{payments: []*domain.Payment{
		{ID: "p1", Amount: 10, Method: "CASH", CollectedBy: "u-1", CollectedByEmail: "u1@infira.pe", PaidAt: day},
		{ID: "p2", Amount: 5.5, Method: "YAPE", CollectedBy: "u-2", CollectedByEmail: "u2@infira.pe", PaidAt: lateNight},
		{ID: "p3", Amount: 7, Method: "CASH", CollectedBy: "u-1", CollectedByEmail: "u1@infira.pe", PaidAt: day, VoidedAt: &voidedAt},
		{ID: "p4", Amount: 99, Method: "CASH", CollectedBy: "u-1", CollectedByEmail: "u1@infira.pe", PaidAt: nextDay},
	}}
}

func TestGetCashClosingAggregatesLimaDay(t *testing.T) {
	h := &AdminHandler{paymentRepo: seedClosingPayments(), clock: func() time.Time { return fixedNow }}

	resp, err := h.GetCashClosing(contextWithUser("admin", "ADMIN"), connect.NewRequest(&involtv1.GetCashClosingRequest{
		DateFrom: "2026-10-13", DateTo: "2026-10-13",
	}))
	if err != nil {
		t.Fatalf("GetCashClosing: %v", err)
	}
	m := resp.Msg
	if len(m.GetPayments()) != 3 {
		t.Fatalf("payments = %d, want 3 (p1, p2, voided p3)", len(m.GetPayments()))
	}
	if m.GetTotalAmount() != 15.5 || m.GetPaymentCount() != 2 {
		t.Fatalf("totals = %v / %d, want 15.5 / 2", m.GetTotalAmount(), m.GetPaymentCount())
	}
	if m.GetVoidedAmount() != 7 || m.GetVoidedCount() != 1 {
		t.Fatalf("voided = %v / %d, want 7 / 1", m.GetVoidedAmount(), m.GetVoidedCount())
	}

	byMethod := map[involtv1.PaymentMethod]float64{}
	for _, mt := range m.GetByMethod() {
		byMethod[mt.GetMethod()] = mt.GetAmount()
	}
	if byMethod[involtv1.PaymentMethod_PAYMENT_METHOD_CASH] != 10 || byMethod[involtv1.PaymentMethod_PAYMENT_METHOD_YAPE] != 5.5 {
		t.Fatalf("by method = %v", byMethod)
	}
	if len(m.GetByCollector()) != 2 || m.GetByCollector()[0].GetCollectedByEmail() != "u1@infira.pe" {
		t.Fatalf("by collector = %+v", m.GetByCollector())
	}
}

func TestGetCashClosingDefaultsToTodayAndScopesReaders(t *testing.T) {
	h := &AdminHandler{paymentRepo: seedClosingPayments(), clock: func() time.Time { return fixedNow }}

	resp, err := h.GetCashClosing(contextWithUser("u-2", "READER"), connect.NewRequest(&involtv1.GetCashClosingRequest{CollectedBy: "u-1"}))
	if err != nil {
		t.Fatalf("GetCashClosing: %v", err)
	}
	if resp.Msg.GetPaymentCount() != 1 || resp.Msg.GetPayments()[0].GetId() != "p2" {
		t.Fatalf("reader must only see own payments for today, got %+v", resp.Msg.GetPayments())
	}
}

func TestGetCashClosingRejectsBadDates(t *testing.T) {
	h := &AdminHandler{paymentRepo: seedClosingPayments(), clock: func() time.Time { return fixedNow }}
	admin := contextWithUser("admin", "ADMIN")

	_, err := h.GetCashClosing(admin, connect.NewRequest(&involtv1.GetCashClosingRequest{DateFrom: "13/10/2026"}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("bad format code = %v, want InvalidArgument", connect.CodeOf(err))
	}
	_, err = h.GetCashClosing(admin, connect.NewRequest(&involtv1.GetCashClosingRequest{DateFrom: "2026-10-14", DateTo: "2026-10-13"}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("inverted range code = %v, want InvalidArgument", connect.CodeOf(err))
	}
}
