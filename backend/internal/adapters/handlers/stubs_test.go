package handlers

import (
	"context"
	"time"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

func authenticatedTestContext() context.Context {
	return context.WithValue(context.Background(), auth.UserContextKey, &auth.UserContext{
		ID:    "admin-1",
		Email: "admin@example.com",
		Role:  "ADMIN",
	})
}

type collectionsCustomerRepoStub struct {
	listBySectorFunc func(context.Context, string) ([]domain.Customer, error)
	getByIDFunc      func(context.Context, string) (*domain.Customer, error)
}

func (s *collectionsCustomerRepoStub) GetByID(ctx context.Context, id string) (*domain.Customer, error) {
	return s.getByIDFunc(ctx, id)
}
func (s *collectionsCustomerRepoStub) GetByCode(context.Context, string) (*domain.Customer, error) {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) List(context.Context, []string, string, int, int, string, string) ([]domain.Customer, int, error) {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) ListAll(context.Context) ([]domain.Customer, error) {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) SaveBatch(context.Context, []domain.Customer) error {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) Save(context.Context, *domain.Customer) error {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) Delete(context.Context, string) error {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) CountBySector(context.Context, string) (int, error) {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) ListBySector(ctx context.Context, sectorID string) ([]domain.Customer, error) {
	return s.listBySectorFunc(ctx, sectorID)
}

type collectionsReadingRepoStub struct {
	listBySectorFunc           func(context.Context, string, []string) ([]domain.Reading, error)
	listByCustomerFunc         func(context.Context, string) ([]domain.Reading, error)
	getByCustomerAndPeriodFunc func(context.Context, string, string) (*domain.Reading, error)
	saved                      []*domain.Reading
}

func (s *collectionsReadingRepoStub) Save(_ context.Context, r *domain.Reading) error {
	s.saved = append(s.saved, r)
	return nil
}
func (s *collectionsReadingRepoStub) GetByID(ctx context.Context, id string) (*domain.Reading, error) {
	readings, _ := s.listByCustomerFunc(ctx, "")
	for i := range readings {
		if readings[i].ID == id {
			return &readings[i], nil
		}
	}
	return nil, nil
}
func (s *collectionsReadingRepoStub) ListByCustomer(ctx context.Context, customerID string) ([]domain.Reading, error) {
	return s.listByCustomerFunc(ctx, customerID)
}
func (s *collectionsReadingRepoStub) GetLatestByCustomer(context.Context, string) (*domain.Reading, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) GetLatestByCustomerExcludingID(context.Context, string, string) (*domain.Reading, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) ListBySectorAndPeriod(context.Context, string, string, string) ([]domain.Reading, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) CountByPeriod(context.Context, string) (int, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) CountPendingByPeriod(context.Context, string) (int, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) ListPeriods(context.Context) ([]string, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) CountBySectorAndPeriod(context.Context, string, string) (int, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) SumConsumptionBySectorAndPeriod(context.Context, string, string) (float64, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) SumRevenueBySectorAndPeriod(context.Context, string, string) (float64, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) SumRevenueByPeriod(context.Context, string) (float64, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) SumConsumptionByPeriod(context.Context, string) (float64, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) List(context.Context, string, string, string, int, int) ([]domain.Reading, int, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) ListAll(context.Context) ([]domain.Reading, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) UpdatePaymentStatus(context.Context, string, bool) error {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) ListBySector(ctx context.Context, sectorID string, periods []string) ([]domain.Reading, error) {
	return s.listBySectorFunc(ctx, sectorID, periods)
}
func (s *collectionsReadingRepoStub) GetByCustomerAndPeriod(ctx context.Context, customerID, period string) (*domain.Reading, error) {
	return s.getByCustomerAndPeriodFunc(ctx, customerID, period)
}

// settingsMetaStub embeds the interface so only GetSettings needs an implementation.
type settingsMetaStub struct {
	ports.MetadataRepository
	settings *domain.Settings
}

func (s *settingsMetaStub) GetSettings(context.Context) (*domain.Settings, error) {
	return s.settings, nil
}

func (s *settingsMetaStub) ListCommunities(context.Context) ([]domain.Community, error) {
	return []domain.Community{{ID: "com-1", Name: "Chetilla"}}, nil
}

func (s *settingsMetaStub) ListSectors(context.Context) ([]domain.Sector, error) {
	return []domain.Sector{{ID: "s2", Name: "Alto"}}, nil
}

// fakePaymentRepo is an in-memory PaymentRepository.
type fakePaymentRepo struct {
	payments []*domain.Payment
	debts    map[string]float64
}

func (f *fakePaymentRepo) Create(_ context.Context, p *domain.Payment) error {
	p.ReceiptNumber = int64(len(f.payments) + 1)
	p.PaidAt = time.Date(2026, 10, 13, 15, 0, 0, 0, time.UTC)
	f.payments = append(f.payments, p)
	return nil
}

func (f *fakePaymentRepo) GetByID(_ context.Context, id string) (*domain.Payment, error) {
	for _, p := range f.payments {
		if p.ID == id {
			return p, nil
		}
	}
	return nil, domain.ErrPaymentNotFound
}

func (f *fakePaymentRepo) List(_ context.Context, filter ports.PaymentFilter) ([]domain.Payment, error) {
	var out []domain.Payment
	for _, p := range f.payments {
		if filter.CustomerID != "" && p.CustomerID != filter.CustomerID {
			continue
		}
		if filter.CollectedBy != "" && p.CollectedBy != filter.CollectedBy {
			continue
		}
		if !filter.IncludeVoided && p.IsVoided() {
			continue
		}
		if !filter.From.IsZero() && p.PaidAt.Before(filter.From) {
			continue
		}
		if !filter.To.IsZero() && !p.PaidAt.Before(filter.To) {
			continue
		}
		out = append(out, *p)
	}
	return out, nil
}

func (f *fakePaymentRepo) Void(_ context.Context, id, voidedBy, reason string) error {
	for _, p := range f.payments {
		if p.ID == id {
			if p.IsVoided() {
				return domain.ErrPaymentAlreadyVoided
			}
			now := time.Now()
			p.VoidedAt, p.VoidedBy, p.VoidReason = &now, voidedBy, reason
			return nil
		}
	}
	return domain.ErrPaymentNotFound
}

func (f *fakePaymentRepo) PaidAmounts(_ context.Context, ids []string) (map[string]float64, error) {
	out := map[string]float64{}
	for _, p := range f.payments {
		if p.IsVoided() {
			continue
		}
		for _, a := range p.Allocations {
			out[a.ReadingID] += a.Amount
		}
	}
	return out, nil
}

func (f *fakePaymentRepo) LateFeesPaid(_ context.Context, _ []string) (map[string]float64, error) {
	out := map[string]float64{}
	for _, p := range f.payments {
		if p.IsVoided() {
			continue
		}
		for _, a := range p.Allocations {
			out[a.ReadingID] += a.LateFee
		}
	}
	return out, nil
}

func (f *fakePaymentRepo) DebtByCustomer(context.Context, string) (map[string]float64, error) {
	return f.debts, nil
}

func contextWithUser(id, role string, sectors ...string) context.Context {
	return context.WithValue(context.Background(), auth.UserContextKey, &auth.UserContext{
		ID: id, Email: id + "@infira.pe", Role: role, AssignedSectorIDs: sectors,
	})
}
