package domain

import (
	"errors"
	"testing"
)

func TestParseServiceStatus(t *testing.T) {
	for _, raw := range []string{"ACTIVE", "TEMPORARY_CUT", "NO_POWER"} {
		if s, err := ParseServiceStatus(raw); err != nil || string(s) != raw {
			t.Fatalf("%s: %v %v", raw, s, err)
		}
	}
	if _, err := ParseServiceStatus("SUSPENDED"); !errors.Is(err, ErrInvalidServiceStatus) {
		t.Fatalf("unknown status err = %v", err)
	}
}

func TestServiceStatusChangeValidation(t *testing.T) {
	if err := ValidateServiceStatusChange(ServiceActive, ServiceTemporaryCut, "Deuda de 3 meses"); err != nil {
		t.Fatalf("valid change rejected: %v", err)
	}
	if err := ValidateServiceStatusChange(ServiceActive, ServiceTemporaryCut, "  "); !errors.Is(err, ErrInvalidServiceStatus) {
		t.Fatalf("missing reason err = %v", err)
	}
	if err := ValidateServiceStatusChange(ServiceNoPower, ServiceNoPower, "igual"); !errors.Is(err, ErrInvalidServiceStatus) {
		t.Fatalf("no-op change err = %v", err)
	}
}

func TestEffectiveServiceStatusDefaultsToActive(t *testing.T) {
	if got := (Customer{}).EffectiveServiceStatus(); got != ServiceActive {
		t.Fatalf("empty status = %q, want ACTIVE", got)
	}
	if got := (Customer{ServiceStatus: "NO_POWER"}).EffectiveServiceStatus(); got != ServiceNoPower {
		t.Fatalf("status = %q", got)
	}
}
