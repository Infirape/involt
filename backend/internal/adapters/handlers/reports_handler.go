package handlers

import (
	"context"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

const (
	defaultCutThreshold = 2
	maxDashboardMonths  = 36
)

// GetCollectionsDashboard returns billed vs collected per sector and month for a period range,
// plus the aging of every outstanding balance (regardless of range).
func (h *AdminHandler) GetCollectionsDashboard(
	ctx context.Context,
	req *connect.Request[involtv1.GetCollectionsDashboardRequest],
) (*connect.Response[involtv1.GetCollectionsDashboardResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("authentication required"))
	}
	months, err := h.dashboardMonths(req.Msg.FromPeriod, req.Msg.ToPeriod)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	from, to := months[0], months[len(months)-1]

	scope := reportScope(user)
	scope.CommunityID = req.Msg.CommunityId
	inRange := scope
	inRange.FromPeriod, inRange.ToPeriod = from, to
	outstanding := scope
	outstanding.OnlyOutstanding = true

	lines, err := h.reportRepo.ListReceiptLines(ctx, inRange)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	debtLines, err := h.reportRepo.ListReceiptLines(ctx, outstanding)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	cash, err := h.reportRepo.CashInByMonth(ctx, inRange)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	today := h.now()
	resp := &involtv1.GetCollectionsDashboardResponse{FromPeriod: from, ToPeriod: to, Totals: &involtv1.CollectionsDashboardTotals{}}

	for _, s := range domain.SummarizeBySector(lines) {
		resp.BySector = append(resp.BySector, &involtv1.SectorCollectionSummary{
			SectorId: s.SectorID, SectorName: s.SectorName, CommunityId: s.CommunityID, CommunityName: s.CommunityName,
			Billed: s.Billed, Collected: s.Collected, Debt: s.Debt,
			Customers: int32(s.Customers), Debtors: int32(s.Debtors),
		})
		resp.Totals.Billed = roundCents(resp.Totals.Billed + s.Billed)
		resp.Totals.Collected = roundCents(resp.Totals.Collected + s.Collected)
	}

	byPeriod := map[string]domain.PeriodSummary{}
	for _, p := range domain.SummarizeByPeriod(lines) {
		byPeriod[p.Period] = p
	}
	for _, m := range months {
		p := byPeriod[m]
		resp.ByPeriod = append(resp.ByPeriod, &involtv1.PeriodCollectionSummary{
			Period: m, Billed: p.Billed, Collected: p.Collected, CashIn: roundCents(cash[m]),
		})
	}

	for _, a := range domain.BuildAging(debtLines, today) {
		resp.Aging = append(resp.Aging, &involtv1.AgingTotal{
			Bucket: agingBucketToProto(a.Bucket), Amount: a.Amount,
			Receipts: int32(a.Receipts), Customers: int32(a.Customers),
		})
	}

	threshold := cutThresholdOrDefault(req.Msg.CutThreshold)
	for _, d := range domain.BuildDebtors(debtLines, nil, today, threshold) {
		resp.Totals.TotalDebt = roundCents(resp.Totals.TotalDebt + d.TotalDebt)
		resp.Totals.OverdueDebt = roundCents(resp.Totals.OverdueDebt + d.OverdueDebt)
		resp.Totals.DebtorCount++
		if d.CutCandidate {
			resp.Totals.CutCandidates++
		}
	}
	return connect.NewResponse(resp), nil
}

// GetDebtors lists customers with outstanding balance, highest debt first.
func (h *AdminHandler) GetDebtors(
	ctx context.Context,
	req *connect.Request[involtv1.GetDebtorsRequest],
) (*connect.Response[involtv1.GetDebtorsResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("authentication required"))
	}
	filter := reportScope(user)
	filter.CommunityID = req.Msg.CommunityId
	filter.SectorID = req.Msg.SectorId
	filter.OnlyOutstanding = true

	lines, err := h.reportRepo.ListReceiptLines(ctx, filter)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	debtors := domain.BuildDebtors(lines, nil, h.now(), cutThresholdOrDefault(req.Msg.CutThreshold))

	search := strings.ToLower(strings.TrimSpace(req.Msg.Search))
	kept := make([]domain.Debtor, 0, len(debtors))
	for _, d := range debtors {
		switch {
		case search != "" && !strings.Contains(strings.ToLower(d.CustomerName), search) &&
			!strings.Contains(strings.ToLower(d.CustomerCode), search):
		case d.OverdueReceipts < int(req.Msg.MinOverdueReceipts):
		case d.TotalDebt < req.Msg.MinDebt:
		case req.Msg.OnlyCutCandidates && !d.CutCandidate:
		default:
			kept = append(kept, d)
		}
	}

	ids := make([]string, len(kept))
	for i, d := range kept {
		ids[i] = d.CustomerID
	}
	lastPayments, err := h.reportRepo.LastPaymentDates(ctx, ids)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &involtv1.GetDebtorsResponse{}
	for _, d := range kept {
		row := &involtv1.DebtorRow{
			CustomerId: d.CustomerID, CustomerCode: d.CustomerCode, CustomerName: d.CustomerName,
			SectorId: d.SectorID, SectorName: d.SectorName, CommunityName: d.CommunityName,
			TotalDebt: d.TotalDebt, OverdueDebt: d.OverdueDebt,
			PendingReceipts: int32(d.PendingReceipts), OverdueReceipts: int32(d.OverdueReceipts),
			OldestOverduePeriod: d.OldestOverduePeriod, DaysOverdue: int32(d.DaysOverdue),
			CutCandidate: d.CutCandidate,
		}
		if last, ok := lastPayments[d.CustomerID]; ok && !last.IsZero() {
			row.LastPaymentAt = last.Format(time.RFC3339)
		}
		resp.Debtors = append(resp.Debtors, row)
		resp.TotalDebt = roundCents(resp.TotalDebt + d.TotalDebt)
		resp.OverdueDebt = roundCents(resp.OverdueDebt + d.OverdueDebt)
		if d.CutCandidate {
			resp.CutCandidates++
		}
	}
	return connect.NewResponse(resp), nil
}

// reportScope restricts non-admin users to their assigned sectors.
func reportScope(user *auth.UserContext) ports.ReceiptLineFilter {
	if user.Role == string(domain.RoleAdmin) {
		return ports.ReceiptLineFilter{}
	}
	allowed := append([]string{}, user.AssignedSectorIDs...)
	return ports.ReceiptLineFilter{AllowedSectorIDs: allowed}
}

func cutThresholdOrDefault(v int32) int {
	if v <= 0 {
		return defaultCutThreshold
	}
	return int(v)
}

// dashboardMonths expands a YYYY-MM range (default: the 12 months ending this month).
func (h *AdminHandler) dashboardMonths(rawFrom, rawTo string) ([]string, error) {
	to := time.Date(h.now().Year(), h.now().Month(), 1, 0, 0, 0, 0, time.UTC)
	if rawTo != "" {
		t, err := time.Parse("2006-01", rawTo)
		if err != nil {
			return nil, fmt.Errorf("invalid to_period %q, expected YYYY-MM", rawTo)
		}
		to = t
	}
	from := to.AddDate(0, -11, 0)
	if rawFrom != "" {
		t, err := time.Parse("2006-01", rawFrom)
		if err != nil {
			return nil, fmt.Errorf("invalid from_period %q, expected YYYY-MM", rawFrom)
		}
		from = t
	}
	if from.After(to) {
		return nil, fmt.Errorf("from_period must not be after to_period")
	}
	var months []string
	for m := from; !m.After(to); m = m.AddDate(0, 1, 0) {
		months = append(months, m.Format("2006-01"))
		if len(months) > maxDashboardMonths {
			return nil, fmt.Errorf("range too long: at most %d months", maxDashboardMonths)
		}
	}
	return months, nil
}

func agingBucketToProto(b domain.AgingBucket) involtv1.AgingBucket {
	switch b {
	case domain.AgingCurrent:
		return involtv1.AgingBucket_AGING_BUCKET_CURRENT
	case domain.Aging1To30:
		return involtv1.AgingBucket_AGING_BUCKET_1_30
	case domain.Aging31To60:
		return involtv1.AgingBucket_AGING_BUCKET_31_60
	case domain.Aging61To90:
		return involtv1.AgingBucket_AGING_BUCKET_61_90
	case domain.AgingOver90:
		return involtv1.AgingBucket_AGING_BUCKET_OVER_90
	}
	return involtv1.AgingBucket_AGING_BUCKET_UNSPECIFIED
}
