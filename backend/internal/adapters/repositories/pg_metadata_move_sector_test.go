package repositories

import (
	"context"
	"errors"
	"testing"

	"github.com/infira/involt/backend/internal/domain"
)

func TestMoveSectorTakesItsSuppliesAlong(t *testing.T) {
	db := openPaymentsTestDB(t)
	db.MustExec(`INSERT INTO communities (id, name) VALUES ('com-2', 'Michay')`)
	repo := NewPostgresMetadataRepository(db)
	ctx := context.Background()

	moved, err := repo.MoveSector(ctx, "sec-1", "com-2")
	if err != nil || moved != 1 {
		t.Fatalf("MoveSector = %d, %v; want 1 supply moved", moved, err)
	}
	var sectorCommunity, customerCommunity string
	db.Get(&sectorCommunity, `SELECT community_id FROM sectors WHERE id = 'sec-1'`)
	db.Get(&customerCommunity, `SELECT community_id FROM customers WHERE id = 'cust-1'`)
	if sectorCommunity != "com-2" || customerCommunity != "com-2" {
		t.Fatalf("sector in %q, supply in %q; both must be in com-2 (reports group supplies by their community)",
			sectorCommunity, customerCommunity)
	}
}

func TestMoveSectorRejectsUnknownIDs(t *testing.T) {
	db := openPaymentsTestDB(t)
	repo := NewPostgresMetadataRepository(db)
	ctx := context.Background()

	if _, err := repo.MoveSector(ctx, "nope", "com-1"); !errors.Is(err, domain.ErrSectorNotFound) {
		t.Fatalf("unknown sector err = %v", err)
	}
	if _, err := repo.MoveSector(ctx, "sec-1", "nope"); !errors.Is(err, domain.ErrCommunityNotFound) {
		t.Fatalf("unknown community err = %v", err)
	}
	var community string
	db.Get(&community, `SELECT community_id FROM customers WHERE id = 'cust-1'`)
	if community != "com-1" {
		t.Fatalf("a rejected move must not touch supplies, got %q", community)
	}
}
