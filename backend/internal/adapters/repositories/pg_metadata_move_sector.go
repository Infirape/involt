package repositories

import (
	"context"
	"fmt"

	"github.com/infira/involt/backend/internal/domain"
)

// MoveSector moves a sector and its supplies to another community in one transaction: supplies
// keep their own community_id, which reports group by, so both must change together.
func (r *PostgresMetadataRepository) MoveSector(ctx context.Context, sectorID, communityID string) (int, error) {
	tx, err := r.db.BeginTxx(ctx, nil)
	if err != nil {
		return 0, err
	}
	defer func() { _ = tx.Rollback() }()

	var exists bool
	if err := tx.GetContext(ctx, &exists, `SELECT EXISTS (SELECT 1 FROM communities WHERE id = $1)`, communityID); err != nil {
		return 0, err
	}
	if !exists {
		return 0, domain.ErrCommunityNotFound
	}
	res, err := tx.ExecContext(ctx, `UPDATE sectors SET community_id = $2 WHERE id = $1`, sectorID, communityID)
	if err != nil {
		return 0, fmt.Errorf("error moving sector: %w", err)
	}
	if n, _ := res.RowsAffected(); n == 0 {
		return 0, domain.ErrSectorNotFound
	}
	res, err = tx.ExecContext(ctx, `UPDATE customers SET community_id = $2 WHERE sector_id = $1`, sectorID, communityID)
	if err != nil {
		return 0, fmt.Errorf("error moving the sector's supplies: %w", err)
	}
	moved, _ := res.RowsAffected()
	return int(moved), tx.Commit()
}
