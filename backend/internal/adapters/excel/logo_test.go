package excel

import (
	"strings"
	"testing"
)

func TestTheLogoIsTheCompanysOrInvolts(t *testing.T) {
	cases := map[string]string{
		"companies/principal.png": "companies/principal.png",
		"companies/missing.png":   "involt.png",
		"":                        "involt.png",
	}
	for logo, want := range cases {
		got := (&book{logo: logo}).logoPath()
		if !strings.HasSuffix(got, want) {
			t.Errorf("logo %q -> %q, want …%s", logo, got, want)
		}
		if w, h := logoSize(got); w == 0 || h == 0 {
			t.Errorf("logo %q: size not readable", logo)
		}
	}
}
