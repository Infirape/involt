package ports

import (
	"context"
	"time"

	"github.com/infira/involt/backend/internal/domain"
)

// PaymentFilter narrows payment listings (e.g. for the daily cash closing).
type PaymentFilter struct {
	CustomerID    string
	CollectedBy   string
	From          time.Time
	To            time.Time
	IncludeVoided bool
}

// PaymentRepository persists payments and keeps readings' paid flags in sync.
type PaymentRepository interface {
	// Create stores the payment with its allocations atomically, assigning ID-independent
	// fields (receipt number, paid_at) and refreshing readings.is_paid / payment_date.
	Create(ctx context.Context, payment *domain.Payment) error
	GetByID(ctx context.Context, id string) (*domain.Payment, error)
	List(ctx context.Context, filter PaymentFilter) ([]domain.Payment, error)
	// Void annuls a payment and refreshes the paid flags of the receipts it covered.
	Void(ctx context.Context, id, voidedBy, reason string) error
	// PaidAmounts returns the sum of non-voided allocations per reading ID.
	PaidAmounts(ctx context.Context, readingIDs []string) (map[string]float64, error)
	// DebtByCustomer returns the outstanding balance across all periods per customer of a sector.
	DebtByCustomer(ctx context.Context, sectorID string) (map[string]float64, error)
}

// PaymentVoucherGenerator renders the proof-of-payment PDF handed to the customer.
type PaymentVoucherGenerator interface {
	GenerateVoucher(ctx context.Context, payment *domain.Payment, customer *domain.Customer, settings *domain.Settings) ([]byte, error)
}
