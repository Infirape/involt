package handlers

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"connectrpc.com/connect"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

const xlsxContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

// ExportDebtorsXLSX serves /admin/reports/debtors.xlsx with the same filters as GetDebtors.
func (h *AdminHandler) ExportDebtorsXLSX(w http.ResponseWriter, r *http.Request) {
	ctx, user, ok := h.exportContext(w, r)
	if !ok {
		return
	}
	q := r.URL.Query()
	req := &involtv1.GetDebtorsRequest{
		CommunityId: q.Get("community_id"), SectorId: q.Get("sector_id"), Search: q.Get("search"),
		MinOverdueReceipts: int32(queryInt(q.Get("min_overdue_receipts"))), MinDebt: queryFloat(q.Get("min_debt")),
		CutThreshold: int32(queryInt(q.Get("cut_threshold"))), OnlyCutCandidates: q.Get("only_cut_candidates") == "true",
	}
	resp, err := h.GetDebtors(ctx, connect.NewRequest(req))
	if err != nil {
		writeRPCError(w, err)
		return
	}
	meta := h.workbookMeta(ctx, user, "Reporte de morosos", [][2]string{
		{"Comunidad", h.communityName(ctx, req.CommunityId)}, {"Caserío", h.sectorName(ctx, req.SectorId)},
		{"Búsqueda", orAll(req.Search)}, {"Corte desde", fmt.Sprintf("%d recibos vencidos", cutThresholdOrDefault(req.CutThreshold))},
	})
	data, err := h.workbookGen.DebtorsWorkbook(ctx, resp.Msg, meta)
	writeWorkbook(w, "morosos", data, err)
}

// ExportCashClosingXLSX serves /admin/reports/cash-closing.xlsx (cierre de caja).
func (h *AdminHandler) ExportCashClosingXLSX(w http.ResponseWriter, r *http.Request) {
	ctx, user, ok := h.exportContext(w, r)
	if !ok {
		return
	}
	q := r.URL.Query()
	req := &involtv1.GetCashClosingRequest{DateFrom: q.Get("date_from"), DateTo: q.Get("date_to"), CollectedBy: q.Get("collected_by")}
	resp, err := h.GetCashClosing(ctx, connect.NewRequest(req))
	if err != nil {
		writeRPCError(w, err)
		return
	}
	from, to, _ := h.parseClosingRange(req.DateFrom, req.DateTo)
	meta := h.workbookMeta(ctx, user, "Cierre de caja", [][2]string{
		{"Desde", from.Format("02/01/2006")}, {"Hasta", to.AddDate(0, 0, -1).Format("02/01/2006")},
	})
	data, err := h.workbookGen.CashClosingWorkbook(ctx, resp.Msg, meta)
	writeWorkbook(w, "cierre_caja_"+from.Format("2006-01-02"), data, err)
}

// ExportCollectionsXLSX serves /admin/reports/collections.xlsx (resumen de cobranza).
func (h *AdminHandler) ExportCollectionsXLSX(w http.ResponseWriter, r *http.Request) {
	ctx, user, ok := h.exportContext(w, r)
	if !ok {
		return
	}
	q := r.URL.Query()
	req := &involtv1.GetCollectionsDashboardRequest{
		FromPeriod: q.Get("from_period"), ToPeriod: q.Get("to_period"),
		CommunityId: q.Get("community_id"), SectorId: q.Get("sector_id"),
	}
	resp, err := h.GetCollectionsDashboard(ctx, connect.NewRequest(req))
	if err != nil {
		writeRPCError(w, err)
		return
	}
	filter := reportScope(user)
	filter.CommunityID, filter.SectorID = req.CommunityId, req.SectorId
	filter.FromPeriod, filter.ToPeriod = resp.Msg.FromPeriod, resp.Msg.ToPeriod
	data := ports.CollectionsWorkbookData{Report: resp.Msg}
	if data.Receipts, err = h.reportRepo.ListReceiptLines(ctx, filter); err == nil {
		if data.Customers, err = h.reportRepo.ListCustomers(ctx, filter); err == nil {
			data.Payments, err = h.reportRepo.ListPaymentLines(ctx, filter)
		}
	}
	if err != nil {
		log.Printf("⚠️ Error loading collections workbook data: %v", err)
		http.Error(w, "Error loading report data", http.StatusInternalServerError)
		return
	}
	meta := h.workbookMeta(ctx, user, "Resumen de cobranza", [][2]string{
		{"Periodo", fmt.Sprintf("%s a %s", resp.Msg.FromPeriod, resp.Msg.ToPeriod)},
		{"Comunidad", h.communityName(ctx, req.CommunityId)}, {"Caserío", h.sectorName(ctx, req.SectorId)},
	})
	workbook, err := h.workbookGen.CollectionsWorkbook(ctx, data, meta)
	writeWorkbook(w, "resumen_cobranza", workbook, err)
}

// exportContext authenticates the download and puts the user in the context so the RPC
// handlers apply the same permission rules.
func (h *AdminHandler) exportContext(w http.ResponseWriter, r *http.Request) (context.Context, *auth.UserContext, bool) {
	user, ok := h.documentUser(w, r)
	if !ok {
		return nil, nil, false
	}
	return context.WithValue(r.Context(), auth.UserContextKey, user), user, true
}

func (h *AdminHandler) workbookMeta(ctx context.Context, user *auth.UserContext, title string, filters [][2]string) ports.WorkbookMeta {
	settings, _ := h.metaRepo.GetSettings(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}
	return ports.WorkbookMeta{
		Entity: settings.Municipalidad, Company: settings.Empresa, Title: title,
		Filters: filters, GeneratedAt: h.now(), GeneratedBy: user.Email,
	}
}

func (h *AdminHandler) communityName(ctx context.Context, id string) string {
	if id == "" {
		return "Todas"
	}
	communities, _ := h.metaRepo.ListCommunities(ctx)
	for _, c := range communities {
		if c.ID == id {
			return c.Name
		}
	}
	return id
}

func (h *AdminHandler) sectorName(ctx context.Context, id string) string {
	if id == "" {
		return "Todos"
	}
	sectors, _ := h.metaRepo.ListSectors(ctx)
	for _, s := range sectors {
		if s.ID == id {
			return s.Name
		}
	}
	return id
}

func orAll(v string) string {
	if v == "" {
		return "—"
	}
	return v
}

func queryInt(raw string) int {
	v, _ := strconv.Atoi(raw)
	return v
}

func queryFloat(raw string) float64 {
	v, _ := strconv.ParseFloat(raw, 64)
	return v
}

func writeRPCError(w http.ResponseWriter, err error) {
	status := http.StatusInternalServerError
	switch connect.CodeOf(err) {
	case connect.CodeInvalidArgument:
		status = http.StatusBadRequest
	case connect.CodePermissionDenied:
		status = http.StatusForbidden
	case connect.CodeNotFound:
		status = http.StatusNotFound
	}
	http.Error(w, err.Error(), status)
}

func writeWorkbook(w http.ResponseWriter, name string, data []byte, err error) {
	if err != nil {
		log.Printf("⚠️ Error generating workbook %s: %v", name, err)
		http.Error(w, "Error generating Excel", http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", xlsxContentType)
	w.Header().Set("Content-Disposition", fmt.Sprintf(`attachment; filename="%s.xlsx"`, name))
	_, _ = w.Write(data)
}
