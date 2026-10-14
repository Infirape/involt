package pdf

import (
	"bytes"
	"context"
	"testing"
	"time"

	"github.com/infira/involt/backend/internal/domain"
)

func voucherFixture() (*domain.Payment, *domain.Customer, *domain.Settings) {
	payment := &domain.Payment{
		ID: "pay-1", ReceiptNumber: 42, CustomerID: "cust-1", Amount: 22.5, Method: "YAPE",
		Reference: "OP-778899", Observation: "Pago adelantado", CollectedByEmail: "caja@chetilla.gob.pe",
		PaidAt: time.Date(2026, 10, 13, 15, 30, 0, 0, time.UTC),
		Allocations: []domain.PaymentAllocation{
			{ReadingID: "r-1", Period: "2026-08", Amount: 10},
			{ReadingID: "r-2", Period: "2026-09", Amount: 12.5},
		},
	}
	customer := &domain.Customer{ID: "cust-1", Code: "TAMA020", Name: "TANTA CUEVA JOSE SILVERIO", Address: "CASERIO TAMBILLO ALTO"}
	settings := &domain.Settings{Municipalidad: "MUNICIPALIDAD DISTRITAL DE CHETILLA", Empresa: "HIDROELECTRICA QARWAQIRU", RUC: "20123456789"}
	return payment, customer, settings
}

func TestGenerateVoucherProducesPDF(t *testing.T) {
	payment, customer, settings := voucherFixture()

	data, err := NewMarotoGenerator().GenerateVoucher(context.Background(), payment, customer, settings)
	if err != nil {
		t.Fatalf("GenerateVoucher: %v", err)
	}
	if !bytes.HasPrefix(data, []byte("%PDF")) || len(data) < 1000 {
		t.Fatalf("output does not look like a PDF (%d bytes)", len(data))
	}
}

func TestGenerateVoucherHandlesVoidedPayment(t *testing.T) {
	payment, customer, settings := voucherFixture()
	voidedAt := payment.PaidAt.Add(time.Hour)
	payment.VoidedAt = &voidedAt
	payment.VoidReason = "Cobro duplicado"

	if _, err := NewMarotoGenerator().GenerateVoucher(context.Background(), payment, customer, settings); err != nil {
		t.Fatalf("GenerateVoucher voided: %v", err)
	}
}

func TestPaymentMethodLabel(t *testing.T) {
	if got := paymentMethodLabel("TRANSFER"); got != "Transferencia" {
		t.Fatalf("label = %q", got)
	}
	if got := paymentMethodLabel("???"); got != "???" {
		t.Fatalf("unknown label = %q", got)
	}
}
