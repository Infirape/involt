package handlers

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
)

// DownloadPaymentVoucher serves the proof-of-payment PDF at /admin/payments/pdf/{id}.
// Like the receipt PDF, it accepts the JWT as ?token= so it can be opened in a new tab.
func (h *AdminHandler) DownloadPaymentVoucher(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	paymentID := strings.TrimPrefix(r.URL.Path, "/admin/payments/pdf/")

	user, ok := h.documentUser(w, r)
	if !ok {
		return
	}

	payment, err := h.paymentRepo.GetByID(ctx, paymentID)
	if errors.Is(err, domain.ErrPaymentNotFound) {
		http.Error(w, "Payment not found", http.StatusNotFound)
		return
	}
	if err != nil {
		http.Error(w, "Error loading payment", http.StatusInternalServerError)
		return
	}
	customer, err := h.customerRepo.GetByID(ctx, payment.CustomerID)
	if err != nil || customer == nil {
		http.Error(w, "Customer not found", http.StatusNotFound)
		return
	}

	if !canAccessSector(user, customer.SectorID) {
		http.Error(w, "Forbidden: sector not assigned", http.StatusForbidden)
		return
	}

	settings, _ := h.metaRepo.GetSettings(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}
	pdfBytes, err := h.voucherGen.GenerateVoucher(ctx, payment, customer, settings)
	if err != nil {
		log.Printf("⚠️ Error generating voucher %s: %v", paymentID, err)
		http.Error(w, "Error generating PDF", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/pdf")
	w.Header().Set("Content-Disposition", fmt.Sprintf(`inline; filename="comprobante_%06d.pdf"`, payment.ReceiptNumber))
	_, _ = w.Write(pdfBytes)
}

// DownloadAgreementPDF serves the agreement (convenio) PDF at /admin/agreements/pdf/{id}.
func (h *AdminHandler) DownloadAgreementPDF(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	user, ok := h.documentUser(w, r)
	if !ok {
		return
	}
	agreement, err := h.agreementRepo.GetByID(ctx, strings.TrimPrefix(r.URL.Path, "/admin/agreements/pdf/"))
	if errors.Is(err, domain.ErrAgreementNotFound) {
		http.Error(w, "Agreement not found", http.StatusNotFound)
		return
	}
	if err != nil {
		http.Error(w, "Error loading agreement", http.StatusInternalServerError)
		return
	}
	customer, err := h.customerRepo.GetByID(ctx, agreement.CustomerID)
	if err != nil || customer == nil {
		http.Error(w, "Customer not found", http.StatusNotFound)
		return
	}
	if !canAccessSector(user, customer.SectorID) {
		http.Error(w, "Forbidden: sector not assigned", http.StatusForbidden)
		return
	}
	settings, _ := h.metaRepo.GetSettings(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}
	pdfBytes, err := h.agreementDoc.GenerateAgreement(ctx, agreement, customer, settings)
	if err != nil {
		log.Printf("⚠️ Error generating agreement %s: %v", agreement.ID, err)
		http.Error(w, "Error generating PDF", http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/pdf")
	w.Header().Set("Content-Disposition", fmt.Sprintf(`inline; filename="convenio_%06d.pdf"`, agreement.Number))
	_, _ = w.Write(pdfBytes)
}

// documentUser authenticates PDF downloads, which accept the JWT as ?token= so they can be
// opened in a new browser tab.
func (h *AdminHandler) documentUser(w http.ResponseWriter, r *http.Request) (*auth.UserContext, bool) {
	tokenStr := r.URL.Query().Get("token")
	if tokenStr == "" {
		tokenStr = strings.TrimPrefix(r.Header.Get("Authorization"), "Bearer ")
	}
	if tokenStr == "" {
		http.Error(w, "Unauthorized: missing token", http.StatusUnauthorized)
		return nil, false
	}
	claims, err := h.jwtService.ValidateToken(tokenStr)
	if err != nil {
		http.Error(w, "Unauthorized: invalid token", http.StatusUnauthorized)
		return nil, false
	}
	return &auth.UserContext{ID: claims.UserID, Email: claims.Email, Role: claims.Role, AssignedSectorIDs: claims.AssignedSectorIDs}, true
}
