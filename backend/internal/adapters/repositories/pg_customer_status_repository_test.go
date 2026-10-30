package repositories

import (
	"context"
	"errors"
	"testing"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

func TestCustomerStatusLifecycle(t *testing.T) {
	db := openPaymentsTestDB(t)
	repo := NewPostgresCustomerStatusRepository(db)
	customers := NewPostgresCustomerRepository(db)
	ctx := context.Background()

	change, err := repo.SetStatus(ctx, "cust-1", domain.ServiceTemporaryCut, "Deuda de 3 meses", "admin-1", "admin@infira.pe")
	if err != nil {
		t.Fatalf("SetStatus: %v", err)
	}
	if change.PreviousStatus != "ACTIVE" || change.Status != "TEMPORARY_CUT" || change.ChangedAt.IsZero() {
		t.Fatalf("change = %+v", change)
	}
	c, err := customers.GetByID(ctx, "cust-1")
	if err != nil {
		t.Fatalf("GetByID: %v", err)
	}
	if c.ServiceStatus != "TEMPORARY_CUT" || c.ServiceStatusChangedAt == nil {
		t.Fatalf("customer status not persisted: %+v", c)
	}

	if _, err := repo.SetStatus(ctx, "cust-1", domain.ServiceTemporaryCut, "otra vez", "admin-1", ""); !errors.Is(err, domain.ErrInvalidServiceStatus) {
		t.Fatalf("no-op change err = %v", err)
	}
	if _, err := repo.SetStatus(ctx, "ghost", domain.ServiceNoPower, "x", "admin-1", ""); err == nil {
		t.Fatal("unknown customer should fail")
	}
	if _, err := repo.SetStatus(ctx, "cust-1", domain.ServiceActive, "Pagó la deuda", "admin-1", ""); err != nil {
		t.Fatalf("reconnect: %v", err)
	}

	history, err := repo.History(ctx, "cust-1")
	if err != nil {
		t.Fatalf("History: %v", err)
	}
	if len(history) != 2 || history[0].Status != "ACTIVE" || history[1].Reason != "Deuda de 3 meses" {
		t.Fatalf("history should be newest first: %+v", history)
	}
}

func TestCountByStatusAndListFilter(t *testing.T) {
	db := openPaymentsTestDB(t)
	db.MustExec(`INSERT INTO customers (id, code, name, community_id, sector_id, connection_type, tariff, meter_number)
	             VALUES ('cust-2', 'CHE002', 'Beto Sol', 'com-1', 'sec-1', 'RESIDENTIAL', 0.25, 'M-2')`)
	repo := NewPostgresCustomerStatusRepository(db)
	ctx := context.Background()
	if _, err := repo.SetStatus(ctx, "cust-2", domain.ServiceNoPower, "Medidor quemado", "admin", ""); err != nil {
		t.Fatalf("SetStatus: %v", err)
	}

	counts, err := repo.CountByStatus(ctx, ports.ReceiptLineFilter{SectorID: "sec-1"})
	if err != nil {
		t.Fatalf("CountByStatus: %v", err)
	}
	if counts[domain.ServiceActive] != 1 || counts[domain.ServiceNoPower] != 1 || counts[domain.ServiceTemporaryCut] != 0 {
		t.Fatalf("counts = %+v", counts)
	}

	list, total, err := NewPostgresCustomerRepository(db).List(ctx, nil, "", 10, 0, "", "", "NO_POWER")
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if total != 1 || list[0].ID != "cust-2" || list[0].ServiceStatus != "NO_POWER" {
		t.Fatalf("status filter = %d %+v", total, list)
	}
}

func TestCustomerSaveKeepsServiceStatus(t *testing.T) {
	db := openPaymentsTestDB(t)
	customers := NewPostgresCustomerRepository(db)
	status := NewPostgresCustomerStatusRepository(db)
	ctx := context.Background()

	if _, err := status.SetStatus(ctx, "cust-1", domain.ServiceNoPower, "Medidor quemado", "admin", ""); err != nil {
		t.Fatalf("SetStatus: %v", err)
	}
	c, _ := customers.GetByID(ctx, "cust-1")
	c.Name = "Ana Luz Editada"
	if err := customers.Save(ctx, c); err != nil {
		t.Fatalf("Save must keep working with the new columns: %v", err)
	}
	if err := customers.SaveBatch(ctx, []domain.Customer{*c, {ID: "cust-new", Code: "CHE009", Name: "Nuevo", CommunityID: "com-1", SectorID: "sec-1", ConnectionType: "RESIDENTIAL", MeterNumber: "M-9"}}); err != nil {
		t.Fatalf("SaveBatch: %v", err)
	}
	got, _ := customers.GetByID(ctx, "cust-1")
	if got.Name != "Ana Luz Editada" || got.ServiceStatus != "NO_POWER" {
		t.Fatalf("editing a customer must not reset its service status: %+v", got)
	}
	created, _ := customers.GetByID(ctx, "cust-new")
	if created.EffectiveServiceStatus() != domain.ServiceActive {
		t.Fatalf("new customers start with service: %+v", created)
	}
}
