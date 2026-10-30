package domain

import (
	"reflect"
	"testing"
)

func TestReceiptCopyLabels(t *testing.T) {
	cases := map[string][]string{
		"":          {"USUARIO", "ADMINISTRATIVO"}, // older rows keep today's behavior
		"DUPLICATE": {"USUARIO", "ADMINISTRATIVO"},
		"SINGLE":    {"USUARIO"},
		"UNKNOWN":   {"USUARIO", "ADMINISTRATIVO"},
	}
	for mode, want := range cases {
		if got := (Settings{ReceiptCopies: mode}).ReceiptCopyLabels(); !reflect.DeepEqual(got, want) {
			t.Fatalf("%q: labels = %v, want %v", mode, got, want)
		}
	}
}

func TestNormalizeReceiptCopies(t *testing.T) {
	if NormalizeReceiptCopies("SINGLE") != ReceiptCopiesSingle || NormalizeReceiptCopies("") != ReceiptCopiesDuplicate ||
		NormalizeReceiptCopies("x") != ReceiptCopiesDuplicate {
		t.Fatal("unexpected normalization")
	}
}
