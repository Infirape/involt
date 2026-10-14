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

	tokenStr := r.URL.Query().Get("token")
	if tokenStr == "" {
		tokenStr = strings.TrimPrefix(r.Header.Get("Authorization"), "Bearer ")
	}
	if tokenStr == "" {
		http.Error(w, "Unauthorized: missing token", http.StatusUnauthorized)
		return
	}
	claims, err := h.jwtService.ValidateToken(tokenStr)
	if err != nil {
		http.Error(w, "Unauthorized: invalid token", http.StatusUnauthorized)
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

	user := &auth.UserContext{ID: claims.UserID, Role: claims.Role, AssignedSectorIDs: claims.AssignedSectorIDs}
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
