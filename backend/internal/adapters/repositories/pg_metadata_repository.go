package repositories

import (
	"context"
	"fmt"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/jmoiron/sqlx"
)

type PostgresMetadataRepository struct {
	db *sqlx.DB
}

func NewPostgresMetadataRepository(db *sqlx.DB) *PostgresMetadataRepository {
	return &PostgresMetadataRepository{db: db}
}

func (r *PostgresMetadataRepository) ListCommunities(ctx context.Context) ([]domain.Community, error) {
	var communities []domain.Community
	query := `
		SELECT c.id, c.name, COALESCE(COUNT(cust.id), 0) as customer_count 
		FROM communities c 
		LEFT JOIN customers cust ON c.id = cust.community_id 
		GROUP BY c.id, c.name 
		ORDER BY c.name ASC`
	err := r.db.SelectContext(ctx, &communities, query)
	if err != nil {
		return nil, fmt.Errorf("error listing communities: %w", err)
	}
	return communities, nil
}

func (r *PostgresMetadataRepository) ListSectors(ctx context.Context) ([]domain.Sector, error) {
	var sectors []domain.Sector
	query := "SELECT id, COALESCE(community_id, '') AS communityid, name FROM sectors ORDER BY name ASC"
	err := r.db.SelectContext(ctx, &sectors, query)
	if err != nil {
		return nil, fmt.Errorf("error listing sectors: %w", err)
	}
	return sectors, nil
}

func (r *PostgresMetadataRepository) SaveCommunities(ctx context.Context, communities []domain.Community) error {
	query := "INSERT INTO communities (id, name) VALUES (:id, :name) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name"
	_, err := r.db.NamedExecContext(ctx, query, communities)
	return err
}

func (r *PostgresMetadataRepository) SaveSectors(ctx context.Context, sectors []domain.Sector) error {
	query := "INSERT INTO sectors (id, community_id, name) VALUES (:id, :communityid, :name) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name"
	_, err := r.db.NamedExecContext(ctx, query, sectors)
	return err
}

func (r *PostgresMetadataRepository) DeleteSector(ctx context.Context, id string) error {
	_, err := r.db.ExecContext(ctx, "DELETE FROM sectors WHERE id = $1", id)
	return err
}

func (r *PostgresMetadataRepository) DeleteCommunity(ctx context.Context, id string) error {
	_, err := r.db.ExecContext(ctx, "DELETE FROM communities WHERE id = $1", id)
	return err
}

func (r *PostgresMetadataRepository) GetAppConfig(ctx context.Context) (*domain.AppConfig, error) {
	var config domain.AppConfig
	query := "SELECT id, map_url_template, map_user_agent FROM app_configs LIMIT 1"
	err := r.db.GetContext(ctx, &config, query)
	if err != nil {
		return nil, fmt.Errorf("error getting app config: %w", err)
	}
	return &config, nil
}

func (r *PostgresMetadataRepository) GetSettings(ctx context.Context) (*domain.Settings, error) {
	var settings domain.Settings
	query := `SELECT id, municipalidad, empresa, ruc, direccion, telefono, email, dias_vencimiento, tarifa_kwh, cargo_fijo, alumbrado, mantenimiento, igv, created_at, updated_at 
			 FROM settings WHERE id = 'main'`
	err := r.db.GetContext(ctx, &settings, query)
	return &settings, err
}

func (r *PostgresMetadataRepository) SaveSettings(ctx context.Context, s *domain.Settings) error {
	query := `
		INSERT INTO settings (id, municipalidad, empresa, ruc, direccion, telefono, email, dias_vencimiento, tarifa_kwh, cargo_fijo, alumbrado, mantenimiento, igv, updated_at)
		VALUES ('main', $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, NOW())
		ON CONFLICT (id) DO UPDATE SET
			municipalidad = $1,
			empresa = $2,
			ruc = $3,
			direccion = $4,
			telefono = $5,
			email = $6,
			dias_vencimiento = $7,
			tarifa_kwh = $8,
			cargo_fijo = $9,
			alumbrado = $10,
			mantenimiento = $11,
			igv = $12,
			updated_at = NOW()`
	_, err := r.db.ExecContext(ctx, query,
		s.Municipalidad, s.Empresa, s.RUC, s.Direccion, s.Telefono, s.Email, s.DiasVencimiento,
		s.TarifaKWh, s.CargoFijo, s.Alumbrado, s.Mantenimiento, s.IGV)
	return err
}
