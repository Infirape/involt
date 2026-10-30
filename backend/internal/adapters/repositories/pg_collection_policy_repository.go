package repositories

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/jmoiron/sqlx"
)

type PostgresCollectionPolicyRepository struct {
	db *sqlx.DB
}

func NewPostgresCollectionPolicyRepository(db *sqlx.DB) *PostgresCollectionPolicyRepository {
	return &PostgresCollectionPolicyRepository{db: db}
}

type policyRow struct {
	LateFeeMode       string       `db:"late_fee_mode"`
	LateFeeValue      float64      `db:"late_fee_value"`
	LateFeeStartDate  sql.NullTime `db:"late_fee_start_date"`
	MaxInstallments   int          `db:"agreement_max_installments"`
	MinInitialPercent float64      `db:"agreement_min_initial_percent"`
	GraceDays         int          `db:"agreement_grace_days"`
	WaiveLateFees     bool         `db:"agreement_waive_late_fees"`
	UpdatedAt         time.Time    `db:"updated_at"`
	UpdatedBy         string       `db:"updated_by"`
}

func (r *PostgresCollectionPolicyRepository) Get(ctx context.Context) (*domain.CollectionPolicy, error) {
	var row policyRow
	query := `SELECT late_fee_mode, late_fee_value, late_fee_start_date, agreement_max_installments,
		agreement_min_initial_percent, agreement_grace_days, agreement_waive_late_fees, updated_at, updated_by
		FROM collection_policy WHERE id = 'main'`
	if err := r.db.GetContext(ctx, &row, query); err != nil {
		if err == sql.ErrNoRows {
			return &domain.CollectionPolicy{
				LateFee:   domain.LateFeePolicy{Mode: domain.LateFeeNone},
				Agreement: domain.AgreementPolicy{MaxInstallments: 12, GraceDays: 15, WaiveLateFees: true},
			}, nil
		}
		return nil, fmt.Errorf("error loading collection policy: %w", err)
	}
	p := &domain.CollectionPolicy{
		LateFee: domain.LateFeePolicy{Mode: domain.LateFeeMode(row.LateFeeMode), Value: row.LateFeeValue},
		Agreement: domain.AgreementPolicy{
			MaxInstallments: row.MaxInstallments, MinInitialPercent: row.MinInitialPercent,
			GraceDays: row.GraceDays, WaiveLateFees: row.WaiveLateFees,
		},
		UpdatedAt: row.UpdatedAt,
		UpdatedBy: row.UpdatedBy,
	}
	if row.LateFeeStartDate.Valid {
		d := row.LateFeeStartDate.Time
		p.LateFee.StartDate = time.Date(d.Year(), d.Month(), d.Day(), 0, 0, 0, 0, time.UTC)
	}
	return p, nil
}

func (r *PostgresCollectionPolicyRepository) Save(ctx context.Context, p *domain.CollectionPolicy) error {
	var start any
	if !p.LateFee.StartDate.IsZero() {
		start = p.LateFee.StartDate.Format("2006-01-02")
	}
	query := `INSERT INTO collection_policy (id, late_fee_mode, late_fee_value, late_fee_start_date,
			agreement_max_installments, agreement_min_initial_percent, agreement_grace_days,
			agreement_waive_late_fees, updated_at, updated_by)
		VALUES ('main', $1, $2, $3, $4, $5, $6, $7, NOW(), $8)
		ON CONFLICT (id) DO UPDATE SET
			late_fee_mode = $1, late_fee_value = $2, late_fee_start_date = $3,
			agreement_max_installments = $4, agreement_min_initial_percent = $5,
			agreement_grace_days = $6, agreement_waive_late_fees = $7,
			updated_at = NOW(), updated_by = $8`
	_, err := r.db.ExecContext(ctx, query,
		string(p.LateFee.Mode), p.LateFee.Value, start,
		p.Agreement.MaxInstallments, p.Agreement.MinInitialPercent, p.Agreement.GraceDays,
		p.Agreement.WaiveLateFees, p.UpdatedBy)
	if err != nil {
		return fmt.Errorf("error saving collection policy: %w", err)
	}
	return nil
}
