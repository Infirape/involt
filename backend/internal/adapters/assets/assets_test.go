package assets

import "testing"

func TestPathFindsTheLogosAndReportsMissingFiles(t *testing.T) {
	for _, name := range []string{"logo_chetilla.png", "logo_chetilla_small.png"} {
		if Path(name) == "" {
			t.Fatalf("%s not found", name)
		}
	}
	if Path("nope.png") != "" {
		t.Fatal("missing assets must return an empty path")
	}
}
