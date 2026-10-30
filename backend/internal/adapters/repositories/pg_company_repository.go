package repositories

import (
	"context"
	"fmt"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/jmoiron/sqlx"
)

type PostgresCompanyRepository struct {
	db *sqlx.DB
}

func NewPostgresCompanyRepository(db *sqlx.DB) *PostgresCompanyRepository {
	return &PostgresCompanyRepository{db: db}
}

func (r *PostgresCompanyRepository) GetByID(ctx context.Context, id string) (*domain.Company, error) {
	var c domain.Company
	query := `SELECT id, name, entity, logo, created_at, updated_at FROM companies WHERE id = $1`
	if err := r.db.GetContext(ctx, &c, query, id); err != nil {
		return nil, fmt.Errorf("error getting company: %w", err)
	}
	return &c, nil
}

// UpdateBrand renames a company; the logo is managed separately.
func (r *PostgresCompanyRepository) UpdateBrand(ctx context.Context, id, name, entity string) error {
	_, err := r.db.ExecContext(ctx,
		`UPDATE companies SET name = $2, entity = $3, updated_at = NOW() WHERE id = $1`, id, name, entity)
	if err != nil {
		return fmt.Errorf("error updating company: %w", err)
	}
	return nil
}
