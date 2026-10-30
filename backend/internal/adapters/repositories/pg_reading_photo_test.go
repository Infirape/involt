package repositories

import (
	"context"
	"testing"
)

func TestSetPhotoURLAttachesAPhotoToAnExistingReading(t *testing.T) {
	db := openPaymentsTestDB(t)
	ctx := context.Background()
	db.MustExec(`INSERT INTO readings (id, customer_id, previous_value, current_value, consumption,
	               cargo_fijo, alumbrado_publico, saldo_redondeo, subtotal, total_to_pay, period)
	             VALUES ('read-photo', 'cust-1', 0, 10, 10, 0, 0, 0, 0, 0, '2026-05')`)
	repo := NewPostgresReadingRepository(db)

	if err := repo.SetPhotoURL(ctx, "read-photo", "uploads/1_m.jpg"); err != nil {
		t.Fatal(err)
	}
	var got string
	db.Get(&got, `SELECT photo_url FROM readings WHERE id = 'read-photo'`)
	if got != "uploads/1_m.jpg" {
		t.Fatalf("photo_url = %q", got)
	}
	if err := repo.SetPhotoURL(ctx, "missing", "uploads/x.jpg"); err == nil {
		t.Fatal("a missing reading must be an error, so the app retries later")
	}
}
