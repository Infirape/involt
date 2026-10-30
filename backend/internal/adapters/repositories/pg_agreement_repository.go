package repositories

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
	"github.com/jmoiron/sqlx"
	"github.com/lib/pq"
)

type PostgresAgreementRepository struct {
	db *sqlx.DB
}

func NewPostgresAgreementRepository(db *sqlx.DB) *PostgresAgreementRepository {
	return &PostgresAgreementRepository{db: db}
}

// agreementSelect includes what was paid on the covered receipts since signing.
const agreementSelect = `SELECT a.id, a.number, a.customer_id,
	COALESCE(c.name, '') AS customer_name, COALESCE(c.code, '') AS customer_code,
	a.status, a.total, a.initial_amount, a.notes, a.late_fees_waived, a.created_by, a.created_by_email, a.created_at,
	a.cancelled_at, a.cancelled_by, a.cancel_reason,
	COALESCE((
		SELECT SUM(pa.amount + pa.late_fee)
		FROM agreement_receipts ar
		JOIN payment_allocations pa ON pa.reading_id = ar.reading_id
		JOIN payments p ON p.id = pa.payment_id
		WHERE ar.agreement_id = a.id AND p.voided_at IS NULL AND p.paid_at >= a.created_at
	), 0) AS paid_since_signing
	FROM payment_agreements a LEFT JOIN customers c ON c.id = a.customer_id`

func (r *PostgresAgreementRepository) Create(ctx context.Context, a *domain.Agreement) error {
	tx, err := r.db.BeginTxx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	ids := make([]string, len(a.Receipts))
	for i, rc := range a.Receipts {
		ids[i] = rc.ReadingID
	}
	// Lock the customer's agreements so two cashiers can't refinance the same receipt.
	if _, err := tx.ExecContext(ctx, `SELECT id FROM payment_agreements WHERE customer_id = $1 FOR UPDATE`, a.CustomerID); err != nil {
		return fmt.Errorf("error locking agreements: %w", err)
	}
	var overlapping int
	err = tx.GetContext(ctx, &overlapping, `SELECT COUNT(*) FROM agreement_receipts ar
		JOIN payment_agreements pa ON pa.id = ar.agreement_id
		WHERE pa.status = 'ACTIVE' AND ar.reading_id = ANY($1)`, pq.Array(ids))
	if err != nil {
		return fmt.Errorf("error checking agreement overlap: %w", err)
	}
	if overlapping > 0 {
		return domain.ErrReceiptInAgreement
	}

	err = tx.QueryRowxContext(ctx, `INSERT INTO payment_agreements
		(id, customer_id, status, total, initial_amount, notes, late_fees_waived, created_by, created_by_email)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING number, created_at`,
		a.ID, a.CustomerID, string(domain.AgreementActive), a.Total, a.InitialAmount, a.Notes, a.LateFeesWaived, a.CreatedBy, a.CreatedByEmail,
	).Scan(&a.Number, &a.CreatedAt)
	if err != nil {
		return fmt.Errorf("error inserting agreement: %w", err)
	}
	a.Status = domain.AgreementActive

	for _, rc := range a.Receipts {
		if _, err := tx.ExecContext(ctx, `INSERT INTO agreement_receipts (agreement_id, reading_id, principal, late_fee)
			VALUES ($1, $2, $3, $4)`, a.ID, rc.ReadingID, rc.Principal, rc.LateFee); err != nil {
			return fmt.Errorf("error inserting agreement receipt: %w", err)
		}
	}
	for _, in := range a.Installments {
		if _, err := tx.ExecContext(ctx, `INSERT INTO agreement_installments (agreement_id, number, due_date, amount)
			VALUES ($1, $2, $3, $4)`, a.ID, in.Number, in.DueDate.Format("2006-01-02"), in.Amount); err != nil {
			return fmt.Errorf("error inserting installment: %w", err)
		}
	}
	return tx.Commit()
}

func (r *PostgresAgreementRepository) GetByID(ctx context.Context, id string) (*domain.Agreement, error) {
	var a domain.Agreement
	if err := r.db.GetContext(ctx, &a, agreementSelect+` WHERE a.id = $1`, id); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, domain.ErrAgreementNotFound
		}
		return nil, fmt.Errorf("error getting agreement: %w", err)
	}
	list := []domain.Agreement{a}
	if err := r.attachDetails(ctx, list); err != nil {
		return nil, err
	}
	return &list[0], nil
}

func (r *PostgresAgreementRepository) List(ctx context.Context, customerIDs []string, onlyActive bool) ([]domain.Agreement, error) {
	var conds []string
	var args []any
	if len(customerIDs) > 0 {
		args = append(args, pq.Array(customerIDs))
		conds = append(conds, fmt.Sprintf("a.customer_id = ANY($%d)", len(args)))
	}
	if onlyActive {
		conds = append(conds, "a.status = 'ACTIVE'")
	}
	query := agreementSelect
	if len(conds) > 0 {
		query += " WHERE " + strings.Join(conds, " AND ")
	}
	query += " ORDER BY a.created_at DESC"

	list := []domain.Agreement{}
	if err := r.db.SelectContext(ctx, &list, query, args...); err != nil {
		return nil, fmt.Errorf("error listing agreements: %w", err)
	}
	if err := r.attachDetails(ctx, list); err != nil {
		return nil, err
	}
	return list, nil
}

func (r *PostgresAgreementRepository) Cancel(ctx context.Context, id, cancelledBy, reason string) error {
	res, err := r.db.ExecContext(ctx, `UPDATE payment_agreements
		SET status = 'CANCELLED', cancelled_at = NOW(), cancelled_by = $2, cancel_reason = $3
		WHERE id = $1 AND status = 'ACTIVE'`, id, cancelledBy, reason)
	if err != nil {
		return fmt.Errorf("error cancelling agreement: %w", err)
	}
	if n, _ := res.RowsAffected(); n == 0 {
		var exists bool
		if err := r.db.GetContext(ctx, &exists, `SELECT EXISTS (SELECT 1 FROM payment_agreements WHERE id = $1)`, id); err != nil {
			return fmt.Errorf("error checking agreement: %w", err)
		}
		if !exists {
			return domain.ErrAgreementNotFound
		}
		return fmt.Errorf("%w: agreement is not active", domain.ErrInvalidAgreement)
	}
	return nil
}

func (r *PostgresAgreementRepository) Waive(ctx context.Context, waivers []ports.LateFeeWaiver) error {
	for _, w := range waivers {
		_, err := r.db.ExecContext(ctx, `INSERT INTO late_fee_waivers (reading_id, reason, waived_by, waived_by_email, agreement_id)
			VALUES ($1, $2, $3, $4, NULLIF($5, '')) ON CONFLICT (reading_id) DO NOTHING`,
			w.ReadingID, w.Reason, w.WaivedBy, w.WaivedByEmail, w.AgreementID)
		if err != nil {
			return fmt.Errorf("error waiving late fee: %w", err)
		}
	}
	return nil
}

func (r *PostgresAgreementRepository) WaivedReadings(ctx context.Context, readingIDs []string) (map[string]bool, error) {
	result := make(map[string]bool, len(readingIDs))
	if len(readingIDs) == 0 {
		return result, nil
	}
	var ids []string
	if err := r.db.SelectContext(ctx, &ids, `SELECT reading_id FROM late_fee_waivers WHERE reading_id = ANY($1)`, pq.Array(readingIDs)); err != nil {
		return nil, fmt.Errorf("error loading waivers: %w", err)
	}
	for _, id := range ids {
		result[id] = true
	}
	return result, nil
}

// attachDetails loads receipts and installments for all agreements in two queries.
func (r *PostgresAgreementRepository) attachDetails(ctx context.Context, list []domain.Agreement) error {
	if len(list) == 0 {
		return nil
	}
	ids := make([]string, len(list))
	index := make(map[string]int, len(list))
	for i, a := range list {
		ids[i] = a.ID
		index[a.ID] = i
	}

	var receipts []struct {
		AgreementID string `db:"agreement_id"`
		domain.AgreementReceipt
	}
	err := r.db.SelectContext(ctx, &receipts, `SELECT ar.agreement_id, ar.reading_id,
		COALESCE(NULLIF(rd.period, ''), to_char(rd.period_start, 'YYYY-MM'), '') AS period, ar.principal, ar.late_fee
		FROM agreement_receipts ar JOIN readings rd ON rd.id = ar.reading_id
		WHERE ar.agreement_id = ANY($1) ORDER BY period`, pq.Array(ids))
	if err != nil {
		return fmt.Errorf("error loading agreement receipts: %w", err)
	}
	for _, rc := range receipts {
		i := index[rc.AgreementID]
		list[i].Receipts = append(list[i].Receipts, rc.AgreementReceipt)
	}

	var installments []struct {
		AgreementID string `db:"agreement_id"`
		domain.Installment
	}
	err = r.db.SelectContext(ctx, &installments, `SELECT agreement_id, number, due_date, amount
		FROM agreement_installments WHERE agreement_id = ANY($1) ORDER BY number`, pq.Array(ids))
	if err != nil {
		return fmt.Errorf("error loading installments: %w", err)
	}
	for _, in := range installments {
		i := index[in.AgreementID]
		list[i].Installments = append(list[i].Installments, in.Installment)
	}
	return nil
}
