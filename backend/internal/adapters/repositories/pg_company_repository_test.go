package repositories

import (
	"context"
	"os"
	"testing"

	"github.com/infira/involt/backend/internal/domain"
)

func TestCompaniesSchemaMovesTheSettingsBrandIntoTheFirstCompany(t *testing.T) {
	db := openPaymentsTestDB(t)
	ctx := context.Background()
	schema, err := os.ReadFile("../../../cmd/server/companies_schema.sql")
	if err != nil {
		t.Fatalf("read schema: %v", err)
	}
	db.MustExec(string(schema)) // adds users.company_id before the users below are written
	db.MustExec(`DELETE FROM users`)
	db.MustExec(`DELETE FROM companies`)
	db.MustExec(`INSERT INTO settings (id, municipalidad, empresa) VALUES ('main', 'Entidad X', 'Empresa X')
	             ON CONFLICT (id) DO UPDATE SET municipalidad = EXCLUDED.municipalidad, empresa = EXCLUDED.empresa`)
	db.MustExec(`INSERT INTO users (id, email, password_hash, role) VALUES ('00000000-0000-0000-0000-000000000001', 'a@x.pe', 'h', 'ADMIN')`)

	db.MustExec(string(schema))
	db.MustExec(string(schema)) // idempotent

	admin := NewPostgresAdminRepository(db)
	user, err := admin.GetUserByEmail(ctx, "a@x.pe")
	if err != nil {
		t.Fatal(err)
	}
	if user.Company == nil || user.Company.Name != "Empresa X" || user.Company.Entity != "Entidad X" {
		t.Fatalf("company = %+v", user.Company)
	}

	// Editing a user without a company keeps the one it has.
	user.CompanyID = ""
	if err := admin.UpsertUser(ctx, user); err != nil {
		t.Fatal(err)
	}
	again, _ := admin.GetUserByID(ctx, "00000000-0000-0000-0000-000000000001")
	if again.CompanyID != "principal" {
		t.Fatalf("company after edit = %q", again.CompanyID)
	}

	companies := NewPostgresCompanyRepository(db)
	if err := companies.UpdateBrand(ctx, "principal", "Nueva", "Otra"); err != nil {
		t.Fatal(err)
	}
	got, _ := companies.GetByID(ctx, "principal")
	if got.Name != "Nueva" || got.Entity != "Otra" {
		t.Fatalf("renamed company = %+v", got)
	}

	// A user created with no company stays without one: the apps show InVolt.
	if err := admin.UpsertUser(ctx, &domain.User{ID: "00000000-0000-0000-0000-000000000002", Email: "b@x.pe", PasswordHash: "h", Role: domain.RoleReader}); err != nil {
		t.Fatal(err)
	}
	loner, _ := admin.GetUserByID(ctx, "00000000-0000-0000-0000-000000000002")
	if loner.CompanyID != "" || loner.Company != nil {
		t.Fatalf("user without company = %+v", loner)
	}
}
