package domain

import (
	"time"

	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// MapProtoToReading converts a Protobuf reading to a Domain reading.
func MapProtoToReading(p *involtv1.Reading) *Reading {
	if p == nil {
		return nil
	}
	t, _ := parseTime(p.Timestamp)
	ps, _ := parseTime(p.PeriodStart)
	pe, _ := parseTime(p.PeriodEnd)
	ed, _ := parseTime(p.ExpirationDate)
	period := deriveReadingPeriod(p.Period, ps, t, p.Id)

	return &Reading{
		ID:               p.Id,
		CustomerID:       p.CustomerId,
		PreviousValue:    p.PreviousValue,
		CurrentValue:     p.CurrentValue,
		Consumption:      p.Consumption,
		PhotoURL:         p.PhotoUrl,
		Timestamp:        t,
		Latitude:         p.Latitude,
		Longitude:        p.Longitude,
		CargoFijo:        p.CargoFijo,
		AlumbradoPublico: p.AlumbradoPublico,
		SaldoRedondeo:    p.SaldoRedondeo,
		TotalToPay:       p.TotalToPay,
		PeriodStart:      ps,
		PeriodEnd:        pe,
		Mantenimiento:    p.Mantenimiento,
		Adjustment:       p.Adjustment,
		Subtotal:         p.Subtotal,
		RoundDifference:  p.RoundDifference,
		PreviousBalance:  p.PreviousBalance,
		OverdueTotal:     p.OverdueTotal,
		ExpirationDate:   ed,
		Period:           period,
		Observation:      p.Observation,
		CustomerName:     p.CustomerName,
		IsPaid:           p.IsPaid,
	}
}

// MapReadingToProto converts a Domain reading back to Protobuf.
func MapReadingToProto(d *Reading) *involtv1.Reading {
	if d == nil {
		return nil
	}
	period := deriveReadingPeriod(d.Period, d.PeriodStart, d.Timestamp, d.ID)

	return &involtv1.Reading{
		Id:               d.ID,
		CustomerId:       d.CustomerID,
		PreviousValue:    d.PreviousValue,
		CurrentValue:     d.CurrentValue,
		Consumption:      d.Consumption,
		PhotoUrl:         d.PhotoURL,
		Timestamp:        d.Timestamp.Format(time.RFC3339),
		Latitude:         d.Latitude,
		Longitude:        d.Longitude,
		CargoFijo:        d.CargoFijo,
		AlumbradoPublico: d.AlumbradoPublico,
		SaldoRedondeo:    d.SaldoRedondeo,
		TotalToPay:       d.TotalToPay,
		PeriodStart:      d.PeriodStart.Format(time.RFC3339),
		PeriodEnd:        d.PeriodEnd.Format(time.RFC3339),
		Mantenimiento:    d.Mantenimiento,
		Adjustment:       d.Adjustment,
		Subtotal:         d.Subtotal,
		RoundDifference:  d.RoundDifference,
		PreviousBalance:  d.PreviousBalance,
		OverdueTotal:     d.OverdueTotal,
		ExpirationDate:   d.ExpirationDate.Format(time.RFC3339),
		Period:           period,
		Observation:      d.Observation,
		CustomerName:     d.CustomerName,
		IsPaid:           d.IsPaid,
	}
}

func parseTime(s string) (time.Time, error) {
	if s == "" {
		return time.Time{}, nil
	}
	// Try multiple formats
	formats := []string{
		time.RFC3339,
		"2006-01-02T15:04:05.999999999Z07:00",
		"2006-01-02T15:04:05.999999999",
		"2006-01-02 15:04:05",
		time.RFC3339Nano,
	}
	for _, f := range formats {
		if t, err := time.Parse(f, s); err == nil {
			return t, nil
		}
	}
	return time.Parse(time.RFC3339, s) // Fallback to return original error if any
}

func deriveReadingPeriod(period string, periodStart time.Time, timestamp time.Time, id string) string {
	var result string
	if period != "" {
		result = period
	} else if !periodStart.IsZero() {
		result = periodStart.Format("2006-01")
	} else if len(id) >= len("2006-01") {
		suffix := id[len(id)-len("2006-01"):]
		if _, err := time.Parse("2006-01", suffix); err == nil {
			result = suffix
		} else if !timestamp.IsZero() {
			result = timestamp.Format("2006-01")
		}
	} else if !timestamp.IsZero() {
		result = timestamp.Format("2006-01")
	}

	return result
}

// MapProtoToCustomer converts a Protobuf customer to a Domain customer.
func MapProtoToCustomer(p *involtv1.Customer) *Customer {
	if p == nil {
		return nil
	}

	connType := ConnectionTypeMonofasica
	if p.ConnectionType == involtv1.ConnectionType_CONNECTION_TYPE_TRIFASICA {
		connType = ConnectionTypeTrifasica
	}

	cs, _ := time.Parse(time.RFC3339, p.ContractStart)

	return &Customer{
		ID:               p.Id,
		Code:             p.Code,
		Name:             p.Name,
		CommunityID:      p.CommunityId,
		SectorID:         p.SectorId,
		ConnectionType:   connType,
		Tariff:           p.Tariff,
		MeterNumber:      p.MeterNumber,
		Latitude:         p.Latitude,
		Longitude:        p.Longitude,
		InitialReading:   p.InitialReading,
		LastReadingValue: p.LastReadingValue,
		Address:          p.Address,
		ContractStart:    cs,
	}
}

// MapCustomerToProto converts a Domain customer to Protobuf.
func MapCustomerToProto(d *Customer) *involtv1.Customer {
	if d == nil {
		return nil
	}

	connType := involtv1.ConnectionType_CONNECTION_TYPE_MONOFASICA
	if d.ConnectionType == ConnectionTypeTrifasica {
		connType = involtv1.ConnectionType_CONNECTION_TYPE_TRIFASICA
	}

	status := involtv1.ServiceStatus_SERVICE_STATUS_ACTIVE
	switch d.EffectiveServiceStatus() {
	case ServiceTemporaryCut:
		status = involtv1.ServiceStatus_SERVICE_STATUS_TEMPORARY_CUT
	case ServiceNoPower:
		status = involtv1.ServiceStatus_SERVICE_STATUS_NO_POWER
	}
	changedAt := ""
	if d.ServiceStatusChangedAt != nil {
		changedAt = d.ServiceStatusChangedAt.Format(time.RFC3339)
	}

	return &involtv1.Customer{
		ServiceStatus:          status,
		ServiceStatusChangedAt: changedAt,
		Id:               d.ID,
		Code:             d.Code,
		Name:             d.Name,
		CommunityId:      d.CommunityID,
		SectorId:         d.SectorID,
		ConnectionType:   connType,
		Tariff:           d.Tariff,
		MeterNumber:      d.MeterNumber,
		Latitude:         d.Latitude,
		Longitude:        d.Longitude,
		InitialReading:   d.InitialReading,
		LastReadingValue: d.LastReadingValue,
		Address:          d.Address,
		ContractStart:    d.ContractStart.Format(time.RFC3339),
	}
}

// MapPeriodToProto converts a Domain period to Protobuf.
func MapPeriodToProto(d *Period) *involtv1.Period {
	if d == nil {
		return nil
	}
	status := involtv1.PeriodStatus_PERIOD_STATUS_UNSPECIFIED
	switch d.Status {
	case PeriodStatusOpen:
		status = involtv1.PeriodStatus_PERIOD_STATUS_OPEN
	case PeriodStatusClosed:
		status = involtv1.PeriodStatus_PERIOD_STATUS_CLOSED
	}

	return &involtv1.Period{
		Id:              d.ID,
		StartDate:       d.StartDate.Format("2006-01-02"),
		EndDate:         d.EndDate.Format("2006-01-02"),
		Status:          status,
		IsBillingPeriod: d.IsBillingPeriod,
	}
}
// MapUserToOperatorProto converts a Domain user to an Operator Protobuf.
func MapUserToOperatorProto(d *User) *involtv1.Operator {
	if d == nil {
		return nil
	}
	return &involtv1.Operator{
		Id:           d.ID,
		Email:        d.Email,
		PasswordHash: d.PasswordHash,
		Role:         string(d.Role),
	}
}
