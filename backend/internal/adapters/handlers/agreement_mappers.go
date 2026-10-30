package handlers

import (
	"time"

	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

func agreementStatusToProto(s domain.AgreementStatus) involtv1.AgreementStatus {
	switch s {
	case domain.AgreementActive:
		return involtv1.AgreementStatus_AGREEMENT_STATUS_ACTIVE
	case domain.AgreementInDefault:
		return involtv1.AgreementStatus_AGREEMENT_STATUS_IN_DEFAULT
	case domain.AgreementCompleted:
		return involtv1.AgreementStatus_AGREEMENT_STATUS_COMPLETED
	case domain.AgreementCancelled:
		return involtv1.AgreementStatus_AGREEMENT_STATUS_CANCELLED
	}
	return involtv1.AgreementStatus_AGREEMENT_STATUS_UNSPECIFIED
}

func mapAgreementReceipts(receipts []domain.AgreementReceipt) []*involtv1.AgreementReceipt {
	out := make([]*involtv1.AgreementReceipt, 0, len(receipts))
	for _, rc := range receipts {
		out = append(out, &involtv1.AgreementReceipt{
			ReadingId: rc.ReadingID, Period: rc.Period, Principal: rc.Principal, LateFee: rc.LateFee,
		})
	}
	return out
}

// mapInstallments marks the first paidCount installments as paid.
func mapInstallments(installments []domain.Installment, paidCount int) []*involtv1.AgreementInstallment {
	out := make([]*involtv1.AgreementInstallment, 0, len(installments))
	for i, in := range installments {
		out = append(out, &involtv1.AgreementInstallment{
			Number: int32(in.Number), DueDate: in.DueDate.Format("2006-01-02"), Amount: in.Amount, Paid: i < paidCount,
		})
	}
	return out
}

// mapAgreementToProto includes the agreement's progress as of today.
func (h *AdminHandler) mapAgreementToProto(a *domain.Agreement, policy domain.CollectionPolicy) *involtv1.PaymentAgreement {
	progress := domain.ComputeAgreementProgress(*a, a.PaidSinceSigning, h.now(), policy.Agreement.GraceDays)
	out := &involtv1.PaymentAgreement{
		Id: a.ID, Number: a.Number, CustomerId: a.CustomerID, CustomerName: a.CustomerName, CustomerCode: a.CustomerCode,
		Status: agreementStatusToProto(progress.Status), Total: a.Total, InitialAmount: a.InitialAmount,
		Paid: progress.Paid, Notes: a.Notes, CreatedAt: a.CreatedAt.Format(time.RFC3339),
		CreatedByEmail: a.CreatedByEmail, CancelReason: a.CancelReason,
		Receipts:      mapAgreementReceipts(a.Receipts),
		Installments:  mapInstallments(a.Installments, progress.PaidInstallments),
		OverdueAmount: progress.OverdueAmount, LateFeesWaived: a.LateFeesWaived,
	}
	if a.CancelledAt != nil {
		out.CancelledAt = a.CancelledAt.Format(time.RFC3339)
	}
	if progress.Next != nil {
		out.NextInstallment = int32(progress.Next.Number)
		out.NextAmount = progress.NextAmount
		out.NextDueDate = progress.Next.DueDate.Format("2006-01-02")
	}
	return out
}
