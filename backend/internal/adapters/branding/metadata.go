// Package branding shows each user the brand of their own company.
package branding

import (
	"context"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

// MetadataRepository wraps another one so the settings it returns carry the brand (name, entity,
// logo) of the company of the user in the context. Saving settings renames that company.
type MetadataRepository struct {
	ports.MetadataRepository
	companies ports.CompanyRepository
}

func NewMetadataRepository(inner ports.MetadataRepository, companies ports.CompanyRepository) *MetadataRepository {
	return &MetadataRepository{MetadataRepository: inner, companies: companies}
}

func (r *MetadataRepository) GetSettings(ctx context.Context) (*domain.Settings, error) {
	settings, err := r.MetadataRepository.GetSettings(ctx)
	if err != nil || settings == nil {
		return settings, err
	}
	settings.Logo = domain.DefaultLogo
	if company := r.companyOf(ctx); company != nil {
		settings.Empresa = company.Name
		settings.Municipalidad = company.Entity
		if company.Logo != "" {
			settings.Logo = company.Logo
		}
	}
	return settings, nil
}

func (r *MetadataRepository) SaveSettings(ctx context.Context, settings *domain.Settings) error {
	if company := r.companyOf(ctx); company != nil {
		if err := r.companies.UpdateBrand(ctx, company.ID, settings.Empresa, settings.Municipalidad); err != nil {
			return err
		}
	}
	return r.MetadataRepository.SaveSettings(ctx, settings)
}

// companyOf returns the company of the user in the context, or nil.
func (r *MetadataRepository) companyOf(ctx context.Context) *domain.Company {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok || user.CompanyID == "" {
		return nil
	}
	company, err := r.companies.GetByID(ctx, user.CompanyID)
	if err != nil {
		return nil
	}
	return company
}
