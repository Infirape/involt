package handlers

import (
	"context"
	"fmt"
	"math"
	"sort"
	"time"

	"connectrpc.com/connect"

	"github.com/infira/involt/backend/internal/adapters/auth"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

// GetCashClosing summarizes the payments collected between two Lima calendar days (inclusive).
// Users without manager role only see what they collected themselves.
func (h *AdminHandler) GetCashClosing(
	ctx context.Context,
	req *connect.Request[involtv1.GetCashClosingRequest],
) (*connect.Response[involtv1.GetCashClosingResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("authentication required"))
	}

	from, to, err := h.parseClosingRange(req.Msg.DateFrom, req.Msg.DateTo)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	collector := req.Msg.CollectedBy
	if !canManagePayments(user) {
		collector = user.ID
	}

	payments, err := h.paymentRepo.List(ctx, ports.PaymentFilter{
		CollectedBy: collector, From: from, To: to, IncludeVoided: true,
	})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &involtv1.GetCashClosingResponse{}
	methodTotals := map[involtv1.PaymentMethod]*involtv1.MethodTotal{}
	collectorTotals := map[string]*involtv1.CollectorTotal{}
	var totalCents, voidedCents int64

	for i := range payments {
		p := &payments[i]
		resp.Payments = append(resp.Payments, mapPaymentToProto(p))
		cents := int64(math.Round(p.Amount * 100))
		if p.IsVoided() {
			voidedCents += cents
			resp.VoidedCount++
			continue
		}
		totalCents += cents
		resp.PaymentCount++

		method := paymentMethodToProto(p.Method)
		mt, ok := methodTotals[method]
		if !ok {
			mt = &involtv1.MethodTotal{Method: method}
			methodTotals[method] = mt
		}
		mt.Amount = roundCents(mt.Amount + p.Amount)
		mt.Count++

		ct, ok := collectorTotals[p.CollectedBy]
		if !ok {
			ct = &involtv1.CollectorTotal{CollectedBy: p.CollectedBy, CollectedByEmail: p.CollectedByEmail}
			collectorTotals[p.CollectedBy] = ct
		}
		ct.Amount = roundCents(ct.Amount + p.Amount)
		ct.Count++
	}

	resp.TotalAmount = float64(totalCents) / 100
	resp.VoidedAmount = float64(voidedCents) / 100
	for _, mt := range methodTotals {
		resp.ByMethod = append(resp.ByMethod, mt)
	}
	sort.Slice(resp.ByMethod, func(i, j int) bool { return resp.ByMethod[i].Method < resp.ByMethod[j].Method })
	for _, ct := range collectorTotals {
		resp.ByCollector = append(resp.ByCollector, ct)
	}
	sort.Slice(resp.ByCollector, func(i, j int) bool { return resp.ByCollector[i].Amount > resp.ByCollector[j].Amount })

	return connect.NewResponse(resp), nil
}

// parseClosingRange turns inclusive YYYY-MM-DD Lima dates into a half-open [from, to) instant range.
// Empty dates default to today.
func (h *AdminHandler) parseClosingRange(rawFrom, rawTo string) (time.Time, time.Time, error) {
	today := h.now().Format("2006-01-02")
	if rawFrom == "" {
		rawFrom = today
	}
	if rawTo == "" {
		rawTo = rawFrom
	}
	from, err := time.ParseInLocation("2006-01-02", rawFrom, limaZone)
	if err != nil {
		return time.Time{}, time.Time{}, fmt.Errorf("invalid date_from %q, expected YYYY-MM-DD", rawFrom)
	}
	to, err := time.ParseInLocation("2006-01-02", rawTo, limaZone)
	if err != nil {
		return time.Time{}, time.Time{}, fmt.Errorf("invalid date_to %q, expected YYYY-MM-DD", rawTo)
	}
	if to.Before(from) {
		return time.Time{}, time.Time{}, fmt.Errorf("date_to must not be before date_from")
	}
	return from, to.AddDate(0, 0, 1), nil
}

func roundCents(v float64) float64 {
	return math.Round(v*100) / 100
}
