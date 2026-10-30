package pdf

import (
	"context"
	"testing"
	"time"

	"github.com/infira/involt/backend/internal/domain"
)

func generateReceiptWith(t *testing.T, copies string) []byte {
	t.Helper()
	customer := &domain.Customer{ID: "c1", Code: "TAMA020", Name: "TANTA CUEVA JOSE", Address: "TAMBILLO"}
	reading := &domain.Reading{
		ID: "r1", CustomerID: "c1", Consumption: 3, Period: "2026-09", TotalToPay: 7.5, CargoFijo: 6,
		Timestamp: time.Date(2026, 9, 8, 0, 0, 0, 0, time.UTC), PeriodStart: time.Date(2026, 9, 1, 0, 0, 0, 0, time.UTC),
		PeriodEnd: time.Date(2026, 9, 30, 0, 0, 0, 0, time.UTC),
	}
	settings := &domain.Settings{Municipalidad: "MD CHETILLA", Empresa: "QARWAQIRU", DiasVencimiento: 15, ReceiptCopies: copies}
	data, err := NewMarotoGenerator().Generate(context.Background(), reading, customer, settings, "Chetilla", "TAMBILLO", nil)
	if err != nil {
		t.Fatalf("Generate(%s): %v", copies, err)
	}
	return data
}

func TestReceiptSingleModeOmitsAdministrativeCopy(t *testing.T) {
	single := generateReceiptWith(t, domain.ReceiptCopiesSingle)
	duplicate := generateReceiptWith(t, domain.ReceiptCopiesDuplicate)
	if len(single) == 0 || len(single) >= len(duplicate) {
		t.Fatalf("single receipt (%d bytes) should be smaller than the duplicate one (%d bytes)", len(single), len(duplicate))
	}
}
