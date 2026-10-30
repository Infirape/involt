package handlers

import (
	"time"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// limaZone is Peru's fixed UTC-5 offset (no DST); cash desk days follow it.
var limaZone = time.FixedZone("America/Lima", -5*60*60)

// now returns the current time in Lima, overridable in tests.
func (h *AdminHandler) now() time.Time {
	if h.clock != nil {
		return h.clock().In(limaZone)
	}
	return time.Now().In(limaZone)
}

var paymentMethodsToProto = map[domain.PaymentMethod]involtv1.PaymentMethod{
	domain.PaymentMethodCash:     involtv1.PaymentMethod_PAYMENT_METHOD_CASH,
	domain.PaymentMethodYape:     involtv1.PaymentMethod_PAYMENT_METHOD_YAPE,
	domain.PaymentMethodPlin:     involtv1.PaymentMethod_PAYMENT_METHOD_PLIN,
	domain.PaymentMethodTransfer: involtv1.PaymentMethod_PAYMENT_METHOD_TRANSFER,
	domain.PaymentMethodOther:    involtv1.PaymentMethod_PAYMENT_METHOD_OTHER,
}

func paymentMethodToProto(method string) involtv1.PaymentMethod {
	if m, ok := paymentMethodsToProto[domain.PaymentMethod(method)]; ok {
		return m
	}
	return involtv1.PaymentMethod_PAYMENT_METHOD_UNSPECIFIED
}

// paymentMethodFromProto maps the wire enum; UNSPECIFIED defaults to cash.
func paymentMethodFromProto(method involtv1.PaymentMethod) (domain.PaymentMethod, bool) {
	if method == involtv1.PaymentMethod_PAYMENT_METHOD_UNSPECIFIED {
		return domain.PaymentMethodCash, true
	}
	for d, p := range paymentMethodsToProto {
		if p == method {
			return d, true
		}
	}
	return "", false
}

func receiptStatusToProto(status domain.ReceiptStatus) involtv1.ReceiptStatus {
	switch status {
	case domain.ReceiptStatusPaid:
		return involtv1.ReceiptStatus_RECEIPT_STATUS_PAID
	case domain.ReceiptStatusPartial:
		return involtv1.ReceiptStatus_RECEIPT_STATUS_PARTIAL
	case domain.ReceiptStatusPending:
		return involtv1.ReceiptStatus_RECEIPT_STATUS_PENDING
	case domain.ReceiptStatusOverdue:
		return involtv1.ReceiptStatus_RECEIPT_STATUS_OVERDUE
	case domain.ReceiptStatusInAgreement:
		return involtv1.ReceiptStatus_RECEIPT_STATUS_IN_AGREEMENT
	}
	return involtv1.ReceiptStatus_RECEIPT_STATUS_UNSPECIFIED
}

func mapPaymentToProto(p *domain.Payment) *involtv1.Payment {
	if p == nil {
		return nil
	}
	out := &involtv1.Payment{
		Id:               p.ID,
		ReceiptNumber:    p.ReceiptNumber,
		CustomerId:       p.CustomerID,
		CustomerName:     p.CustomerName,
		CustomerCode:     p.CustomerCode,
		Amount:           p.Amount,
		Method:           paymentMethodToProto(p.Method),
		Reference:        p.Reference,
		Observation:      p.Observation,
		CollectedBy:      p.CollectedBy,
		CollectedByEmail: p.CollectedByEmail,
		PaidAt:           p.PaidAt.Format(time.RFC3339),
		Voided:           p.IsVoided(),
		VoidReason:       p.VoidReason,
	}
	if p.VoidedAt != nil {
		out.VoidedAt = p.VoidedAt.Format(time.RFC3339)
	}
	for _, a := range p.Allocations {
		out.Allocations = append(out.Allocations, &involtv1.PaymentAllocation{
			ReadingId: a.ReadingID,
			Period:    a.Period,
			Amount:    a.Amount,
			LateFee:   a.LateFee,
		})
	}
	return out
}

func readingIDs(readings []domain.Reading) []string {
	ids := make([]string, len(readings))
	for i, r := range readings {
		ids[i] = r.ID
	}
	return ids
}

// canAccessSector mirrors the PDF download rule: admins see everything,
// other roles only their assigned sectors.
func canAccessSector(user *auth.UserContext, sectorID string) bool {
	if user.Role == string(domain.RoleAdmin) {
		return true
	}
	for _, id := range user.AssignedSectorIDs {
		if id == sectorID {
			return true
		}
	}
	return false
}

// canManagePayments reports whether the user may void payments or see every collector.
func canManagePayments(user *auth.UserContext) bool {
	return user.Role == string(domain.RoleAdmin) || user.Role == string(domain.RoleSupervisor)
}
