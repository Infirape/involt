package branding

import (
	"context"
	"errors"
	"testing"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

type fakeMeta struct {
	ports.MetadataRepository
	settings domain.Settings
	saved    *domain.Settings
}

func (f *fakeMeta) GetSettings(context.Context) (*domain.Settings, error) {
	s := f.settings
	return &s, nil
}

func (f *fakeMeta) SaveSettings(_ context.Context, s *domain.Settings) error {
	f.saved = s
	return nil
}

type fakeCompanies struct {
	companies map[string]domain.Company
	renamed   [3]string
}

func (f *fakeCompanies) GetByID(_ context.Context, id string) (*domain.Company, error) {
	c, ok := f.companies[id]
	if !ok {
		return nil, errors.New("not found")
	}
	return &c, nil
}

func (f *fakeCompanies) UpdateBrand(_ context.Context, id, name, entity string) error {
	f.renamed = [3]string{id, name, entity}
	return nil
}

func asUser(companyID string) context.Context {
	return auth.WithClaims(context.Background(), &auth.Claims{UserID: "u1", CompanyID: companyID})
}

func newRepo() (*MetadataRepository, *fakeMeta, *fakeCompanies) {
	meta := &fakeMeta{settings: domain.Settings{Empresa: "Old", Municipalidad: "Old entity", RUC: "123"}}
	companies := &fakeCompanies{companies: map[string]domain.Company{
		"acme":   {ID: "acme", Name: "Acme Energía", Entity: "Municipalidad Acme", Logo: "companies/acme.png"},
		"nologo": {ID: "nologo", Name: "Sin Logo"},
	}}
	return NewMetadataRepository(meta, companies), meta, companies
}

func TestSettingsCarryTheBrandOfTheUsersCompany(t *testing.T) {
	repo, _, _ := newRepo()
	got, err := repo.GetSettings(asUser("acme"))
	if err != nil {
		t.Fatal(err)
	}
	if got.Empresa != "Acme Energía" || got.Municipalidad != "Municipalidad Acme" || got.Logo != "companies/acme.png" {
		t.Fatalf("brand = %q / %q / %q", got.Empresa, got.Municipalidad, got.Logo)
	}
	if got.RUC != "123" {
		t.Fatalf("other settings must be kept, RUC = %q", got.RUC)
	}
}

func TestSettingsFallBackToTheInvoltLogo(t *testing.T) {
	repo, _, _ := newRepo()
	for name, ctx := range map[string]context.Context{
		"no user":          context.Background(),
		"user w/o company": asUser(""),
		"unknown company":  asUser("ghost"),
		"company w/o logo": asUser("nologo"),
	} {
		got, _ := repo.GetSettings(ctx)
		if got.Logo != domain.DefaultLogo {
			t.Errorf("%s: logo = %q, want %q", name, got.Logo, domain.DefaultLogo)
		}
	}
	got, _ := repo.GetSettings(context.Background())
	if got.Empresa != "Old" {
		t.Fatalf("without a company the stored settings stay, got %q", got.Empresa)
	}
}

func TestSavingSettingsRenamesTheUsersCompany(t *testing.T) {
	repo, meta, companies := newRepo()
	s := &domain.Settings{Empresa: "Nueva", Municipalidad: "Entidad"}
	if err := repo.SaveSettings(asUser("acme"), s); err != nil {
		t.Fatal(err)
	}
	if companies.renamed != [3]string{"acme", "Nueva", "Entidad"} {
		t.Fatalf("company rename = %v", companies.renamed)
	}
	if meta.saved != s {
		t.Fatal("settings must still be saved")
	}
}
