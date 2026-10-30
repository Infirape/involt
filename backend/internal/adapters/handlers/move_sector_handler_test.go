package handlers

import (
	"context"
	"testing"

	"connectrpc.com/connect"

	"github.com/infira/involt/backend/internal/adapters/repositories"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

func moveSector(h *AdminHandler, ctx context.Context, sectorID, communityID string) error {
	_, err := h.MoveSector(ctx, connect.NewRequest(&involtv1.MoveSectorRequest{SectorId: sectorID, CommunityId: communityID}))
	return err
}

func TestMoveSector(t *testing.T) {
	meta := repositories.NewMemMetadataRepository()
	_ = meta.SaveCommunities(context.Background(), []domain.Community{{ID: "com-2", Name: "Michay"}})
	h := &AdminHandler{metaRepo: meta}

	if err := moveSector(h, authenticatedTestContext(), "sec-1", "com-2"); err != nil {
		t.Fatalf("MoveSector: %v", err)
	}
	sectors, _ := meta.ListSectors(context.Background())
	for _, s := range sectors {
		if s.ID == "sec-1" && s.CommunityID != "com-2" {
			t.Fatalf("sector still in %q", s.CommunityID)
		}
	}

	cases := []struct {
		name                string
		ctx                 context.Context
		sectorID, community string
		code                connect.Code
	}{
		{"only admins", contextWithUser("sup", "SUPERVISOR"), "sec-1", "com-1", connect.CodePermissionDenied},
		{"sector required", authenticatedTestContext(), "", "com-1", connect.CodeInvalidArgument},
		{"community required", authenticatedTestContext(), "sec-1", "", connect.CodeInvalidArgument},
		{"unknown sector", authenticatedTestContext(), "nope", "com-1", connect.CodeNotFound},
		{"unknown community", authenticatedTestContext(), "sec-1", "nope", connect.CodeNotFound},
	}
	for _, c := range cases {
		if err := moveSector(h, c.ctx, c.sectorID, c.community); connect.CodeOf(err) != c.code {
			t.Fatalf("%s: err = %v, want %v", c.name, err, c.code)
		}
	}
}
