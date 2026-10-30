package handlers

import (
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"connectrpc.com/connect"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

func TestUploadPhotoAttachesItToItsReadingAndStaysInUploads(t *testing.T) {
	dir := t.TempDir()
	old := uploadsDir
	uploadsDir = filepath.Join(dir, "uploads")
	t.Cleanup(func() { uploadsDir = old })

	readings := &collectionsReadingRepoStub{}
	h := &SyncHandler{readingRepo: readings}

	resp, err := h.UploadPhoto(context.Background(), connect.NewRequest(&involtv1.UploadPhotoRequest{
		FileName:  "../../etc/passwd",
		Data:      []byte{1, 2, 3},
		ReadingId: "read-1",
	}))
	if err != nil {
		t.Fatal(err)
	}
	url := resp.Msg.Url
	if !strings.HasPrefix(url, filepath.ToSlash(uploadsDir)+"/") || !strings.HasSuffix(url, "_passwd") {
		t.Fatalf("photo saved at %q, want it inside %s", url, uploadsDir)
	}
	if data, err := os.ReadFile(url); err != nil || len(data) != 3 {
		t.Fatalf("saved photo = %v, %v", data, err)
	}
	if !resp.Msg.Attached {
		t.Fatal("the response must confirm the photo is attached")
	}
	if readings.photos["read-1"] != url {
		t.Fatalf("reading photo = %q, want %q", readings.photos["read-1"], url)
	}
}

func TestUploadPhotoWithoutReadingOnlySavesTheFile(t *testing.T) {
	old := uploadsDir
	uploadsDir = t.TempDir()
	t.Cleanup(func() { uploadsDir = old })

	readings := &collectionsReadingRepoStub{}
	h := &SyncHandler{readingRepo: readings}
	if _, err := h.UploadPhoto(context.Background(), connect.NewRequest(&involtv1.UploadPhotoRequest{
		FileName: "m.jpg", Data: []byte{1},
	})); err != nil {
		t.Fatal(err)
	}
	if len(readings.photos) != 0 {
		t.Fatalf("no reading must change, got %v", readings.photos)
	}
}
