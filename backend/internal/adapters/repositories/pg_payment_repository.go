package repositories

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"math"
	"strings"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
	"github.com/jmoiron/sqlx"
	"github.com/lib/pq"
)

type PostgresPaymentRepository struct {
	db *sqlx.DB
}

func NewPostgresPaymentRepository(db *sqlx.DB) *PostgresPaymentRepository {
	return &PostgresPaymentRepository{db: db}
}

const paymentSelect = `SELECT p.id, p.receipt_number, p.customer_id,
	COALESCE(c.name, '') AS customer_name, COALESCE(c.code, '') AS customer_code,
	p.amount, p.method, p.reference, p.observation, p.collected_by, p.collected_by_email,
	p.paid_at, p.voided_at, p.voided_by, p.void_reason
	FROM payments p LEFT JOIN customers c ON c.id = p.customer_id`

// syncReadingsPaidQuery recomputes readings.is_paid / payment_date from non-voided allocations.
// Half a cent of tolerance absorbs float rounding in total_to_pay.
const syncReadingsPaidQuery = `UPDATE readings r SET
	is_paid = (s.paid + 0.005 >= r.total_to_pay),
	payment_date = CASE WHEN s.paid + 0.005 >= r.total_to_pay THEN s.last_paid ELSE NULL END
	FROM (
		SELECT r2.id,
		       COALESCE(SUM(pa.amount) FILTER (WHERE p.voided_at IS NULL), 0) AS paid,
		       MAX(p.paid_at) FILTER (WHERE p.voided_at IS NULL) AS last_paid
		FROM readings r2
		LEFT JOIN payment_allocations pa ON pa.reading_id = r2.id
		LEFT JOIN payments p ON p.id = pa.payment_id
		WHERE r2.id = ANY($1)
		GROUP BY r2.id
	) s
	WHERE r.id = s.id`

func (r *PostgresPaymentRepository) Create(ctx context.Context, payment *domain.Payment) error {
	tx, err := r.db.BeginTxx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	insert := `INSERT INTO payments (id, customer_id, amount, method, reference, observation, collected_by, collected_by_email)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
		RETURNING receipt_number, paid_at`
	err = tx.QueryRowxContext(ctx, insert,
		payment.ID, payment.CustomerID, payment.Amount, payment.Method, payment.Reference,
		payment.Observation, payment.CollectedBy, payment.CollectedByEmail,
	).Scan(&payment.ReceiptNumber, &payment.PaidAt)
	if err != nil {
		return fmt.Errorf("error inserting payment: %w", err)
	}

	readingIDs := make([]string, 0, len(payment.Allocations))
	for _, a := range payment.Allocations {
		_, err := tx.ExecContext(ctx,
			`INSERT INTO payment_allocations (payment_id, reading_id, amount) VALUES ($1, $2, $3)`,
			payment.ID, a.ReadingID, a.Amount)
		if err != nil {
			return fmt.Errorf("error inserting payment allocation: %w", err)
		}
		readingIDs = append(readingIDs, a.ReadingID)
	}

	if _, err := tx.ExecContext(ctx, syncReadingsPaidQuery, pq.Array(readingIDs)); err != nil {
		return fmt.Errorf("error syncing readings paid status: %w", err)
	}
	return tx.Commit()
}

func (r *PostgresPaymentRepository) GetByID(ctx context.Context, id string) (*domain.Payment, error) {
	var p domain.Payment
	if err := r.db.GetContext(ctx, &p, paymentSelect+` WHERE p.id = $1`, id); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, domain.ErrPaymentNotFound
		}
		return nil, fmt.Errorf("error getting payment: %w", err)
	}
	payments := []domain.Payment{p}
	if err := r.attachAllocations(ctx, payments); err != nil {
		return nil, err
	}
	return &payments[0], nil
}

func (r *PostgresPaymentRepository) List(ctx context.Context, filter ports.PaymentFilter) ([]domain.Payment, error) {
	var conds []string
	var args []any
	add := func(cond string, arg any) {
		args = append(args, arg)
		conds = append(conds, fmt.Sprintf(cond, len(args)))
	}
	if filter.CustomerID != "" {
		add("p.customer_id = $%d", filter.CustomerID)
	}
	if filter.CollectedBy != "" {
		add("p.collected_by = $%d", filter.CollectedBy)
	}
	if !filter.From.IsZero() {
		add("p.paid_at >= $%d", filter.From)
	}
	if !filter.To.IsZero() {
		add("p.paid_at < $%d", filter.To)
	}
	if !filter.IncludeVoided {
		conds = append(conds, "p.voided_at IS NULL")
	}

	query := paymentSelect
	if len(conds) > 0 {
		query += " WHERE " + strings.Join(conds, " AND ")
	}
	query += " ORDER BY p.paid_at DESC, p.receipt_number DESC"

	payments := []domain.Payment{}
	if err := r.db.SelectContext(ctx, &payments, query, args...); err != nil {
		return nil, fmt.Errorf("error listing payments: %w", err)
	}
	if err := r.attachAllocations(ctx, payments); err != nil {
		return nil, err
	}
	return payments, nil
}

func (r *PostgresPaymentRepository) Void(ctx context.Context, id, voidedBy, reason string) error {
	tx, err := r.db.BeginTxx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	var alreadyVoided bool
	err = tx.QueryRowxContext(ctx, `SELECT voided_at IS NOT NULL FROM payments WHERE id = $1 FOR UPDATE`, id).Scan(&alreadyVoided)
	if errors.Is(err, sql.ErrNoRows) {
		return domain.ErrPaymentNotFound
	}
	if err != nil {
		return fmt.Errorf("error locking payment: %w", err)
	}
	if alreadyVoided {
		return domain.ErrPaymentAlreadyVoided
	}

	_, err = tx.ExecContext(ctx,
		`UPDATE payments SET voided_at = NOW(), voided_by = $2, void_reason = $3 WHERE id = $1`,
		id, voidedBy, reason)
	if err != nil {
		return fmt.Errorf("error voiding payment: %w", err)
	}

	var readingIDs []string
	if err := tx.SelectContext(ctx, &readingIDs, `SELECT reading_id FROM payment_allocations WHERE payment_id = $1`, id); err != nil {
		return fmt.Errorf("error loading voided allocations: %w", err)
	}
	if _, err := tx.ExecContext(ctx, syncReadingsPaidQuery, pq.Array(readingIDs)); err != nil {
		return fmt.Errorf("error syncing readings paid status: %w", err)
	}
	return tx.Commit()
}

func (r *PostgresPaymentRepository) PaidAmounts(ctx context.Context, readingIDs []string) (map[string]float64, error) {
	result := make(map[string]float64, len(readingIDs))
	if len(readingIDs) == 0 {
		return result, nil
	}
	var rows []struct {
		ReadingID string  `db:"reading_id"`
		Paid      float64 `db:"paid"`
	}
	query := `SELECT pa.reading_id, SUM(pa.amount) AS paid
		FROM payment_allocations pa JOIN payments p ON p.id = pa.payment_id
		WHERE p.voided_at IS NULL AND pa.reading_id = ANY($1)
		GROUP BY pa.reading_id`
	if err := r.db.SelectContext(ctx, &rows, query, pq.Array(readingIDs)); err != nil {
		return nil, fmt.Errorf("error summing paid amounts: %w", err)
	}
	for _, row := range rows {
		result[row.ReadingID] = row.Paid
	}
	return result, nil
}

// attachAllocations loads allocations for all given payments in one query.
func (r *PostgresPaymentRepository) attachAllocations(ctx context.Context, payments []domain.Payment) error {
	if len(payments) == 0 {
		return nil
	}
	ids := make([]string, len(payments))
	index := make(map[string]int, len(payments))
	for i, p := range payments {
		ids[i] = p.ID
		index[p.ID] = i
	}
	var rows []struct {
		PaymentID string `db:"payment_id"`
		domain.PaymentAllocation
	}
	query := `SELECT pa.payment_id, pa.reading_id, COALESCE(rd.period, '') AS period, pa.amount
		FROM payment_allocations pa JOIN readings rd ON rd.id = pa.reading_id
		WHERE pa.payment_id = ANY($1)
		ORDER BY rd.period`
	if err := r.db.SelectContext(ctx, &rows, query, pq.Array(ids)); err != nil {
		return fmt.Errorf("error loading payment allocations: %w", err)
	}
	for _, row := range rows {
		i := index[row.PaymentID]
		payments[i].Allocations = append(payments[i].Allocations, row.PaymentAllocation)
	}
	return nil
}

func (r *PostgresPaymentRepository) DebtByCustomer(ctx context.Context, sectorID string) (map[string]float64, error) {
	var rows []struct {
		CustomerID string  `db:"customer_id"`
		Debt       float64 `db:"debt"`
	}
	query := `SELECT r.customer_id, SUM(GREATEST(r.total_to_pay - COALESCE(pd.paid, 0), 0)) AS debt
		FROM readings r
		JOIN customers c ON c.id = r.customer_id
		LEFT JOIN (
			SELECT pa.reading_id, SUM(pa.amount) AS paid
			FROM payment_allocations pa JOIN payments p ON p.id = pa.payment_id
			WHERE p.voided_at IS NULL
			GROUP BY pa.reading_id
		) pd ON pd.reading_id = r.id
		WHERE c.sector_id = $1
		GROUP BY r.customer_id`
	if err := r.db.SelectContext(ctx, &rows, query, sectorID); err != nil {
		return nil, fmt.Errorf("error computing debt by customer: %w", err)
	}
	result := make(map[string]float64, len(rows))
	for _, row := range rows {
		result[row.CustomerID] = math.Round(row.Debt*100) / 100
	}
	return result, nil
}
