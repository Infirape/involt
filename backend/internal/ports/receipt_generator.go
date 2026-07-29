package ports

import (
	"context"
	"github.com/infira/involt/backend/internal/domain"
)

// ReceiptGenerator defines the operation to create a PDF receipt.
type ReceiptGenerator interface {
	Generate(ctx context.Context, reading *domain.Reading, customer *domain.Customer, settings *domain.Settings, community, sector string, history []domain.Reading) ([]byte, error)
	GenerateBatch(ctx context.Context, readings []domain.Reading, customers map[string]*domain.Customer, settings *domain.Settings, historyMap map[string][]domain.Reading) ([]byte, error)
}
