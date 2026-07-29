package pdf

import (
	"context"
	"os"
	"testing"
	"time"

	"github.com/infira/involt/backend/internal/domain"
)

func TestMarotoGenerator_Generate(t *testing.T) {
	gen := NewMarotoGenerator()
	ctx := context.Background()

	customer := &domain.Customer{
		ID:             "CUST-001",
		Code:           "TAMA020",
		Name:           "TANTA CUEVA JOSE SILVERIO",
		CommunityName:  "Chetilla",
		SectorName:     "TAMBILLO A",
		Address:        "CASERIO TAMBILLO ALTO",
		ConnectionType: domain.ConnectionTypeMonofasica,
		Tariff:         0.2500,
		MeterNumber:    "10000001",
		ContractStart:  time.Date(2012, 8, 25, 0, 0, 0, 0, time.UTC),
	}

	reading := &domain.Reading{
		ID:               "READ-001",
		CustomerID:       "CUST-001",
		PreviousValue:    0.00,
		CurrentValue:     0.00,
		Consumption:      3,
		Timestamp:        time.Date(2026, 4, 8, 0, 0, 0, 0, time.UTC),
		PeriodStart:      time.Date(2026, 1, 20, 0, 0, 0, 0, time.UTC),
		PeriodEnd:        time.Date(2026, 2, 20, 0, 0, 0, 0, time.UTC),
		CargoFijo:        6.00,
		AlumbradoPublico: 0,
		Adjustment:       0.00,
		Subtotal:         6.00,
		SaldoRedondeo:    0.00,
		RoundDifference:  0,
		TotalToPay:       18.00,
		PreviousBalance:  0,
		OverdueTotal:     3.00,
		ExpirationDate:   time.Date(2026, 4, 25, 0, 0, 0, 0, time.UTC),
	}

	settings := &domain.Settings{
		TarifaKWh:     0.2500,
		Municipalidad: "MUNICIPALIDAD DISTRITAL DE CHETILLA",
		Empresa:       "HIDROELECTRICA QARWAQIRU MICHAY",
		Mantenimiento: 0.00,
	}

	history := []domain.Reading{
		{Period: "2025-12", Consumption: 15, IsPaid: true},
		{Period: "2026-01", Consumption: 22, IsPaid: true},
		{Period: "2026-02", Consumption: 18, IsPaid: false},
		{Period: "2026-03", Consumption: 30, IsPaid: true},
		{Period: "2026-04", Consumption: 25, IsPaid: true},
	}

	pdfData, err := gen.Generate(ctx, reading, customer, settings, "Chetilla", "TAMBILLO A", history)
	if err != nil {
		t.Fatalf("Failed to generate PDF: %v", err)
	}

	if len(pdfData) == 0 {
		t.Error("Generated PDF is empty")
	}

	// Save to file for manual inspection
	_ = os.WriteFile("test_receipt.pdf", pdfData, 0644)
}

func TestMarotoGenerator_GenerateBatch(t *testing.T) {
	gen := NewMarotoGenerator()
	ctx := context.Background()

	readings := []domain.Reading{
		{
			ID:         "R1",
			CustomerID: "C1",
			Timestamp:  time.Now(),
			TotalToPay: 10.5,
		},
	}

	customers := map[string]*domain.Customer{
		"C1": {Name: "Cliente Uno", Code: "C1", CommunityName: "Chetilla", SectorName: "Centro"},
	}

	settings := &domain.Settings{
		TarifaKWh:     0.2500,
		Municipalidad: "MUNICIPALIDAD DISTRITAL DE CHETILLA",
		Empresa:       "HIDROELECTRICA QARWAQIRU MICHAY",
		Mantenimiento: 0.00,
	}

	historyMap := map[string][]domain.Reading{
		"C1": {
			{Period: "2025-12", Consumption: 15, IsPaid: true},
			{Period: "2026-01", Consumption: 22, IsPaid: true},
			{Period: "2026-02", Consumption: 18, IsPaid: false},
		},
	}

	pdfData, err := gen.GenerateBatch(ctx, readings, customers, settings, historyMap)
	if err != nil {
		t.Fatalf("Failed to generate batch PDF: %v", err)
	}

	if len(pdfData) == 0 {
		t.Error("Generated batch PDF is empty")
	}
}
