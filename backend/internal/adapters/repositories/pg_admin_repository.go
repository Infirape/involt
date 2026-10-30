package repositories

import (
	"context"
	"fmt"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/jmoiron/sqlx"
	"github.com/lib/pq"
)

type PostgresAdminRepository struct {
	db *sqlx.DB
}

func NewPostgresAdminRepository(db *sqlx.DB) *PostgresAdminRepository {
	return &PostgresAdminRepository{db: db}
}

func (r *PostgresAdminRepository) GetUserByEmail(ctx context.Context, email string) (*domain.User, error) {
	var user domain.User
	query := `SELECT id, email, password_hash, role, COALESCE(company_id, '') AS company_id, created_at, updated_at FROM users WHERE email = $1`
	err := r.db.GetContext(ctx, &user, query, email)
	if err != nil {
		return nil, fmt.Errorf("error getting user by email: %w", err)
	}

	// Fetch assigned sectors
	var sectors []string
	querySectors := `SELECT sector_id FROM user_sectors WHERE user_id = $1`
	err = r.db.SelectContext(ctx, &sectors, querySectors, user.ID)
	if err != nil {
		return nil, fmt.Errorf("error getting user sectors: %w", err)
	}
	user.AssignedSectorIDs = sectors

	if err := r.loadCompany(ctx, &user); err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *PostgresAdminRepository) GetUserByID(ctx context.Context, id string) (*domain.User, error) {
	var user domain.User
	query := `SELECT id, email, password_hash, role, COALESCE(company_id, '') AS company_id, created_at, updated_at FROM users WHERE id = $1`
	err := r.db.GetContext(ctx, &user, query, id)
	if err != nil {
		return nil, fmt.Errorf("error getting user by id: %w", err)
	}

	var sectors []string
	querySectors := `SELECT sector_id FROM user_sectors WHERE user_id = $1`
	err = r.db.SelectContext(ctx, &sectors, querySectors, user.ID)
	if err != nil {
		return nil, fmt.Errorf("error getting user sectors: %w", err)
	}
	user.AssignedSectorIDs = sectors

	if err := r.loadCompany(ctx, &user); err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *PostgresAdminRepository) ListUsers(ctx context.Context) ([]domain.User, error) {
	var users []domain.User
	query := `SELECT id, email, password_hash, role, COALESCE(company_id, '') AS company_id, created_at, updated_at FROM users ORDER BY email ASC`
	err := r.db.SelectContext(ctx, &users, query)
	if err != nil {
		return nil, fmt.Errorf("error listing users: %w", err)
	}

	// In a real app we might want to batch this, but for now we'll just populate sectors for each
	for i := range users {
		var sectors []string
		querySectors := `SELECT sector_id FROM user_sectors WHERE user_id = $1`
		r.db.SelectContext(ctx, &sectors, querySectors, users[i].ID)
		users[i].AssignedSectorIDs = sectors
	}

	return users, nil
}

func (r *PostgresAdminRepository) UpsertUser(ctx context.Context, user *domain.User) error {
	tx, err := r.db.BeginTxx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	query := `INSERT INTO users (id, email, password_hash, role, company_id, updated_at)
			  VALUES (:id, :email, :password_hash, :role, NULLIF(:company_id, ''), NOW())
			  ON CONFLICT (id) DO UPDATE SET
			  email = EXCLUDED.email,
			  password_hash = EXCLUDED.password_hash,
			  role = EXCLUDED.role,
			  company_id = COALESCE(EXCLUDED.company_id, users.company_id),
			  updated_at = NOW()
			  RETURNING id`
	
	// NamedExec doesn't support RETURNING directly with Get, so we use a trick or just exec
	_, err = tx.NamedExecContext(ctx, query, user)
	if err != nil {
		return fmt.Errorf("error upserting user: %w", err)
	}

	// Update sectors
	_, err = tx.ExecContext(ctx, `DELETE FROM user_sectors WHERE user_id = $1`, user.ID)
	if err != nil {
		return err
	}

	if len(user.AssignedSectorIDs) > 0 {
		querySectors := `INSERT INTO user_sectors (user_id, sector_id) 
						 SELECT $1, unnest($2::text[])`
		_, err = tx.ExecContext(ctx, querySectors, user.ID, pq.Array(user.AssignedSectorIDs))
		if err != nil {
			return fmt.Errorf("error updating user sectors: %w", err)
		}
	}

	return tx.Commit()
}

// loadCompany attaches the user's company, if any.
func (r *PostgresAdminRepository) loadCompany(ctx context.Context, user *domain.User) error {
	if user.CompanyID == "" {
		return nil
	}
	company, err := NewPostgresCompanyRepository(r.db).GetByID(ctx, user.CompanyID)
	if err != nil {
		return fmt.Errorf("error getting user company: %w", err)
	}
	user.Company = company
	return nil
}
