package handlers

import (
	"context"
	"testing"

	"connectrpc.com/connect"

	"github.com/infira/involt/backend/internal/adapters/repositories"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/ports"
)

type savedCustomerStub struct {
	ports.CustomerRepository
	saved *domain.Customer
}

func (s *savedCustomerStub) Save(_ context.Context, c *domain.Customer) error {
	s.saved = c
	return nil
}

func TestUpsertCustomerTakesTheCommunityOfItsSector(t *testing.T) {
	meta := repositories.NewMemMetadataRepository()
	_ = meta.SaveCommunities(context.Background(), []domain.Community{{ID: "com-2", Name: "Michay"}})
	_, _ = meta.MoveSector(context.Background(), "sec-2", "com-2")
	customers := &savedCustomerStub{}
	h := &AdminHandler{metaRepo: meta, customerRepo: customers}

	// The client says com-1, but sec-2 now belongs to com-2: reports group by the supply's
	// community, so it must follow the sector.
	resp, err := h.UpsertCustomer(authenticatedTestContext(), connect.NewRequest(&involtv1.UpsertCustomerRequest{
		Customer: &involtv1.Customer{Code: "CAD001", Name: "Ana", SectorId: "sec-2", CommunityId: "com-1"},
	}))
	if err != nil {
		t.Fatalf("UpsertCustomer: %v", err)
	}
	if customers.saved.CommunityID != "com-2" || resp.Msg.Customer.CommunityId != "com-2" {
		t.Fatalf("saved community = %q (response %q), want the sector's com-2",
			customers.saved.CommunityID, resp.Msg.Customer.CommunityId)
	}

	if _, err := h.UpsertCustomer(authenticatedTestContext(), connect.NewRequest(&involtv1.UpsertCustomerRequest{
		Customer: &involtv1.Customer{Code: "X1", Name: "Sin caserío", SectorId: "nope", CommunityId: "com-1"},
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("unknown sector err = %v, want InvalidArgument", err)
	}
}
