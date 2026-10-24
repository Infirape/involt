package repositories

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
	"github.com/jmoiron/sqlx"
	"github.com/lib/pq"
)

type PostgresCollectionsReportRepository struct {
	db *sqlx.DB
}

func NewPostgresCollectionsReportRepository(db *sqlx.DB) *PostgresCollectionsReportRepository {
	return &PostgresCollectionsReportRepository{db: db}
}

// readingPeriodExpr derives YYYY-MM for legacy readings without an explicit period.
const readingPeriodExpr = `COALESCE(NULLIF(r.period, ''), to_char(r.period_start, 'YYYY-MM'))`

// customerScope builds WHERE conditions on customers (alias c) shared by all report queries.
func customerScope(filter ports.ReceiptLineFilter, args *[]any) []string {
	conds := []string{"c.deleted_at IS NULL"}
	add := func(cond string, arg any) {
		*args = append(*args, arg)
		conds = append(conds, fmt.Sprintf(cond, len(*args)))
	}
	if filter.AllowedSectorIDs != nil {
		add("c.sector_id = ANY($%d)", pq.Array(filter.AllowedSectorIDs))
	}
	if filter.SectorID != "" {
		add("c.sector_id = $%d", filter.SectorID)
	}
	if filter.CommunityID != "" {
		add("c.community_id = $%d", filter.CommunityID)
	}
	return conds
}

func (r *PostgresCollectionsReportRepository) ListReceiptLines(ctx context.Context, filter ports.ReceiptLineFilter) ([]domain.ReceiptLine, error) {
	var args []any
	conds := customerScope(filter, &args)
	if filter.FromPeriod != "" {
		args = append(args, filter.FromPeriod)
		conds = append(conds, fmt.Sprintf("%s >= $%d", readingPeriodExpr, len(args)))
	}
	if filter.ToPeriod != "" {
		args = append(args, filter.ToPeriod)
		conds = append(conds, fmt.Sprintf("%s <= $%d", readingPeriodExpr, len(args)))
	}
	if filter.OnlyOutstanding {
		conds = append(conds, "COALESCE(pd.paid, 0) + 0.005 < r.total_to_pay")
	}

	query := `SELECT r.id AS reading_id, c.id AS customer_id, c.code AS customer_code, c.name AS customer_name,
		COALESCE(c.sector_id, '') AS sector_id, COALESCE(s.name, '') AS sector_name,
		COALESCE(c.community_id, '') AS community_id, COALESCE(cm.name, '') AS community_name,
		COALESCE(` + readingPeriodExpr + `, '') AS period,
		r.total_to_pay AS total, COALESCE(pd.paid, 0) AS paid, r.expiration_date, c.service_status
		FROM readings r
		JOIN customers c ON c.id = r.customer_id
		LEFT JOIN sectors s ON s.id = c.sector_id
		LEFT JOIN communities cm ON cm.id = c.community_id
		LEFT JOIN (
			SELECT pa.reading_id, SUM(pa.amount) AS paid
			FROM payment_allocations pa JOIN payments p ON p.id = pa.payment_id
			WHERE p.voided_at IS NULL
			GROUP BY pa.reading_id
		) pd ON pd.reading_id = r.id
		WHERE ` + strings.Join(conds, " AND ")

	lines := []domain.ReceiptLine{}
	if err := r.db.SelectContext(ctx, &lines, query, args...); err != nil {
		return nil, fmt.Errorf("error listing receipt lines: %w", err)
	}
	return lines, nil
}

func (r *PostgresCollectionsReportRepository) LastPaymentDates(ctx context.Context, customerIDs []string) (map[string]time.Time, error) {
	result := make(map[string]time.Time, len(customerIDs))
	if len(customerIDs) == 0 {
		return result, nil
	}
	var rows []struct {
		CustomerID string    `db:"customer_id"`
		LastPaid   time.Time `db:"last_paid"`
	}
	query := `SELECT customer_id, MAX(paid_at) AS last_paid FROM payments
		WHERE voided_at IS NULL AND customer_id = ANY($1) GROUP BY customer_id`
	if err := r.db.SelectContext(ctx, &rows, query, pq.Array(customerIDs)); err != nil {
		return nil, fmt.Errorf("error loading last payment dates: %w", err)
	}
	for _, row := range rows {
		result[row.CustomerID] = row.LastPaid
	}
	return result, nil
}

func (r *PostgresCollectionsReportRepository) CashInByMonth(ctx context.Context, filter ports.ReceiptLineFilter) (map[string]float64, error) {
	const monthExpr = `to_char(p.paid_at AT TIME ZONE 'America/Lima', 'YYYY-MM')`
	var args []any
	conds := append(customerScope(filter, &args), "p.voided_at IS NULL")
	if filter.FromPeriod != "" {
		args = append(args, filter.FromPeriod)
		conds = append(conds, fmt.Sprintf("%s >= $%d", monthExpr, len(args)))
	}
	if filter.ToPeriod != "" {
		args = append(args, filter.ToPeriod)
		conds = append(conds, fmt.Sprintf("%s <= $%d", monthExpr, len(args)))
	}
	var rows []struct {
		Month  string  `db:"month"`
		Amount float64 `db:"amount"`
	}
	query := `SELECT ` + monthExpr + ` AS month, SUM(p.amount) AS amount
		FROM payments p JOIN customers c ON c.id = p.customer_id
		WHERE ` + strings.Join(conds, " AND ") + `
		GROUP BY 1`
	if err := r.db.SelectContext(ctx, &rows, query, args...); err != nil {
		return nil, fmt.Errorf("error summing cash in by month: %w", err)
	}
	result := make(map[string]float64, len(rows))
	for _, row := range rows {
		result[row.Month] = row.Amount
	}
	return result, nil
}

func (r *PostgresCollectionsReportRepository) ListCustomers(ctx context.Context, filter ports.ReceiptLineFilter) ([]domain.CustomerLine, error) {
	var args []any
	conds := customerScope(filter, &args)
	query := `SELECT c.id AS customer_id, c.code AS customer_code, c.name AS customer_name,
		COALESCE(cm.name, '') AS community_name, COALESCE(s.name, '') AS sector_name,
		c.service_status, c.service_status_changed_at
		FROM customers c
		LEFT JOIN sectors s ON s.id = c.sector_id
		LEFT JOIN communities cm ON cm.id = c.community_id
		WHERE ` + strings.Join(conds, " AND ") + `
		ORDER BY sector_name, c.code`
	customers := []domain.CustomerLine{}
	if err := r.db.SelectContext(ctx, &customers, query, args...); err != nil {
		return nil, fmt.Errorf("error listing customers for report: %w", err)
	}
	return customers, nil
}

func (r *PostgresCollectionsReportRepository) ListPaymentLines(ctx context.Context, filter ports.ReceiptLineFilter) ([]domain.PaymentLine, error) {
	const monthExpr = `to_char(p.paid_at AT TIME ZONE 'America/Lima', 'YYYY-MM')`
	var args []any
	conds := append(customerScope(filter, &args), "p.voided_at IS NULL")
	if filter.FromPeriod != "" {
		args = append(args, filter.FromPeriod)
		conds = append(conds, fmt.Sprintf("%s >= $%d", monthExpr, len(args)))
	}
	if filter.ToPeriod != "" {
		args = append(args, filter.ToPeriod)
		conds = append(conds, fmt.Sprintf("%s <= $%d", monthExpr, len(args)))
	}
	if !filter.PaidFrom.IsZero() {
		args = append(args, filter.PaidFrom)
		conds = append(conds, fmt.Sprintf("p.paid_at >= $%d", len(args)))
	}
	if !filter.PaidTo.IsZero() {
		args = append(args, filter.PaidTo)
		conds = append(conds, fmt.Sprintf("p.paid_at < $%d", len(args)))
	}
	if filter.CollectedBy != "" {
		args = append(args, filter.CollectedBy)
		conds = append(conds, fmt.Sprintf("p.collected_by = $%d", len(args)))
	}
	query := `SELECT p.receipt_number, p.paid_at, p.method, p.collected_by_email,
		c.code AS customer_code, c.name AS customer_name,
		COALESCE(cm.name, '') AS community_name, COALESCE(s.name, '') AS sector_name,
		COALESCE(` + readingPeriodExpr + `, '') AS period, pa.amount, pa.late_fee, c.service_status
		FROM payment_allocations pa
		JOIN payments p ON p.id = pa.payment_id
		JOIN readings r ON r.id = pa.reading_id
		JOIN customers c ON c.id = p.customer_id
		LEFT JOIN sectors s ON s.id = c.sector_id
		LEFT JOIN communities cm ON cm.id = c.community_id
		WHERE ` + strings.Join(conds, " AND ") + `
		ORDER BY p.paid_at, p.receipt_number, period`
	lines := []domain.PaymentLine{}
	if err := r.db.SelectContext(ctx, &lines, query, args...); err != nil {
		return nil, fmt.Errorf("error listing payment lines: %w", err)
	}
	return lines, nil
}
