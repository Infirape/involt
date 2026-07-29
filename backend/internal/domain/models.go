package domain

import "time"

// ConnectionType matches the electrical setup.
type ConnectionType string

const (
	ConnectionTypeMonofasica ConnectionType = "MONOFASICA"
	ConnectionTypeTrifasica  ConnectionType = "TRIFASICA"
)

// Settings contains municipalidad/empresa configuration.
type Settings struct {
	ID              string    `db:"id"`
	Municipalidad   string    `db:"municipalidad"`
	Empresa         string    `db:"empresa"`
	RUC             string    `db:"ruc"`
	Direccion       string    `db:"direccion"`
	Telefono        string    `db:"telefono"`
	Email           string    `db:"email"`
	DiasVencimiento int       `db:"dias_vencimiento"`
	TarifaKWh       float64   `db:"tarifa_kwh"`
	CargoFijo       float64   `db:"cargo_fijo"`
	Alumbrado       float64   `db:"alumbrado"`
	Mantenimiento   float64   `db:"mantenimiento"`
	IGV             bool      `db:"igv"`
	CreatedAt       time.Time `db:"created_at"`
	UpdatedAt       time.Time `db:"updated_at"`
}

// Community represents a village or Caserio.
type Community struct {
	ID            string `db:"id"`
	Name          string `db:"name"`
	CustomerCount int    `db:"customer_count"`
}

// Sector represents an area within a community.
type Sector struct {
	ID          string
	CommunityID string
	Name        string
}

// Customer contains the master data.
type Customer struct {
	ID               string         `db:"id"`
	Code             string         `db:"code"`
	Name             string         `db:"name"`
	CommunityID      string         `db:"community_id"`
	CommunityName    string         `db:"community_name"`
	SectorID         string         `db:"sector_id"`
	SectorName       string         `db:"sector_name"`
	Address         string         `db:"address"`
	ConnectionType  ConnectionType `db:"connection_type"`
	Tariff         float64        `db:"tariff"`
	MeterNumber    string         `db:"meter_number"`
	Latitude      float64        `db:"latitude"`
	Longitude     float64        `db:"longitude"`
	InitialReading float64      `db:"initial_reading"`
	LastReadingValue float64     `db:"last_reading_value"`
	ContractStart  time.Time    `db:"contract_start"`
}

// Reading represents a captured meter value.
type Reading struct {
	ID               string    `db:"id"`
	CustomerID       string    `db:"customer_id"`
	PreviousValue    float64   `db:"previous_value"`
	CurrentValue     float64   `db:"current_value"`
	Consumption      float64   `db:"consumption"`
	PhotoURL         string    `db:"photo_url"`
	Timestamp        time.Time `db:"timestamp"`
	Latitude         float64   `db:"latitude"`
	Longitude        float64   `db:"longitude"`

	// Period for the reading
	Period      string    `db:"period"`
	PeriodStart time.Time `db:"period_start"`
	PeriodEnd   time.Time `db:"period_end"`

	// Financial data for receipt consistency
	CargoFijo        float64 `db:"cargo_fijo"`
	AlumbradoPublico float64 `db:"alumbrado_publico"`
	Mantenimiento    float64 `db:"mantenimiento"`
	Adjustment       float64 `db:"adjustment"`
	Subtotal         float64 `db:"subtotal"`
	SaldoRedondeo    float64 `db:"saldo_redondeo"`
	RoundDifference  float64 `db:"round_difference"`
	TotalToPay       float64 `db:"total_to_pay"`
	PreviousBalance  float64 `db:"previous_balance"`
	OverdueTotal     float64 `db:"overdue_total"`
	ExpirationDate   time.Time `db:"expiration_date"`
	Observation      string    `db:"observation"`
	CustomerName     string    `db:"-"`
	IsPaid           bool      `db:"is_paid"`
	PaymentDate      *time.Time `db:"payment_date"`
}

// AppConfig contains remote configuration.
type AppConfig struct {
	ID             string `db:"id"`
	MapURLTemplate string `db:"map_url_template"`
	MapUserAgent   string `db:"map_user_agent"`
}
