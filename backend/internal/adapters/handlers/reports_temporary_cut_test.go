package handlers

import (
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

func temporaryCutLines() []domain.ReceiptLine {
	due := time.Date(2026, 9, 20, 0, 0, 0, 0, time.UTC)
	return []domain.ReceiptLine{
		{ReadingID: "a1", CustomerID: "ana", SectorID: "s1", SectorName: "Otro", Period: "2026-09", Total: 40, ExpirationDate: due, ServiceStatus: string(domain.ServiceActive)},
		{ReadingID: "c1", CustomerID: "cut", SectorID: "s2", SectorName: "Patiño", Period: "2026-09", Total: 100, ExpirationDate: due, ServiceStatus: string(domain.ServiceTemporaryCut)},
	}
}

func TestGetCollectionsDashboardLeavesTemporaryCutOutOfDebt(t *testing.T) {
	h, repo := newReportsHandler()
	repo.lines = temporaryCutLines()

	resp, err := h.GetCollectionsDashboard(contextWithUser("admin", "ADMIN"), connect.NewRequest(&involtv1.GetCollectionsDashboardRequest{FromPeriod: "2026-09", ToPeriod: "2026-09"}))
	if err != nil {
		t.Fatal(err)
	}
	if resp.Msg.Totals.TotalDebt != 40 || resp.Msg.Totals.DebtorCount != 1 {
		t.Fatalf("totals = %+v, want only the active customer's debt", resp.Msg.Totals)
	}
	var aging float64
	for _, a := range resp.Msg.Aging {
		aging += a.Amount
	}
	if aging != 40 {
		t.Fatalf("aging = %v, want 40", aging)
	}
	for _, s := range resp.Msg.BySector {
		if s.SectorName == "Patiño" && (s.Debt != 0 || s.Debtors != 0) {
			t.Fatalf("Patiño = %+v, want no debt", s)
		}
	}
}

func TestGetDebtorsHidesTemporaryCutUnlessRequested(t *testing.T) {
	h, repo := newReportsHandler()
	repo.lines = temporaryCutLines()

	all, err := h.GetDebtors(contextWithUser("admin", "ADMIN"), connect.NewRequest(&involtv1.GetDebtorsRequest{}))
	if err != nil {
		t.Fatal(err)
	}
	if len(all.Msg.Debtors) != 1 || all.Msg.TotalDebt != 40 {
		t.Fatalf("default = %+v, want only the active customer", all.Msg)
	}

	cut, err := h.GetDebtors(contextWithUser("admin", "ADMIN"), connect.NewRequest(&involtv1.GetDebtorsRequest{ServiceStatus: involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT}))
	if err != nil {
		t.Fatal(err)
	}
	if len(cut.Msg.Debtors) != 1 || cut.Msg.TotalDebt != 100 {
		t.Fatalf("cut filter = %+v, want the cut customer's debt", cut.Msg)
	}
}
