package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// ServiceStatus is whether a supply currently has electricity. Only admins change it.
type ServiceStatus string

const (
	ServiceActive       ServiceStatus = "ACTIVE"        // con servicio
	ServiceTemporaryCut ServiceStatus = "TEMPORARY_CUT" // corte temporal (p. ej. por deuda)
	ServiceNoPower      ServiceStatus = "NO_POWER"      // sin energía (avería, retiro, baja)
)

var ErrInvalidServiceStatus = errors.New("invalid service status change")

func ParseServiceStatus(raw string) (ServiceStatus, error) {
	switch s := ServiceStatus(raw); s {
	case ServiceActive, ServiceTemporaryCut, ServiceNoPower:
		return s, nil
	}
	return "", fmt.Errorf("%w: unknown status %q", ErrInvalidServiceStatus, raw)
}

// ValidateServiceStatusChange requires a real change and a written reason (audit trail).
func ValidateServiceStatusChange(from, to ServiceStatus, reason string) error {
	if from == to {
		return fmt.Errorf("%w: the supply is already in status %s", ErrInvalidServiceStatus, to)
	}
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: a reason is required", ErrInvalidServiceStatus)
	}
	return nil
}

// EffectiveServiceStatus treats rows without status (older databases) as active.
func (c Customer) EffectiveServiceStatus() ServiceStatus {
	if c.ServiceStatus == "" {
		return ServiceActive
	}
	return ServiceStatus(c.ServiceStatus)
}

// ServiceStatusChange is one entry of a supply's status history.
type ServiceStatusChange struct {
	ID             string    `db:"id"`
	CustomerID     string    `db:"customer_id"`
	PreviousStatus string    `db:"previous_status"`
	Status         string    `db:"status"`
	Reason         string    `db:"reason"`
	ChangedBy      string    `db:"changed_by"`
	ChangedByEmail string    `db:"changed_by_email"`
	ChangedAt      time.Time `db:"changed_at"`
}
