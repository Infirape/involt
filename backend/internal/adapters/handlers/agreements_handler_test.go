package handlers

import (
	"testing"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// newCollectionsPolicyHandler: Aug receipt (10, overdue) and Sep (12.5, not due) with a fixed
// mora of S/ 1, agreements up to 6 installments with a 10% minimum initial payment.
func newCollectionsPolicyHandler(waive bool) (*AdminHandler, *fakePaymentRepo, *fakeAgreementRepo) {
	h, payments, _ := newPaymentsTestHandler()
	agreements := &fakeAgreementRepo{}
	h.agreementRepo = agreements
	h.policyRepo = &policyRepoStub{policy: domain.CollectionPolicy{
		LateFee:   domain.LateFeePolicy{Mode: domain.LateFeeFixed, Value: 1},
		Agreement: domain.AgreementPolicy{MaxInstallments: 6, MinInitialPercent: 10, GraceDays: 5, WaiveLateFees: waive},
	}}
	return h, payments, agreements
}

func TestCustomerAccountIncludesLateFees(t *testing.T) {
	h, payments, _ := newCollectionsPolicyHandler(false)
	admin := contextWithUser("admin", "ADMIN")

	resp, err := h.GetCustomerAccount(admin, connect.NewRequest(&involtv1.GetCustomerAccountRequest{CustomerId: "cust-1"}))
	if err != nil {
		t.Fatalf("GetCustomerAccount: %v", err)
	}
	if resp.Msg.GetTotalDebt() != 23.5 || resp.Msg.GetTotalLateFees() != 1 || !resp.Msg.GetAgreementsEnabled() {
		t.Fatalf("account totals = %v / %v", resp.Msg.GetTotalDebt(), resp.Msg.GetTotalLateFees())
	}
	if aug := resp.Msg.GetReceipts()[0]; aug.GetLateFee() != 1 {
		t.Fatalf("aug late fee = %v, want 1", aug.GetLateFee())
	}

	if _, err := h.RegisterPayment(admin, connect.NewRequest(&involtv1.RegisterPaymentRequest{CustomerId: "cust-1", Amount: 3})); err != nil {
		t.Fatalf("RegisterPayment: %v", err)
	}
	a := payments.payments[0].Allocations[0]
	if a.ReadingID != "r-aug" || a.LateFee != 1 || a.Amount != 2 {
		t.Fatalf("allocation = %+v, want mora 1 + principal 2", a)
	}
}

func TestWaiveLateFee(t *testing.T) {
	h, _, agreements := newCollectionsPolicyHandler(false)

	_, err := h.WaiveLateFee(contextWithUser("r", "READER", "sec-1"), connect.NewRequest(&involtv1.WaiveLateFeeRequest{ReadingIds: []string{"r-aug"}, Reason: "x"}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("reader code = %v", connect.CodeOf(err))
	}
	sup := contextWithUser("sup", "SUPERVISOR", "sec-1")
	_, err = h.WaiveLateFee(sup, connect.NewRequest(&involtv1.WaiveLateFeeRequest{ReadingIds: []string{"r-aug"}}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("missing reason code = %v", connect.CodeOf(err))
	}
	if _, err := h.WaiveLateFee(sup, connect.NewRequest(&involtv1.WaiveLateFeeRequest{ReadingIds: []string{"r-aug"}, Reason: "Adulto mayor"})); err != nil {
		t.Fatalf("WaiveLateFee: %v", err)
	}
	if len(agreements.waivers) != 1 || agreements.waivers[0].WaivedBy != "sup" {
		t.Fatalf("waivers = %+v", agreements.waivers)
	}
	resp, _ := h.GetCustomerAccount(sup, connect.NewRequest(&involtv1.GetCustomerAccountRequest{CustomerId: "cust-1"}))
	if resp.Msg.GetTotalLateFees() != 0 || !resp.Msg.GetReceipts()[0].GetLateFeeWaived() {
		t.Fatalf("waived account = %+v", resp.Msg.GetReceipts()[0])
	}
}

func TestPreviewAgreement(t *testing.T) {
	h, _, _ := newCollectionsPolicyHandler(false)
	admin := contextWithUser("admin", "ADMIN")

	resp, err := h.PreviewAgreement(admin, connect.NewRequest(&involtv1.AgreementRequest{
		CustomerId: "cust-1", Installments: 3, InitialAmount: 5, FirstDueDate: "2026-11-15",
	}))
	if err != nil {
		t.Fatalf("PreviewAgreement: %v", err)
	}
	m := resp.Msg
	if m.GetValidationError() != "" || m.GetTotal() != 23.5 || m.GetLateFees() != 1 || m.GetMinInitialAmount() != 2.35 {
		t.Fatalf("preview = %+v", m)
	}
	if len(m.GetInstallments()) != 3 || m.GetInstallments()[0].GetAmount() != 6.16 || m.GetInstallments()[2].GetDueDate() != "2027-01-15" {
		t.Fatalf("installments = %+v", m.GetInstallments())
	}

	bad, err := h.PreviewAgreement(admin, connect.NewRequest(&involtv1.AgreementRequest{CustomerId: "cust-1", Installments: 7}))
	if err != nil || bad.Msg.GetValidationError() == "" {
		t.Fatalf("invalid preview should report validation error, got %v / %q", err, bad.Msg.GetValidationError())
	}
}

func TestCreateAgreementCollectsInitialPaymentAndProtectsReceipts(t *testing.T) {
	h, payments, agreements := newCollectionsPolicyHandler(false)
	admin := contextWithUser("admin", "ADMIN")
	req := &involtv1.AgreementRequest{CustomerId: "cust-1", Installments: 3, InitialAmount: 5}

	resp, err := h.CreateAgreement(admin, connect.NewRequest(req))
	if err != nil {
		t.Fatalf("CreateAgreement: %v", err)
	}
	ag := resp.Msg.GetAgreement()
	if ag.GetNumber() != 1 || ag.GetTotal() != 23.5 || ag.GetStatus() != involtv1.AgreementStatus_AGREEMENT_STATUS_ACTIVE {
		t.Fatalf("agreement = %+v", ag)
	}
	if len(payments.payments) != 1 || payments.payments[0].Amount != 5 || resp.Msg.GetInitialPaymentId() == "" {
		t.Fatalf("initial payment = %+v", payments.payments)
	}
	stored := agreements.agreements[0]
	if stored.Receipts[0].ReadingID != "r-aug" || stored.Receipts[0].LateFee != 1 || stored.Installments[0].DueDate.Format("2006-01-02") != "2026-11-13" {
		t.Fatalf("stored agreement = %+v", stored)
	}

	account, _ := h.GetCustomerAccount(admin, connect.NewRequest(&involtv1.GetCustomerAccountRequest{CustomerId: "cust-1"}))
	if st := account.Msg.GetReceipts()[0].GetStatus(); st != involtv1.ReceiptStatus_RECEIPT_STATUS_IN_AGREEMENT {
		t.Fatalf("covered receipt status = %v, want IN_AGREEMENT", st)
	}
	if len(account.Msg.GetAgreements()) != 1 {
		t.Fatalf("account agreements = %+v", account.Msg.GetAgreements())
	}

	if _, err := h.CreateAgreement(admin, connect.NewRequest(req)); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("second agreement code = %v, want FailedPrecondition", connect.CodeOf(err))
	}
}

func TestCreateAgreementWaivesLateFeesWhenConfigured(t *testing.T) {
	h, _, agreements := newCollectionsPolicyHandler(true)
	resp, err := h.CreateAgreement(contextWithUser("admin", "ADMIN"), connect.NewRequest(&involtv1.AgreementRequest{
		CustomerId: "cust-1", Installments: 2, InitialAmount: 2.25,
	}))
	if err != nil {
		t.Fatalf("CreateAgreement: %v", err)
	}
	if resp.Msg.GetAgreement().GetTotal() != 22.5 || !resp.Msg.GetAgreement().GetLateFeesWaived() {
		t.Fatalf("agreement = %+v", resp.Msg.GetAgreement())
	}
	if len(agreements.waivers) != 2 || agreements.waivers[0].AgreementID == "" {
		t.Fatalf("waivers = %+v", agreements.waivers)
	}
}

func TestCancelAgreement(t *testing.T) {
	h, _, _ := newCollectionsPolicyHandler(false)
	admin := contextWithUser("admin", "ADMIN")
	created, err := h.CreateAgreement(admin, connect.NewRequest(&involtv1.AgreementRequest{CustomerId: "cust-1", Installments: 2, InitialAmount: 3}))
	if err != nil {
		t.Fatalf("CreateAgreement: %v", err)
	}
	id := created.Msg.GetAgreement().GetId()

	if _, err := h.CancelAgreement(contextWithUser("r", "READER", "sec-1"), connect.NewRequest(&involtv1.CancelAgreementRequest{AgreementId: id, Reason: "x"})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("reader cancel code = %v", connect.CodeOf(err))
	}
	if _, err := h.CancelAgreement(admin, connect.NewRequest(&involtv1.CancelAgreementRequest{AgreementId: id})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("no reason code = %v", connect.CodeOf(err))
	}
	resp, err := h.CancelAgreement(admin, connect.NewRequest(&involtv1.CancelAgreementRequest{AgreementId: id, Reason: "Incumplimiento"}))
	if err != nil || resp.Msg.GetAgreement().GetStatus() != involtv1.AgreementStatus_AGREEMENT_STATUS_CANCELLED {
		t.Fatalf("cancel = %v / %+v", err, resp)
	}
}

func TestCollectionPolicyRPCs(t *testing.T) {
	h, _, _ := newCollectionsPolicyHandler(false)
	policy := &involtv1.CollectionPolicy{
		LateFeeMode: involtv1.LateFeeMode_LATE_FEE_MODE_PERCENT, LateFeeValue: 2, LateFeeStartDate: "2026-11-01",
		AgreementMaxInstallments: 12, AgreementMinInitialPercent: 20, AgreementGraceDays: 10,
	}

	if _, err := h.UpdateCollectionPolicy(contextWithUser("s", "SUPERVISOR"), connect.NewRequest(&involtv1.UpdateCollectionPolicyRequest{Policy: policy})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("supervisor update code = %v", connect.CodeOf(err))
	}
	admin := contextWithUser("admin", "ADMIN")
	bad := &involtv1.CollectionPolicy{LateFeeMode: involtv1.LateFeeMode_LATE_FEE_MODE_FIXED, LateFeeValue: 0}
	if _, err := h.UpdateCollectionPolicy(admin, connect.NewRequest(&involtv1.UpdateCollectionPolicyRequest{Policy: bad})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("invalid policy code = %v", connect.CodeOf(err))
	}
	if _, err := h.UpdateCollectionPolicy(admin, connect.NewRequest(&involtv1.UpdateCollectionPolicyRequest{Policy: policy})); err != nil {
		t.Fatalf("UpdateCollectionPolicy: %v", err)
	}

	got, err := h.GetCollectionPolicy(contextWithUser("r", "READER"), connect.NewRequest(&involtv1.GetCollectionPolicyRequest{}))
	if err != nil {
		t.Fatalf("GetCollectionPolicy: %v", err)
	}
	p := got.Msg.GetPolicy()
	if p.GetLateFeeMode() != involtv1.LateFeeMode_LATE_FEE_MODE_PERCENT || p.GetLateFeeStartDate() != "2026-11-01" || p.GetAgreementMinInitialPercent() != 20 || p.GetUpdatedBy() != "admin@infira.pe" {
		t.Fatalf("policy = %+v", p)
	}
}
