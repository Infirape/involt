package handlers

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
)

type voucherGenStub struct{ called bool }

func (s *voucherGenStub) GenerateVoucher(context.Context, *domain.Payment, *domain.Customer, *domain.Settings) ([]byte, error) {
	s.called = true
	return []byte("%PDF-voucher"), nil
}

func newVoucherTestHandler(t *testing.T) (*AdminHandler, *voucherGenStub, func(role string, sectors ...string) string) {
	t.Helper()
	h, payments, _ := newPaymentsTestHandler()
	payments.payments = []*domain.Payment{{ID: "pay-1", ReceiptNumber: 7, CustomerID: "cust-1", Amount: 5}}
	gen := &voucherGenStub{}
	h.voucherGen = gen
	h.jwtService = auth.NewJWTService("test-secret")
	token := func(role string, sectors ...string) string {
		tok, err := h.jwtService.GenerateToken(&domain.User{ID: "u", Email: "u@infira.pe", Role: domain.UserRole(role), AssignedSectorIDs: sectors})
		if err != nil {
			t.Fatalf("token: %v", err)
		}
		return tok
	}
	return h, gen, token
}

func TestDownloadPaymentVoucherServesPDF(t *testing.T) {
	h, gen, token := newVoucherTestHandler(t)

	rec := httptest.NewRecorder()
	req := httptest.NewRequest(http.MethodGet, "/admin/payments/pdf/pay-1?token="+token("ADMIN"), nil)
	h.DownloadPaymentVoucher(rec, req)

	if rec.Code != http.StatusOK || !gen.called {
		t.Fatalf("status = %d, generator called = %v", rec.Code, gen.called)
	}
	if ct := rec.Header().Get("Content-Type"); ct != "application/pdf" {
		t.Fatalf("content type = %q", ct)
	}
	if cd := rec.Header().Get("Content-Disposition"); cd != `inline; filename="comprobante_000007.pdf"` {
		t.Fatalf("content disposition = %q", cd)
	}
}

func TestDownloadPaymentVoucherAuthorization(t *testing.T) {
	h, _, token := newVoucherTestHandler(t)
	cases := []struct {
		name string
		url  string
		code int
	}{
		{"missing token", "/admin/payments/pdf/pay-1", http.StatusUnauthorized},
		{"bad token", "/admin/payments/pdf/pay-1?token=nope", http.StatusUnauthorized},
		{"other sector", "/admin/payments/pdf/pay-1?token=" + token("SUPERVISOR", "sec-9"), http.StatusForbidden},
		{"unknown payment", "/admin/payments/pdf/ghost?token=" + token("ADMIN"), http.StatusNotFound},
		{"assigned sector", "/admin/payments/pdf/pay-1?token=" + token("SUPERVISOR", "sec-1"), http.StatusOK},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			rec := httptest.NewRecorder()
			h.DownloadPaymentVoucher(rec, httptest.NewRequest(http.MethodGet, tc.url, nil))
			if rec.Code != tc.code {
				t.Fatalf("status = %d, want %d", rec.Code, tc.code)
			}
		})
	}
}

type agreementDocStub struct{}

func (agreementDocStub) GenerateAgreement(context.Context, *domain.Agreement, *domain.Customer, *domain.Settings) ([]byte, error) {
	return []byte("%PDF-agreement"), nil
}

func TestDownloadAgreementPDF(t *testing.T) {
	h, _, token := newVoucherTestHandler(t)
	h.agreementDoc = agreementDocStub{}
	h.agreementRepo = &fakeAgreementRepo{agreements: []*domain.Agreement{{ID: "ag-1", Number: 3, CustomerID: "cust-1"}}}

	cases := []struct {
		url  string
		code int
	}{
		{"/admin/agreements/pdf/ag-1?token=" + token("ADMIN"), http.StatusOK},
		{"/admin/agreements/pdf/ag-1?token=" + token("SUPERVISOR", "sec-9"), http.StatusForbidden},
		{"/admin/agreements/pdf/ghost?token=" + token("ADMIN"), http.StatusNotFound},
		{"/admin/agreements/pdf/ag-1", http.StatusUnauthorized},
	}
	for _, tc := range cases {
		rec := httptest.NewRecorder()
		h.DownloadAgreementPDF(rec, httptest.NewRequest(http.MethodGet, tc.url, nil))
		if rec.Code != tc.code {
			t.Fatalf("%s: status = %d, want %d", tc.url, rec.Code, tc.code)
		}
	}
	rec := httptest.NewRecorder()
	h.DownloadAgreementPDF(rec, httptest.NewRequest(http.MethodGet, "/admin/agreements/pdf/ag-1?token="+token("ADMIN"), nil))
	if cd := rec.Header().Get("Content-Disposition"); cd != `inline; filename="convenio_000003.pdf"` {
		t.Fatalf("content disposition = %q", cd)
	}
}
