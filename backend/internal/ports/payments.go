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
	// LateFeesPaid returns the sum of non-voided late fee (mora) allocations per reading ID.
	LateFeesPaid(ctx context.Context, readingIDs []string) (map[string]float64, error)
	// DebtByCustomer returns the outstanding balance across all periods per customer of a sector.
	DebtByCustomer(ctx context.Context, sectorID string) (map[string]float64, error)
}

// PaymentVoucherGenerator renders the proof-of-payment PDF handed to the customer.
type PaymentVoucherGenerator interface {
	GenerateVoucher(ctx context.Context, payment *domain.Payment, customer *domain.Customer, settings *domain.Settings) ([]byte, error)
}

// ReceiptLineFilter scopes collection reports. Empty fields mean "no restriction";
// AllowedSectorIDs (non-nil) enforces RBAC for non-admin users.
type ReceiptLineFilter struct {
	AllowedSectorIDs []string
	CommunityID      string
	SectorID         string
	FromPeriod       string // YYYY-MM inclusive
	ToPeriod         string // YYYY-MM inclusive
	OnlyOutstanding  bool
}

// CollectionsReportRepository provides read models for dashboards and debtor lists.
type CollectionsReportRepository interface {
	ListReceiptLines(ctx context.Context, filter ReceiptLineFilter) ([]domain.ReceiptLine, error)
	LastPaymentDates(ctx context.Context, customerIDs []string) (map[string]time.Time, error)
	// CashInByMonth sums non-voided payments by Lima calendar month (YYYY-MM) of paid_at.
	CashInByMonth(ctx context.Context, filter ReceiptLineFilter) (map[string]float64, error)
	// ListCustomers returns every active supply in scope (periods are ignored), by sector and code.
	ListCustomers(ctx context.Context, filter ReceiptLineFilter) ([]domain.CustomerLine, error)
	// ListPaymentLines returns non-voided allocations whose payment's Lima month is within
	// FromPeriod..ToPeriod, in scope, oldest first.
	ListPaymentLines(ctx context.Context, filter ReceiptLineFilter) ([]domain.PaymentLine, error)
}
