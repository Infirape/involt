package repositories

import (
	"context"
	"fmt"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/jmoiron/sqlx"
)

type PostgresCustomerRepository struct {
	db *sqlx.DB
}

func NewPostgresCustomerRepository(db *sqlx.DB) *PostgresCustomerRepository {
	return &PostgresCustomerRepository{db: db}
}

func (r *PostgresCustomerRepository) GetByCode(ctx context.Context, code string) (*domain.Customer, error) {
	var customer domain.Customer
	query := `SELECT id, code, name, community_id, sector_id, address, 
	          connection_type, tariff, meter_number,
	          latitude, longitude, initial_reading, service_status, service_status_changed_at
	          FROM customers WHERE code = $1 AND deleted_at IS NULL`
	err := r.db.GetContext(ctx, &customer, query, code)
	if err != nil {
		return nil, fmt.Errorf("error getting customer by code: %w", err)
	}
	return &customer, nil
}

func (r *PostgresCustomerRepository) GetByID(ctx context.Context, id string) (*domain.Customer, error) {
	var customer domain.Customer
	query := `SELECT id, code, name, community_id, sector_id, address, 
	          connection_type, tariff, meter_number,
	          latitude, longitude, initial_reading, service_status, service_status_changed_at
	          FROM customers WHERE id = $1 AND deleted_at IS NULL`
	err := r.db.GetContext(ctx, &customer, query, id)
	if err != nil {
		return nil, fmt.Errorf("error getting customer by id: %w", err)
	}
	return &customer, nil
}

func (r *PostgresCustomerRepository) List(ctx context.Context, allowedSectorIDs []string, searchQuery string, limit, offset int, excludePeriodID string, communityID string, serviceStatus string) ([]domain.Customer, int, error) {
	var customers []domain.Customer
	var total int

	where := "deleted_at IS NULL"
	args := map[string]interface{}{
		"limit":             limit,
		"offset":            offset,
		"exclude_period_id": excludePeriodID,
		"community_id":      communityID,
	}

	if len(allowedSectorIDs) > 0 {
		where += " AND sector_id IN (:allowed_sector_ids)"
		args["allowed_sector_ids"] = allowedSectorIDs
	}

	if communityID != "" {
		where += " AND community_id = :community_id"
	}

	if serviceStatus != "" {
		where += " AND service_status = :service_status"
		args["service_status"] = serviceStatus
	}

	if searchQuery != "" {
		where += " AND (name ILIKE :search OR code ILIKE :search)"
		args["search"] = "%" + searchQuery + "%"
	}

	// Use sqlx.Named and sqlx.In for complex queries
	countQuery, countArgs, err := sqlx.Named(fmt.Sprintf("SELECT COUNT(*) FROM customers WHERE %s", where), args)
	if err != nil {
		return nil, 0, err
	}
	countQuery, countArgs, err = sqlx.In(countQuery, countArgs...)
	if err != nil {
		return nil, 0, err
	}
	countQuery = r.db.Rebind(countQuery)
	err = r.db.GetContext(ctx, &total, countQuery, countArgs...)
	if err != nil {
		return nil, 0, err
	}

	// Get paginated data with dynamic latest reading, potentially excluding current period
	selectQuery, selectArgs, err := sqlx.Named(fmt.Sprintf(`
		SELECT id, code, name, community_id, sector_id, address, 
		       connection_type, tariff, meter_number,
		       latitude, longitude, initial_reading, service_status, service_status_changed_at,
		       COALESCE((
		           SELECT r.current_value 
		           FROM readings r 
		           WHERE r.customer_id = customers.id 
		           AND (:exclude_period_id = '' OR r.period < :exclude_period_id)
		           ORDER BY r.period DESC LIMIT 1
		       ), initial_reading) as last_reading_value
		FROM customers WHERE %s 
		ORDER BY code ASC LIMIT :limit OFFSET :offset`, where), args)
	if err != nil {
		return nil, 0, err
	}
	selectQuery, selectArgs, err = sqlx.In(selectQuery, selectArgs...)
	if err != nil {
		return nil, 0, err
	}
	selectQuery = r.db.Rebind(selectQuery)
	err = r.db.SelectContext(ctx, &customers, selectQuery, selectArgs...)
	if err != nil {
		return nil, 0, err
	}

	return customers, total, nil
}

func (r *PostgresCustomerRepository) ListAll(ctx context.Context) ([]domain.Customer, error) {
	var customers []domain.Customer
	query := `SELECT id, code, name, community_id, sector_id, address, 
	          connection_type, tariff, meter_number,
	          latitude, longitude, initial_reading, service_status, service_status_changed_at
	          FROM customers WHERE deleted_at IS NULL ORDER BY code ASC`
	err := r.db.SelectContext(ctx, &customers, query)
	if err != nil {
		return nil, fmt.Errorf("error listing customers: %w", err)
	}
	return customers, nil
}

func (r *PostgresCustomerRepository) SaveBatch(ctx context.Context, customers []domain.Customer) error {
	query := `INSERT INTO customers (
				id, code, name, community_id, sector_id, address, connection_type, 
				tariff, meter_number, latitude, longitude, initial_reading
			  ) 
	          VALUES (
				:id, :code, :name, :community_id, :sector_id, :address, :connection_type, 
				:tariff, :meter_number, :latitude, :longitude, :initial_reading
			  ) 
	          ON CONFLICT (id) DO UPDATE SET 
	          code = EXCLUDED.code, name = EXCLUDED.name, community_id = EXCLUDED.community_id, 
	          sector_id = EXCLUDED.sector_id, address = EXCLUDED.address, connection_type = EXCLUDED.connection_type, 
	          tariff = EXCLUDED.tariff, meter_number = EXCLUDED.meter_number,
	          latitude = EXCLUDED.latitude, longitude = EXCLUDED.longitude, 
	          deleted_at = NULL`
	_, err := r.db.NamedExecContext(ctx, query, customers)
	return err
}

func (r *PostgresCustomerRepository) Save(ctx context.Context, c *domain.Customer) error {
	query := `INSERT INTO customers (
				id, code, name, community_id, sector_id, address, connection_type, 
				tariff, meter_number, latitude, longitude, initial_reading
			  ) 
	          VALUES (
				$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12
			  ) 
	          ON CONFLICT (id) DO UPDATE SET 
	          code = EXCLUDED.code, name = EXCLUDED.name, community_id = EXCLUDED.community_id, 
	          sector_id = EXCLUDED.sector_id, address = EXCLUDED.address, connection_type = EXCLUDED.connection_type, 
	          tariff = EXCLUDED.tariff, meter_number = EXCLUDED.meter_number,
	          latitude = EXCLUDED.latitude, longitude = EXCLUDED.longitude, 
	          deleted_at = NULL`
	_, err := r.db.ExecContext(ctx, query,
		c.ID, c.Code, c.Name, c.CommunityID, c.SectorID, c.Address, c.ConnectionType,
		c.Tariff, c.MeterNumber, c.Latitude, c.Longitude, c.InitialReading)
	return err
}

func (r *PostgresCustomerRepository) Delete(ctx context.Context, id string) error {
	query := `UPDATE customers SET deleted_at = NOW() WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, id)
	return err
}

func (r *PostgresCustomerRepository) CountBySector(ctx context.Context, sectorID string) (int, error) {
	var count int
	query := `SELECT COUNT(*) FROM customers WHERE sector_id = $1 AND deleted_at IS NULL`
	err := r.db.GetContext(ctx, &count, query, sectorID)
	fmt.Printf("📊 CountBySector: sector=%s, count=%d, err=%v\n", sectorID, count, err)
	return count, err
}

func (r *PostgresCustomerRepository) ListBySector(ctx context.Context, sectorID string) ([]domain.Customer, error) {
	var customers []domain.Customer
	query := `SELECT id, code, name, community_id, sector_id, address,
	          connection_type, tariff, meter_number,
	          latitude, longitude, initial_reading, service_status, service_status_changed_at
	          FROM customers
	          WHERE sector_id = $1 AND deleted_at IS NULL
	          ORDER BY name ASC, code ASC`
	err := r.db.SelectContext(ctx, &customers, query, sectorID)
	if err != nil {
		return nil, fmt.Errorf("error listing customers by sector: %w", err)
	}
	return customers, nil
}
