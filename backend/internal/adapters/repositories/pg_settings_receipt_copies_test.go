package repositories

import (
	"context"
	"testing"

	"github.com/infira/involt/backend/internal/domain"
)

func TestSettingsPersistReceiptCopies(t *testing.T) {
	db := openPaymentsTestDB(t)
	ctx := context.Background()
	meta := NewPostgresMetadataRepository(db)
	rest := NewSettingsRepository(db)

	if err := meta.SaveSettings(ctx, &domain.Settings{Municipalidad: "MD", Empresa: "QM", ReceiptCopies: domain.ReceiptCopiesSingle}); err != nil {
		t.Fatalf("SaveSettings: %v", err)
	}
	got, err := meta.GetSettings(ctx)
	if err != nil || got.ReceiptCopies != domain.ReceiptCopiesSingle {
		t.Fatalf("GetSettings = %+v, %v", got, err)
	}

	if err := rest.Upsert(ctx, &domain.Settings{Municipalidad: "MD", Empresa: "QM", ReceiptCopies: "garbage"}); err != nil {
		t.Fatalf("Upsert: %v", err)
	}
	got, _ = rest.Get(ctx)
	if got.ReceiptCopies != domain.ReceiptCopiesDuplicate {
		t.Fatalf("unknown modes must be stored as DUPLICATE, got %q", got.ReceiptCopies)
	}
}
