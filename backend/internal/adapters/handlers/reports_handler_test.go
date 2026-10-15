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

type reportRepoStub struct {
	lines       []domain.ReceiptLine
	cash        map[string]float64
	last        map[string]time.Time
	filters     []ports.ReceiptLineFilter
	cashSeen    ports.ReceiptLineFilter
	paymentSeen ports.ReceiptLineFilter
}

func (s *reportRepoStub) ListReceiptLines(_ context.Context, f ports.ReceiptLineFilter) ([]domain.ReceiptLine, error) {
	s.filters = append(s.filters, f)
	var out []domain.ReceiptLine
	for _, l := range s.lines {
		if f.OnlyOutstanding && l.Paid >= l.Total {
			continue
		}
		if f.FromPeriod != "" && l.Period < f.FromPeriod || f.ToPeriod != "" && l.Period > f.ToPeriod {
			continue
		}
		if f.SectorID != "" && l.SectorID != f.SectorID {
			continue
		}
		out = append(out, l)
	}
	return out, nil
}

func (s *reportRepoStub) LastPaymentDates(context.Context, []string) (map[string]time.Time, error) {
	return s.last, nil
}

func (s *reportRepoStub) ListCustomers(_ context.Context, f ports.ReceiptLineFilter) ([]domain.CustomerLine, error) {
	seen := map[string]bool{}
	var out []domain.CustomerLine
	for _, l := range s.lines {
		if (f.SectorID != "" && l.SectorID != f.SectorID) || seen[l.CustomerID] {
			continue
		}
		seen[l.CustomerID] = true
		out = append(out, domain.CustomerLine{CustomerID: l.CustomerID, CustomerCode: l.CustomerCode, CustomerName: l.CustomerName, SectorName: l.SectorName})
	}
	return out, nil
}

func (s *reportRepoStub) ListPaymentLines(_ context.Context, f ports.ReceiptLineFilter) ([]domain.PaymentLine, error) {
	s.paymentSeen = f
	var out []domain.PaymentLine
	for _, l := range s.lines {
		if l.Paid > 0 && (f.SectorID == "" || l.SectorID == f.SectorID) {
			out = append(out, domain.PaymentLine{CustomerCode: l.CustomerCode, SectorName: l.SectorName, Period: l.Period, Amount: l.Paid})
		}
	}
	return out, nil
}

func (s *reportRepoStub) CashInByMonth(_ context.Context, f ports.ReceiptLineFilter) (map[string]float64, error) {
	s.cashSeen = f
	return s.cash, nil
}

func newReportsHandler() (*AdminHandler, *reportRepoStub) {
	repo := &reportRepoStub{
		lines: []domain.ReceiptLine{
			{ReadingID: "a1", CustomerID: "ana", CustomerName: "Ana Luz", CustomerCode: "CHE001", SectorID: "s1", SectorName: "Centro", Period: "2026-06", Total: 10, ExpirationDate: time.Date(2026, 7, 15, 0, 0, 0, 0, time.UTC)},
			{ReadingID: "a2", CustomerID: "ana", CustomerName: "Ana Luz", CustomerCode: "CHE001", SectorID: "s1", SectorName: "Centro", Period: "2026-08", Total: 10, Paid: 4, ExpirationDate: time.Date(2026, 9, 15, 0, 0, 0, 0, time.UTC)},
			{ReadingID: "b1", CustomerID: "beto", CustomerName: "Beto", CustomerCode: "CHE002", SectorID: "s1", SectorName: "Centro", Period: "2026-09", Total: 8, Paid: 8},
			{ReadingID: "c1", CustomerID: "caro", CustomerName: "Caro", CustomerCode: "ALT001", SectorID: "s2", SectorName: "Alto", Period: "2026-08", Total: 12, ExpirationDate: time.Date(2026, 9, 20, 0, 0, 0, 0, time.UTC)},
			{ReadingID: "old", CustomerID: "caro", CustomerName: "Caro", CustomerCode: "ALT001", SectorID: "s2", SectorName: "Alto", Period: "2024-01", Total: 5, ExpirationDate: time.Date(2024, 2, 15, 0, 0, 0, 0, time.UTC)},
		},
		cash: map[string]float64{"2026-09": 12},
		last: map[string]time.Time{"ana": time.Date(2026, 9, 1, 15, 0, 0, 0, time.UTC)},
	}
	return &AdminHandler{reportRepo: repo, clock: func() time.Time { return fixedNow }}, repo
}

func TestGetCollectionsDashboardDefaultsToLast12Months(t *testing.T) {
	h, repo := newReportsHandler()

	resp, err := h.GetCollectionsDashboard(contextWithUser("admin", "ADMIN"), connect.NewRequest(&involtv1.GetCollectionsDashboardRequest{}))
	if err != nil {
		t.Fatalf("GetCollectionsDashboard: %v", err)
	}
	m := resp.Msg
	if m.GetFromPeriod() != "2025-11" || m.GetToPeriod() != "2026-10" || len(m.GetByPeriod()) != 12 {
		t.Fatalf("range = %s..%s with %d months", m.GetFromPeriod(), m.GetToPeriod(), len(m.GetByPeriod()))
	}
	if repo.cashSeen.FromPeriod != "2025-11" {
		t.Fatalf("cash query should use the same range, got %+v", repo.cashSeen)
	}

	totals := m.GetTotals()
	// In range: a1, a2, b1, c1 → billed 40, collected 12. Debt counts ALL periods incl. 2024-01.
	if totals.GetBilled() != 40 || totals.GetCollected() != 12 {
		t.Fatalf("billed/collected = %v / %v", totals.GetBilled(), totals.GetCollected())
	}
	if totals.GetTotalDebt() != 33 || totals.GetDebtorCount() != 2 || totals.GetCutCandidates() != 2 {
		t.Fatalf("debt totals = %+v", totals)
	}

	var sep *involtv1.PeriodCollectionSummary
	for _, p := range m.GetByPeriod() {
		if p.GetPeriod() == "2026-09" {
			sep = p
		}
	}
	if sep == nil || sep.GetBilled() != 8 || sep.GetCashIn() != 12 {
		t.Fatalf("sep summary = %+v", sep)
	}
	if len(m.GetAging()) != 5 || m.GetAging()[4].GetBucket() != involtv1.AgingBucket_AGING_BUCKET_OVER_90 || m.GetAging()[4].GetAmount() != 5 {
		t.Fatalf("aging = %+v", m.GetAging())
	}
	if len(m.GetBySector()) != 2 || m.GetBySector()[0].GetSectorId() != "s1" {
		t.Fatalf("by sector = %+v", m.GetBySector())
	}
}

func TestGetCollectionsDashboardScopesNonAdmins(t *testing.T) {
	h, repo := newReportsHandler()
	_, err := h.GetCollectionsDashboard(contextWithUser("sup", "SUPERVISOR", "s2"), connect.NewRequest(&involtv1.GetCollectionsDashboardRequest{}))
	if err != nil {
		t.Fatalf("GetCollectionsDashboard: %v", err)
	}
	for _, f := range repo.filters {
		if len(f.AllowedSectorIDs) != 1 || f.AllowedSectorIDs[0] != "s2" {
			t.Fatalf("supervisor queries must be restricted to assigned sectors, got %+v", f)
		}
	}
	if repo.cashSeen.AllowedSectorIDs == nil {
		t.Fatal("cash query must be restricted too")
	}
}

func TestGetCollectionsDashboardValidatesRange(t *testing.T) {
	h, _ := newReportsHandler()
	admin := contextWithUser("admin", "ADMIN")
	for _, req := range []*involtv1.GetCollectionsDashboardRequest{
		{FromPeriod: "2026-13"},
		{FromPeriod: "2026-09", ToPeriod: "2026-01"},
		{FromPeriod: "2020-01", ToPeriod: "2026-01"},
	} {
		if _, err := h.GetCollectionsDashboard(admin, connect.NewRequest(req)); connect.CodeOf(err) != connect.CodeInvalidArgument {
			t.Fatalf("%+v: code = %v, want InvalidArgument", req, connect.CodeOf(err))
		}
	}
}

func TestGetDebtorsFiltersAndFlagsCutCandidates(t *testing.T) {
	h, _ := newReportsHandler()
	admin := contextWithUser("admin", "ADMIN")

	resp, err := h.GetDebtors(admin, connect.NewRequest(&involtv1.GetDebtorsRequest{}))
	if err != nil {
		t.Fatalf("GetDebtors: %v", err)
	}
	if len(resp.Msg.GetDebtors()) != 2 || resp.Msg.GetTotalDebt() != 33 || resp.Msg.GetCutCandidates() != 2 {
		t.Fatalf("debtors = %+v", resp.Msg)
	}
	ana := resp.Msg.GetDebtors()[1]
	if ana.GetCustomerId() != "ana" || ana.GetLastPaymentAt() == "" || ana.GetOldestOverduePeriod() != "2026-06" {
		t.Fatalf("ana row = %+v", ana)
	}

	cases := []struct {
		name string
		req  *involtv1.GetDebtorsRequest
		want []string
	}{
		{"search by code", &involtv1.GetDebtorsRequest{Search: "alt0"}, []string{"caro"}},
		{"search by name", &involtv1.GetDebtorsRequest{Search: "luz"}, []string{"ana"}},
		{"min debt", &involtv1.GetDebtorsRequest{MinDebt: 17}, []string{"caro"}},
		{"higher threshold", &involtv1.GetDebtorsRequest{CutThreshold: 3, OnlyCutCandidates: true}, nil},
		{"min overdue receipts", &involtv1.GetDebtorsRequest{MinOverdueReceipts: 2}, []string{"caro", "ana"}},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			resp, err := h.GetDebtors(admin, connect.NewRequest(tc.req))
			if err != nil {
				t.Fatalf("GetDebtors: %v", err)
			}
			var got []string
			for _, d := range resp.Msg.GetDebtors() {
				got = append(got, d.GetCustomerId())
			}
			if len(got) != len(tc.want) {
				t.Fatalf("got %v, want %v", got, tc.want)
			}
			for i := range got {
				if got[i] != tc.want[i] {
					t.Fatalf("got %v, want %v", got, tc.want)
				}
			}
		})
	}
}

func TestDebtorsInAgreementAreNotCutCandidates(t *testing.T) {
	h, _ := newReportsHandler()
	inst, _ := domain.BuildInstallments(17, 0, 2, time.Date(2026, 11, 1, 0, 0, 0, 0, time.UTC))
	h.agreementRepo = &fakeAgreementRepo{agreements: []*domain.Agreement{{
		ID: "ag", CustomerID: "caro", Status: domain.AgreementActive, Total: 17, Installments: inst,
		Receipts: []domain.AgreementReceipt{{ReadingID: "c1", Principal: 12}, {ReadingID: "old", Principal: 5}},
	}}}
	admin := contextWithUser("admin", "ADMIN")

	resp, err := h.GetDebtors(admin, connect.NewRequest(&involtv1.GetDebtorsRequest{}))
	if err != nil {
		t.Fatalf("GetDebtors: %v", err)
	}
	var caro *involtv1.DebtorRow
	for _, d := range resp.Msg.GetDebtors() {
		if d.GetCustomerId() == "caro" {
			caro = d
		}
	}
	if caro == nil || caro.GetCutCandidate() || !caro.GetInAgreement() || caro.GetOverdueReceipts() != 0 {
		t.Fatalf("caro = %+v", caro)
	}
	if resp.Msg.GetCutCandidates() != 1 {
		t.Fatalf("cut candidates = %d, want 1 (only Ana)", resp.Msg.GetCutCandidates())
	}

	dash, _ := h.GetCollectionsDashboard(admin, connect.NewRequest(&involtv1.GetCollectionsDashboardRequest{}))
	if dash.Msg.GetTotals().GetCutCandidates() != 1 {
		t.Fatalf("dashboard cut candidates = %d, want 1", dash.Msg.GetTotals().GetCutCandidates())
	}
}

func TestDebtorsWithAgreementInDefaultAreFlagged(t *testing.T) {
	h, _ := newReportsHandler()
	inst, _ := domain.BuildInstallments(17, 0, 2, time.Date(2026, 8, 1, 0, 0, 0, 0, time.UTC))
	h.agreementRepo = &fakeAgreementRepo{agreements: []*domain.Agreement{{
		ID: "ag", CustomerID: "caro", Status: domain.AgreementActive, Total: 17, Installments: inst,
		Receipts: []domain.AgreementReceipt{{ReadingID: "c1", Principal: 12}, {ReadingID: "old", Principal: 5}},
	}}}

	resp, _ := h.GetDebtors(contextWithUser("admin", "ADMIN"), connect.NewRequest(&involtv1.GetDebtorsRequest{Search: "caro"}))
	caro := resp.Msg.GetDebtors()[0]
	if !caro.GetAgreementInDefault() || caro.GetInAgreement() || !caro.GetCutCandidate() {
		t.Fatalf("caro in default = %+v", caro)
	}
}

func TestGetCollectionsDashboardFiltersBySector(t *testing.T) {
	h, repo := newReportsHandler()
	resp, err := h.GetCollectionsDashboard(contextWithUser("admin", "ADMIN"), connect.NewRequest(&involtv1.GetCollectionsDashboardRequest{SectorId: "s2"}))
	if err != nil {
		t.Fatalf("GetCollectionsDashboard: %v", err)
	}
	for _, f := range repo.filters {
		if f.SectorID != "s2" {
			t.Fatalf("every query must filter by sector, got %+v", f)
		}
	}
	if repo.cashSeen.SectorID != "s2" {
		t.Fatalf("cash query must filter by sector, got %+v", repo.cashSeen)
	}
	if got := resp.Msg.GetTotals().GetBilled(); got != 12 {
		t.Fatalf("billed for Alto = %v, want 12", got)
	}
}
