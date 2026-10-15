package handlers

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

type workbookStub struct {
	meta    ports.WorkbookMeta
	debtors *involtv1.GetDebtorsResponse
	data    ports.CollectionsWorkbookData
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
