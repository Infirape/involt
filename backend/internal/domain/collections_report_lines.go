package domain

import "time"

// CustomerLine is a supply (suministro) with its location, for exhaustive reports.
type CustomerLine struct {
	CustomerID    string `db:"customer_id"`
	CustomerCode  string `db:"customer_code"`
	CustomerName  string `db:"customer_name"`
	CommunityName string `db:"community_name"`
	SectorName    string `db:"sector_name"`
	ServiceStatus string `db:"service_status"`
	// ServiceStatusChangedAt is when the current status was set (nil = never changed).
	ServiceStatusChangedAt *time.Time `db:"service_status_changed_at"`
}

// PaymentLine is one non-voided payment allocation with its payment and customer context.
type PaymentLine struct {
	ReceiptNumber    int64     `db:"receipt_number"`
	PaidAt           time.Time `db:"paid_at"`
	Method           string    `db:"method"`
	CollectedByEmail string    `db:"collected_by_email"`
	CustomerCode     string    `db:"customer_code"`
	CustomerName     string    `db:"customer_name"`
	CommunityName    string    `db:"community_name"`
	SectorName       string    `db:"sector_name"`
	Period           string    `db:"period"`
	Amount           float64   `db:"amount"`
	LateFee          float64   `db:"late_fee"`
	ServiceStatus    string    `db:"service_status"`
}
