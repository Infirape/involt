package repositories

import (
	"context"
	"fmt"
	"strings"

	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

type PostgresCustomerStatusRepository struct {
	db *sqlx.DB
}

func NewPostgresCustomerStatusRepository(db *sqlx.DB) *PostgresCustomerStatusRepository {
	return &PostgresCustomerStatusRepository{db: db}
}

func (r *PostgresCustomerStatusRepository) SetStatus(ctx context.Context, customerID string, to domain.ServiceStatus, reason, changedBy, changedByEmail string) (*domain.ServiceStatusChange, error) {
	tx, err := r.db.BeginTxx(ctx, nil)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	var current string
	err = tx.GetContext(ctx, &current, `SELECT service_status FROM customers
		WHERE id = $1 AND deleted_at IS NULL FOR UPDATE`, customerID)
	if err != nil {
		return nil, fmt.Errorf("error loading customer status: %w", err)
	}
	if err := domain.ValidateServiceStatusChange(domain.ServiceStatus(current), to, reason); err != nil {
		return nil, err
	}

	change := &domain.ServiceStatusChange{
		ID: uuid.New().String(), CustomerID: customerID, PreviousStatus: current, Status: string(to),
		Reason: strings.TrimSpace(reason), ChangedBy: changedBy, ChangedByEmail: changedByEmail,
	}
	err = tx.QueryRowxContext(ctx, `INSERT INTO customer_status_changes
		(id, customer_id, previous_status, status, reason, changed_by, changed_by_email)
		VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING changed_at`,
		change.ID, change.CustomerID, change.PreviousStatus, change.Status, change.Reason, change.ChangedBy, change.ChangedByEmail,
	).Scan(&change.ChangedAt)
	if err != nil {
		return nil, fmt.Errorf("error recording status change: %w", err)
	}
	if _, err := tx.ExecContext(ctx, `UPDATE customers SET service_status = $2, service_status_changed_at = $3 WHERE id = $1`,
		customerID, change.Status, change.ChangedAt); err != nil {
		return nil, fmt.Errorf("error updating customer status: %w", err)
	}
	return change, tx.Commit()
}

func (r *PostgresCustomerStatusRepository) History(ctx context.Context, customerID string) ([]domain.ServiceStatusChange, error) {
	history := []domain.ServiceStatusChange{}
	err := r.db.SelectContext(ctx, &history, `SELECT id, customer_id, previous_status, status, reason,
		changed_by, changed_by_email, changed_at FROM customer_status_changes
		WHERE customer_id = $1 ORDER BY changed_at DESC`, customerID)
	if err != nil {
		return nil, fmt.Errorf("error loading status history: %w", err)
	}
	return history, nil
}

func (r *PostgresCustomerStatusRepository) CountByStatus(ctx context.Context, filter ports.ReceiptLineFilter) (map[domain.ServiceStatus]int, error) {
	var args []any
	conds := customerScope(filter, &args)
	var rows []struct {
		Status string `db:"service_status"`
		Count  int    `db:"count"`
	}
	query := `SELECT c.service_status, COUNT(*) AS count FROM customers c WHERE ` +
		strings.Join(conds, " AND ") + ` GROUP BY c.service_status`
	if err := r.db.SelectContext(ctx, &rows, query, args...); err != nil {
		return nil, fmt.Errorf("error counting customers by status: %w", err)
	}
	counts := map[domain.ServiceStatus]int{}
	for _, row := range rows {
		counts[domain.ServiceStatus(row.Status)] += row.Count
	}
	return counts, nil
}
