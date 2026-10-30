package repositories

import (
	"context"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/jmoiron/sqlx"
)

type SettingsRepository struct {
	db *sqlx.DB
}

func NewSettingsRepository(db *sqlx.DB) *SettingsRepository {
	return &SettingsRepository{db: db}
}

func (r *SettingsRepository) Get(ctx context.Context) (*domain.Settings, error) {
	var settings domain.Settings
	err := r.db.GetContext(ctx, &settings, `
		SELECT id, municipalidad, empresa, ruc, direccion, telefono, email, dias_vencimiento, tarifa_kwh, cargo_fijo, alumbrado, mantenimiento, igv, receipt_copies, created_at, updated_at
		FROM settings WHERE id = 'main'`)
	if err != nil {
		return nil, err
	}
	return &settings, nil
}

func (r *SettingsRepository) Upsert(ctx context.Context, s *domain.Settings) error {
	s.UpdatedAt = time.Now()
	_, err := r.db.ExecContext(ctx, `
		INSERT INTO settings (id, municipalidad, empresa, ruc, direccion, telefono, email, dias_vencimiento, tarifa_kwh, cargo_fijo, alumbrado, mantenimiento, igv, updated_at, receipt_copies)
		VALUES ('main', $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
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
			updated_at = $13,
			receipt_copies = $14`,
		s.Municipalidad, s.Empresa, s.RUC, s.Direccion, s.Telefono, s.Email, s.DiasVencimiento, 
		s.TarifaKWh, s.CargoFijo, s.Alumbrado, s.Mantenimiento, s.IGV, s.UpdatedAt, domain.NormalizeReceiptCopies(s.ReceiptCopies))
	return err
}
