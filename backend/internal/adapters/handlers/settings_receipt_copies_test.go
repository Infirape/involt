package handlers

import (
	"context"
	"testing"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// savingMetaStub remembers the settings saved through the admin RPC.
type savingMetaStub struct {
	settingsMetaStub
	saved *domain.Settings
}

func (s *savingMetaStub) SaveSettings(_ context.Context, st *domain.Settings) error {
	s.saved = st
	s.settings = st
	return nil
}

func TestSettingsRPCsCarryReceiptCopies(t *testing.T) {
	meta := &savingMetaStub{settingsMetaStub: settingsMetaStub{settings: &domain.Settings{ReceiptCopies: "SINGLE"}}}
	h := &AdminHandler{metaRepo: meta}
	admin := contextWithUser("admin", "ADMIN")

	got, err := h.GetSettings(admin, connect.NewRequest(&involtv1.GetSettingsRequest{}))
	if err != nil || got.Msg.GetSettings().GetReceiptCopies() != involtv1.ReceiptCopies_RECEIPT_COPIES_SINGLE {
		t.Fatalf("GetSettings = %+v, %v", got, err)
	}

	_, err = h.UpdateSettings(admin, connect.NewRequest(&involtv1.UpdateSettingsRequest{Settings: &involtv1.Settings{
		Municipalidad: "MD", ReceiptCopies: involtv1.ReceiptCopies_RECEIPT_COPIES_DUPLICATE,
	}}))
	if err != nil || meta.saved.ReceiptCopies != domain.ReceiptCopiesDuplicate {
		t.Fatalf("UpdateSettings saved %+v, %v", meta.saved, err)
	}

	_, _ = h.UpdateSettings(admin, connect.NewRequest(&involtv1.UpdateSettingsRequest{Settings: &involtv1.Settings{Municipalidad: "MD"}}))
	if meta.saved.ReceiptCopies != domain.ReceiptCopiesDuplicate {
		t.Fatalf("unspecified must default to DUPLICATE, got %q", meta.saved.ReceiptCopies)
	}
	meta.settings = &domain.Settings{}
	got, _ = h.GetSettings(admin, connect.NewRequest(&involtv1.GetSettingsRequest{}))
	if got.Msg.GetSettings().GetReceiptCopies() != involtv1.ReceiptCopies_RECEIPT_COPIES_DUPLICATE {
		t.Fatalf("empty stored value must read as DUPLICATE, got %v", got.Msg.GetSettings().GetReceiptCopies())
	}
}
