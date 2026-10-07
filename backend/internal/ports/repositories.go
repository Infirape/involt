package ports

import (
	"context"

	"github.com/infira/involt/backend/internal/domain"
)

// ReadingRepository defines operations for meter readings.
type ReadingRepository interface {
	Save(ctx context.Context, reading *domain.Reading) error
	GetByID(ctx context.Context, id string) (*domain.Reading, error)
	ListByCustomer(ctx context.Context, customerID string) ([]domain.Reading, error)
	GetLatestByCustomer(ctx context.Context, customerID string) (*domain.Reading, error)
	GetLatestByCustomerExcludingID(ctx context.Context, customerID, excludeID string) (*domain.Reading, error)
	ListBySectorAndPeriod(ctx context.Context, sectorID string, start, end string) ([]domain.Reading, error)
	CountByPeriod(ctx context.Context, period string) (int, error)
	CountPendingByPeriod(ctx context.Context, period string) (int, error)
	ListPeriods(ctx context.Context) ([]string, error)
	CountBySectorAndPeriod(ctx context.Context, sectorID, period string) (int, error)
	SumConsumptionBySectorAndPeriod(ctx context.Context, sectorID, period string) (float64, error)
	SumRevenueBySectorAndPeriod(ctx context.Context, sectorID, period string) (float64, error)
	SumRevenueByPeriod(ctx context.Context, period string) (float64, error)
	SumConsumptionByPeriod(ctx context.Context, period string) (float64, error)
	List(ctx context.Context, customerID, sectorID, period string, limit, offset int) ([]domain.Reading, int, error)
	ListAll(ctx context.Context) ([]domain.Reading, error)
	UpdatePaymentStatus(ctx context.Context, readingID string, isPaid bool) error
	ListBySector(ctx context.Context, sectorID string, periods []string) ([]domain.Reading, error)
	GetByCustomerAndPeriod(ctx context.Context, customerID, period string) (*domain.Reading, error)
}

// CustomerRepository defines operations for customer data.
type CustomerRepository interface {
	GetByID(ctx context.Context, id string) (*domain.Customer, error)
	GetByCode(ctx context.Context, code string) (*domain.Customer, error)
	List(ctx context.Context, allowedSectorIDs []string, searchQuery string, limit, offset int, excludePeriodID string, communityID string) ([]domain.Customer, int, error)
	ListAll(ctx context.Context) ([]domain.Customer, error)
	SaveBatch(ctx context.Context, customers []domain.Customer) error
	Save(ctx context.Context, customer *domain.Customer) error
	Delete(ctx context.Context, id string) error
	CountBySector(ctx context.Context, sectorID string) (int, error)
	ListBySector(ctx context.Context, sectorID string) ([]domain.Customer, error)
}

// MetadataRepository defines operations for communities and sectors.
type MetadataRepository interface {
	ListCommunities(ctx context.Context) ([]domain.Community, error)
	ListSectors(ctx context.Context) ([]domain.Sector, error)
	SaveCommunities(ctx context.Context, communities []domain.Community) error
	SaveSectors(ctx context.Context, sectors []domain.Sector) error
	DeleteSector(ctx context.Context, id string) error
	DeleteCommunity(ctx context.Context, id string) error
	GetAppConfig(ctx context.Context) (*domain.AppConfig, error)
	GetSettings(ctx context.Context) (*domain.Settings, error)
	SaveSettings(ctx context.Context, settings *domain.Settings) error
}

// PeriodRepository defines operations for managing billing periods.
type PeriodRepository interface {
	GetByID(ctx context.Context, id string) (*domain.Period, error)
	GetCurrent(ctx context.Context) (*domain.Period, error)
	List(ctx context.Context) ([]domain.Period, error)
	Save(ctx context.Context, period *domain.Period) error
	GetStats(ctx context.Context, periodID string) (*domain.PeriodStats, error)
}
