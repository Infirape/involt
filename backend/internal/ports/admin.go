package ports

import (
	"context"
	"github.com/infira/involt/backend/internal/domain"
)

type AdminRepository interface {
	GetUserByEmail(ctx context.Context, email string) (*domain.User, error)
	GetUserByID(ctx context.Context, id string) (*domain.User, error)
	ListUsers(ctx context.Context) ([]domain.User, error)
	UpsertUser(ctx context.Context, user *domain.User) error
}

// CompanyRepository reads and updates client companies (their brand).
type CompanyRepository interface {
	GetByID(ctx context.Context, id string) (*domain.Company, error)
	UpdateBrand(ctx context.Context, id, name, entity string) error
}
