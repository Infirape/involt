package handlers

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

type statusRepoStub struct {
	changes []domain.ServiceStatusChange
	current map[string]domain.ServiceStatus
	counts  map[domain.ServiceStatus]int
	seen    ports.ReceiptLineFilter
}

func (s *statusRepoStub) SetStatus(_ context.Context, id string, to domain.ServiceStatus, reason, by, email string) (*domain.ServiceStatusChange, error) {
	from := s.current[id]
	if from == "" {
		from = domain.ServiceActive
	}
	if err := domain.ValidateServiceStatusChange(from, to, reason); err != nil {
		return nil, err
	}
	s.current[id] = to
	c := domain.ServiceStatusChange{CustomerID: id, PreviousStatus: string(from), Status: string(to), Reason: reason,
		ChangedBy: by, ChangedByEmail: email, ChangedAt: time.Date(2026, 10, 15, 15, 0, 0, 0, time.UTC)}
	s.changes = append([]domain.ServiceStatusChange{c}, s.changes...)
	return &c, nil
}

func (s *statusRepoStub) History(context.Context, string) ([]domain.ServiceStatusChange, error) {
	return s.changes, nil
}

func (s *statusRepoStub) CountByStatus(_ context.Context, f ports.ReceiptLineFilter) (map[domain.ServiceStatus]int, error) {
	s.seen = f
	return s.counts, nil
}

func TestSetCustomerServiceStatus(t *testing.T) {
	h, _, _ := newPaymentsTestHandler()
	repo := &statusRepoStub{current: map[string]domain.ServiceStatus{}}
	h.statusRepo = repo
	req := &involtv1.SetCustomerServiceStatusRequest{CustomerId: "cust-1", Status: involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT, Reason: "Deuda de 3 meses"}

	if _, err := h.SetCustomerServiceStatus(contextWithUser("s", "SUPERVISOR", "sec-1"), connect.NewRequest(req)); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("supervisor code = %v, want PermissionDenied (admins only)", connect.CodeOf(err))
	}
	admin := contextWithUser("admin", "ADMIN")
	bad := &involtv1.SetCustomerServiceStatusRequest{CustomerId: "cust-1", Status: involtv1.ServiceStatus_SERVICE_STATUS_UNSPECIFIED, Reason: "x"}
	if _, err := h.SetCustomerServiceStatus(admin, connect.NewRequest(bad)); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("unspecified status code = %v", connect.CodeOf(err))
	}
	resp, err := h.SetCustomerServiceStatus(admin, connect.NewRequest(req))
	if err != nil {
		t.Fatalf("SetCustomerServiceStatus: %v", err)
	}
	if resp.Msg.GetCustomer().GetId() != "cust-1" || repo.changes[0].ChangedByEmail != "admin@infira.pe" {
		t.Fatalf("resp = %+v changes = %+v", resp.Msg, repo.changes)
	}
	if _, err := h.SetCustomerServiceStatus(admin, connect.NewRequest(req)); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("repeating the same status code = %v, want FailedPrecondition", connect.CodeOf(err))
	}
	noReason := &involtv1.SetCustomerServiceStatusRequest{CustomerId: "cust-1", Status: involtv1.ServiceStatus_SERVICE_STATUS_ACTIVE}
	if _, err := h.SetCustomerServiceStatus(admin, connect.NewRequest(noReason)); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("missing reason code = %v", connect.CodeOf(err))
	}

	history, err := h.GetCustomerStatusHistory(contextWithUser("s", "SUPERVISOR", "sec-1"), connect.NewRequest(&involtv1.GetCustomerStatusHistoryRequest{CustomerId: "cust-1"}))
	if err != nil {
		t.Fatalf("GetCustomerStatusHistory: %v", err)
	}
	c := history.Msg.GetChanges()
	if len(c) != 1 || c[0].GetStatus() != involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT || c[0].GetPreviousStatus() != involtv1.ServiceStatus_SERVICE_STATUS_ACTIVE {
		t.Fatalf("history = %+v", c)
	}
}

func TestDebtorsServiceStatusFilterAndDashboardCounts(t *testing.T) {
	h, repo := newReportsHandler()
	repo.lines[3].ServiceStatus = "TEMPORARY_CUT" // Caro (c1)
	repo.lines[4].ServiceStatus = "TEMPORARY_CUT" // Caro (old)
	status := &statusRepoStub{counts: map[domain.ServiceStatus]int{domain.ServiceTemporaryCut: 3, domain.ServiceNoPower: 1}}
	h.statusRepo = status
	admin := contextWithUser("admin", "ADMIN")

	resp, err := h.GetDebtors(admin, connect.NewRequest(&involtv1.GetDebtorsRequest{ServiceStatus: involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT}))
	if err != nil {
		t.Fatalf("GetDebtors: %v", err)
	}
	if len(resp.Msg.GetDebtors()) != 1 || resp.Msg.GetDebtors()[0].GetServiceStatus() != involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT {
		t.Fatalf("debtors = %+v", resp.Msg.GetDebtors())
	}

	dash, err := h.GetCollectionsDashboard(admin, connect.NewRequest(&involtv1.GetCollectionsDashboardRequest{SectorId: "s1"}))
	if err != nil {
		t.Fatalf("GetCollectionsDashboard: %v", err)
	}
	if dash.Msg.GetTotals().GetTemporaryCutCount() != 3 || dash.Msg.GetTotals().GetNoPowerCount() != 1 || status.seen.SectorID != "s1" {
		t.Fatalf("totals = %+v seen = %+v", dash.Msg.GetTotals(), status.seen)
	}
}

func TestGetCustomersReturnsServiceStatus(t *testing.T) {
	changed := time.Date(2026, 10, 15, 16, 0, 0, 0, time.UTC)
	h := &AdminHandler{customerRepo: &collectionsCustomerRepoStub{listFunc: func() ([]domain.Customer, int, error) {
		return []domain.Customer{{ID: "c1", Code: "ACH002", ServiceStatus: "TEMPORARY_CUT", ServiceStatusChangedAt: &changed}, {ID: "c2", Code: "ACH003"}}, 2, nil
	}}}
	resp, err := h.GetCustomers(contextWithUser("admin", "ADMIN"), connect.NewRequest(&involtv1.GetCustomersRequest{PageNumber: 1, PageSize: 10}))
	if err != nil {
		t.Fatalf("GetCustomers: %v", err)
	}
	got := resp.Msg.GetCustomers()
	if got[0].GetServiceStatus() != involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT || got[0].GetServiceStatusChangedAt() == "" {
		t.Fatalf("customer list must carry the service status, got %+v", got[0])
	}
	if got[1].GetServiceStatus() != involtv1.ServiceStatus_SERVICE_STATUS_ACTIVE {
		t.Fatalf("customers without status are active, got %v", got[1].GetServiceStatus())
	}
}
