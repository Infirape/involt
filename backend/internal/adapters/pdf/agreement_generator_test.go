package pdf

import (
	"bytes"
	"context"
	"testing"
	"time"

	"github.com/infira/involt/backend/internal/domain"
)

func TestGenerateAgreementProducesPDF(t *testing.T) {
	inst, _ := domain.BuildInstallments(60.5, 10, 3, time.Date(2026, 11, 15, 0, 0, 0, 0, time.UTC))
	agreement := &domain.Agreement{
		ID: "ag-1", Number: 7, Total: 60.5, InitialAmount: 10, Notes: "Acordado en ventanilla",
		CreatedAt: time.Date(2026, 10, 13, 15, 0, 0, 0, time.UTC), CreatedByEmail: "caja@chetilla.gob.pe",
		Receipts: []domain.AgreementReceipt{
			{ReadingID: "r1", Period: "2026-06", Principal: 30, LateFee: 0.5},
			{ReadingID: "r2", Period: "2026-07", Principal: 30, LateFee: 0},
		},
		Installments: inst,
	}
	_, cust, settings := voucherFixture()

	data, err := NewMarotoGenerator().GenerateAgreement(context.Background(), agreement, cust, settings)
	if err != nil {
		t.Fatalf("GenerateAgreement: %v", err)
	}
	if !bytes.HasPrefix(data, []byte("%PDF")) || len(data) < 1000 {
		t.Fatalf("output does not look like a PDF (%d bytes)", len(data))
	}
}
