package excel

import (
	"context"
	"strings"
	"testing"

	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

func TestCashClosingWorkbook(t *testing.T) {
	report := &involtv1.GetCashClosingResponse{
		Payments: []*involtv1.Payment{
			{ReceiptNumber: 1, CustomerCode: "CHE001", CustomerName: "Ana", Amount: 10, Method: involtv1.PaymentMethod_PAYMENT_METHOD_CASH,
				CollectedByEmail: "caja1@chetilla.gob.pe", PaidAt: "2026-10-13T15:00:00Z",
				Allocations: []*involtv1.PaymentAllocation{{Period: "2026-08", Amount: 9, LateFee: 1}}},
			{ReceiptNumber: 2, CustomerCode: "CHE002", CustomerName: "Beto", Amount: 5, Method: involtv1.PaymentMethod_PAYMENT_METHOD_YAPE,
				Reference: "OP-1", CollectedByEmail: "caja2@chetilla.gob.pe", PaidAt: "2026-10-13T16:00:00Z", Voided: true, VoidReason: "Duplicado"},
		},
		TotalAmount: 10, PaymentCount: 1, VoidedAmount: 5, VoidedCount: 1,
		ByMethod:    []*involtv1.MethodTotal{{Method: involtv1.PaymentMethod_PAYMENT_METHOD_CASH, Amount: 10, Count: 1}},
		ByCollector: []*involtv1.CollectorTotal{{CollectedByEmail: "caja1@chetilla.gob.pe", Amount: 10, Count: 1}},
	}
	data, err := NewGenerator().CashClosingWorkbook(context.Background(), report, testMeta("Cierre de caja"))
	if err != nil {
		t.Fatalf("CashClosingWorkbook: %v", err)
	}
	f, charts := openWorkbook(t, data)
	if got := strings.Join(f.GetSheetList(), ","); got != "Resumen,Pagos,Dinamica" {
		t.Fatalf("sheets = %s", got)
	}
	rows, _ := f.GetRows("Pagos")
	if len(rows) != 3 || rows[1][6] != "Efectivo" || rows[1][10] != "S/ 1.00" {
		t.Fatalf("payment rows = %v", rows)
	}
	if rows[2][11] != "S/ 0.00" || rows[2][12] != "Anulado" {
		t.Fatalf("voided payments must not count as valid amount: %v", rows[2])
	}
	if pivots, _ := f.GetPivotTables("Dinamica"); len(pivots) != 2 {
		t.Fatalf("pivots = %d, want 2", len(pivots))
	}
	if len(charts) != 2 {
		t.Fatalf("charts = %v, want 2", charts)
	}
}
