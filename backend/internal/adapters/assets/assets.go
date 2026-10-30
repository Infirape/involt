// Package assets locates files in backend/assets (logos) from wherever the binary or tests run.
package assets

import "os"

var dirs = []string{
	"assets", "../assets", "../../assets", "../../../assets",
	"backend/assets", "../backend/assets", "../../backend/assets",
}

// Path returns the first existing location of an asset, or "" when it is missing.
func Path(name string) string {
	for _, d := range dirs {
		p := d + "/" + name
		if _, err := os.Stat(p); err == nil {
			return p
		}
	}
	return ""
}
