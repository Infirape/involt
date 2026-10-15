package ports

import (
	"context"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// CollectionPolicyRepository stores the single collection policy row.
type CollectionPolicyRepository interface {
	Get(ctx context.Context) (*domain.CollectionPolicy, error)
	Save(ctx context.Context, policy *domain.CollectionPolicy) error
}

// LateFeeWaiver records that a receipt's mora was forgiven.
type LateFeeWaiver struct {
	ReadingID     string
	Reason        string
	WaivedBy      string
	WaivedByEmail string
	AgreementID   string
}

// AgreementRepository persists payment agreements (convenios) and late fee waivers.
type AgreementRepository interface {
	// Create stores the agreement, its receipts and installments atomically. It fails with
	// domain.ErrReceiptInAgreement if a receipt already belongs to an ACTIVE agreement.
	Create(ctx context.Context, agreement *domain.Agreement) error
	GetByID(ctx context.Context, id string) (*domain.Agreement, error)
	// List returns agreements (with receipts, installments and PaidSinceSigning). Empty
	// customerIDs means all customers; onlyActive limits to status ACTIVE.
	List(ctx context.Context, customerIDs []string, onlyActive bool) ([]domain.Agreement, error)
	Cancel(ctx context.Context, id, cancelledBy, reason string) error
	Waive(ctx context.Context, waivers []LateFeeWaiver) error
	WaivedReadings(ctx context.Context, readingIDs []string) (map[string]bool, error)
}

// AgreementDocumentGenerator renders the agreement (convenio) PDF to be signed.
type AgreementDocumentGenerator interface {
	GenerateAgreement(ctx context.Context, agreement *domain.Agreement, customer *domain.Customer, settings *domain.Settings) ([]byte, error)
}

// WorkbookMeta is the header printed on every exported workbook.
type WorkbookMeta struct {
	Entity      string
	Company     string
	Title       string
	Filters     [][2]string // label, value
	GeneratedAt time.Time
	GeneratedBy string
}

// ReportWorkbookGenerator renders detailed Excel reports with charts and pivot tables.
type ReportWorkbookGenerator interface {
	DebtorsWorkbook(ctx context.Context, report *involtv1.GetDebtorsResponse, meta WorkbookMeta) ([]byte, error)
	CashClosingWorkbook(ctx context.Context, report *involtv1.GetCashClosingResponse, meta WorkbookMeta) ([]byte, error)
	CollectionsWorkbook(ctx context.Context, data CollectionsWorkbookData, meta WorkbookMeta) ([]byte, error)
}

// CollectionsWorkbookData is everything the collections workbook needs, already filtered.
type CollectionsWorkbookData struct {
	Report    *involtv1.GetCollectionsDashboardResponse
	Receipts  []domain.ReceiptLine  // receipts in the period range
	Customers []domain.CustomerLine // every supply in scope, even without receipts
	Payments  []domain.PaymentLine  // allocations paid within the period range
}
