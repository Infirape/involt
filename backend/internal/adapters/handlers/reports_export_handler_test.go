package handlers

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

type workbookStub struct {
	meta       ports.WorkbookMeta
	debtors    *involtv1.GetDebtorsResponse
	data       ports.CollectionsWorkbookData
	remittance ports.RemittanceData
}

func (s *workbookStub) DebtorsWorkbook(_ context.Context, r *involtv1.GetDebtorsResponse, m ports.WorkbookMeta) ([]byte, error) {
	s.debtors, s.meta = r, m
	return []byte("xlsx"), nil
}

func (s *workbookStub) CashClosingWorkbook(_ context.Context, _ *involtv1.GetCashClosingResponse, m ports.WorkbookMeta) ([]byte, error) {
	s.meta = m
	return []byte("xlsx"), nil
}

func (s *workbookStub) CollectionsWorkbook(_ context.Context, data ports.CollectionsWorkbookData, m ports.WorkbookMeta) ([]byte, error) {
	s.data, s.meta = data, m
	return []byte("xlsx"), nil
}

func (s *workbookStub) RemittanceWorkbook(_ context.Context, data ports.RemittanceData, m ports.WorkbookMeta) ([]byte, error) {
	s.remittance, s.meta = data, m
	return []byte("xlsx"), nil
}

func newExportHandler(t *testing.T) (*AdminHandler, *workbookStub, string) {
	h, gen, token, _ := newExportHandlerWithRepo(t)
	return h, gen, token
}

func newExportHandlerWithRepo(t *testing.T) (*AdminHandler, *workbookStub, string, *reportRepoStub) {
	t.Helper()
	h, repo := newReportsHandler()
	gen := &workbookStub{}
	h.workbookGen = gen
	h.paymentRepo = seedClosingPayments()
	h.metaRepo = &settingsMetaStub{settings: &domain.Settings{Municipalidad: "MD Chetilla", Empresa: "Qarwaqiru"}}
	h.jwtService = auth.NewJWTService("test-secret")
	token, _ := h.jwtService.GenerateToken(&domain.User{ID: "admin", Email: "admin@infira.pe", Role: domain.RoleAdmin})
	return h, gen, token, repo
}

func TestExportDebtorsXLSX(t *testing.T) {
	h, gen, token := newExportHandler(t)
	rec := httptest.NewRecorder()
	h.ExportDebtorsXLSX(rec, httptest.NewRequest(http.MethodGet, "/admin/reports/debtors.xlsx?search=caro&token="+token, nil))

	if rec.Code != http.StatusOK {
		t.Fatalf("status = %d: %s", rec.Code, rec.Body.String())
	}
	if ct := rec.Header().Get("Content-Type"); ct != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" {
		t.Fatalf("content type = %q", ct)
	}
	if len(gen.debtors.GetDebtors()) != 1 || gen.debtors.GetDebtors()[0].GetCustomerId() != "caro" {
		t.Fatalf("filters not applied: %+v", gen.debtors)
	}

	rec = httptest.NewRecorder()
	h.ExportDebtorsXLSX(rec, httptest.NewRequest(http.MethodGet, "/admin/reports/debtors.xlsx?service_status=3&token="+token, nil))
	if rec.Code != http.StatusOK || len(gen.debtors.GetDebtors()) != 0 {
		t.Fatalf("service status filter (sin energía) not applied: %d %+v", rec.Code, gen.debtors.GetDebtors())
	}
	if gen.meta.Entity != "MD Chetilla" || gen.meta.GeneratedBy != "admin@infira.pe" {
		t.Fatalf("meta = %+v", gen.meta)
	}
}

func TestExportCollectionsXLSXIncludesReceiptLines(t *testing.T) {
	h, gen, token, repo := newExportHandlerWithRepo(t)
	rec := httptest.NewRecorder()
	h.ExportCollectionsXLSX(rec, httptest.NewRequest(http.MethodGet, "/admin/reports/collections.xlsx?sector_id=s2&token="+token, nil))
	if rec.Code != http.StatusOK {
		t.Fatalf("status = %d: %s", rec.Code, rec.Body.String())
	}
	for _, l := range gen.data.Receipts {
		if l.SectorID != "s2" || l.Period < "2025-11" {
			t.Fatalf("receipt lines must follow the filters and range, got %+v", l)
		}
	}
	if len(gen.data.Receipts) != 1 {
		t.Fatalf("lines = %d, want 1 (Caro Aug; 2024 receipt is out of range)", len(gen.data.Receipts))
	}
	if gen.data.Report == nil || len(gen.data.Customers) != 1 || gen.data.Customers[0].CustomerCode != "ALT001" {
		t.Fatalf("customers = %+v, want only the supplies of the filtered caserío", gen.data.Customers)
	}
	if seen := repo.paymentSeen; seen.SectorID != "s2" || seen.FromPeriod != "2025-11" || seen.ToPeriod != "2026-10" {
		t.Fatalf("payments must use the same filters and range, got %+v", seen)
	}
}

func TestExportCashClosingXLSXValidatesAndAuthenticates(t *testing.T) {
	h, _, token := newExportHandler(t)
	rec := httptest.NewRecorder()
	h.ExportCashClosingXLSX(rec, httptest.NewRequest(http.MethodGet, "/admin/reports/cash-closing.xlsx?date_from=13/10/2026&token="+token, nil))
	if rec.Code != http.StatusBadRequest {
		t.Fatalf("bad date status = %d, want 400", rec.Code)
	}
	rec = httptest.NewRecorder()
	h.ExportCashClosingXLSX(rec, httptest.NewRequest(http.MethodGet, "/admin/reports/cash-closing.xlsx", nil))
	if rec.Code != http.StatusUnauthorized {
		t.Fatalf("no token status = %d, want 401", rec.Code)
	}
	rec = httptest.NewRecorder()
	h.ExportCashClosingXLSX(rec, httptest.NewRequest(http.MethodGet, "/admin/reports/cash-closing.xlsx?date_from=2026-10-13&token="+token, nil))
	if rec.Code != http.StatusOK {
		t.Fatalf("status = %d", rec.Code)
	}
}

func TestExportRemittanceXLSXUsesPaymentDates(t *testing.T) {
	h, gen, token, repo := newExportHandlerWithRepo(t)
	rec := httptest.NewRecorder()
	h.ExportRemittanceXLSX(rec, httptest.NewRequest(http.MethodGet,
		"/admin/reports/remittance.xlsx?date_from=2026-09-01&date_to=2026-09-07&collected_by=caja1&token="+token, nil))
	if rec.Code != http.StatusOK {
		t.Fatalf("status = %d: %s", rec.Code, rec.Body.String())
	}
	seen := repo.paymentSeen
	if got := seen.PaidFrom.In(limaZone).Format(time.DateTime); got != "2026-09-01 00:00:00" {
		t.Fatalf("PaidFrom = %s, want the start of Sep 1 in Lima", got)
	}
	if got := seen.PaidTo.In(limaZone).Format(time.DateTime); got != "2026-09-08 00:00:00" {
		t.Fatalf("PaidTo = %s, want the end of Sep 7 (exclusive) in Lima", got)
	}
	if seen.CollectedBy != "caja1" || seen.FromPeriod != "" || seen.ToPeriod != "" {
		t.Fatalf("filter = %+v, want collector and no billing periods", seen)
	}
	if gen.remittance.From.Format(time.DateOnly) != "2026-09-01" || gen.remittance.To.Format(time.DateOnly) != "2026-09-07" {
		t.Fatalf("workbook range = %v..%v, want inclusive Sep 1..7", gen.remittance.From, gen.remittance.To)
	}
	if gen.meta.Title != "Rendición semanal de cobranza" || gen.meta.Filters[0][1] != "01/09/2026" || gen.meta.Filters[1][1] != "07/09/2026" {
		t.Fatalf("meta = %+v", gen.meta)
	}
}

func TestExportRemittanceXLSXScopesCollectorsToThemselves(t *testing.T) {
	h, _, _, repo := newExportHandlerWithRepo(t)
	token, _ := h.jwtService.GenerateToken(&domain.User{ID: "cobrador-1", Email: "c1@chetilla.gob.pe", Role: domain.RoleReader})
	rec := httptest.NewRecorder()
	h.ExportRemittanceXLSX(rec, httptest.NewRequest(http.MethodGet,
		"/admin/reports/remittance.xlsx?date_from=2026-09-01&collected_by=otro&token="+token, nil))
	if rec.Code != http.StatusOK {
		t.Fatalf("status = %d: %s", rec.Code, rec.Body.String())
	}
	if repo.paymentSeen.CollectedBy != "cobrador-1" {
		t.Fatalf("a collector may only export their own payments, got %q", repo.paymentSeen.CollectedBy)
	}

	rec = httptest.NewRecorder()
	h.ExportRemittanceXLSX(rec, httptest.NewRequest(http.MethodGet, "/admin/reports/remittance.xlsx?date_from=01/09/2026&token="+token, nil))
	if rec.Code != http.StatusBadRequest {
		t.Fatalf("bad date status = %d, want 400", rec.Code)
	}
}
