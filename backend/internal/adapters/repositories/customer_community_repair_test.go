package repositories

import (
	"os"
	"testing"
)

// The startup migration realigns supplies whose community drifted from their sector's.
func TestStartupRealignsCustomerCommunityWithSector(t *testing.T) {
	db := openPaymentsTestDB(t)
	db.MustExec(`INSERT INTO communities (id, name) VALUES ('com-2', 'Michay')`)
	db.MustExec(`UPDATE customers SET community_id = 'com-2' WHERE id = 'cust-1'`) // sec-1 is in com-1
	db.MustExec(`INSERT INTO customers (id, code, name, community_id, sector_id, connection_type, tariff, meter_number)
	             VALUES ('cust-free', 'X01', 'Sin caserío', 'com-2', NULL, 'RESIDENTIAL', 0.25, 'M-9')`)

	sql, err := os.ReadFile("../../../cmd/server/collections_schema.sql")
	if err != nil {
		t.Fatal(err)
	}
	db.MustExec(string(sql))

	var drifted, free string
	db.Get(&drifted, `SELECT community_id FROM customers WHERE id = 'cust-1'`)
	db.Get(&free, `SELECT community_id FROM customers WHERE id = 'cust-free'`)
	if drifted != "com-1" {
		t.Fatalf("drifted supply community = %q, want its sector's com-1", drifted)
	}
	if free != "com-2" {
		t.Fatalf("a supply without sector keeps its community, got %q", free)
	}
}
