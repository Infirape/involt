package assets

import "testing"

func TestPathFindsTheLogosAndReportsMissingFiles(t *testing.T) {
	for _, name := range []string{"involt.png", "companies/principal.png"} {
		if Path(name) == "" {
			t.Fatalf("%s not found", name)
		}
	}
	if Path("nope.png") != "" {
		t.Fatal("missing assets must return an empty path")
	}
}
