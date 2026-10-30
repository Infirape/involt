package main

import (
	"os"
	"path/filepath"
	"testing"
)

func TestResolveAssetsDir(t *testing.T) {
	originalWD, err := os.Getwd()
	if err != nil {
		t.Fatalf("failed to get cwd: %v", err)
	}
	t.Cleanup(func() { _ = os.Chdir(originalWD) })

	t.Run("serves the backend assets when running from /backend", func(t *testing.T) {
		tmp := t.TempDir()
		work := filepath.Join(tmp, "backend")
		for _, dir := range []string{filepath.Join(tmp, "assets"), filepath.Join(work, "assets")} {
			if err := os.MkdirAll(dir, 0o755); err != nil {
				t.Fatalf("failed to create %s: %v", dir, err)
			}
		}
		if err := os.Chdir(work); err != nil {
			t.Fatalf("failed to chdir: %v", err)
		}

		got := resolveAssetsDir()
		if got != "assets" {
			t.Fatalf("expected assets, got %s", got)
		}
	})

	t.Run("serves backend/assets when running from the project root", func(t *testing.T) {
		tmp := t.TempDir()
		for _, dir := range []string{filepath.Join(tmp, "assets"), filepath.Join(tmp, "backend", "assets")} {
			if err := os.MkdirAll(dir, 0o755); err != nil {
				t.Fatalf("failed to create %s: %v", dir, err)
			}
		}
		if err := os.Chdir(tmp); err != nil {
			t.Fatalf("failed to chdir: %v", err)
		}

		got := resolveAssetsDir()
		if got != "backend/assets" {
			t.Fatalf("expected backend/assets, got %s", got)
		}
	})
}
