package handlers

import (
	"context"
	"errors"
	"fmt"

	"connectrpc.com/connect"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// MoveSector moves a sector (caserío) and all its supplies to another community. Admins only.
func (h *AdminHandler) MoveSector(
	ctx context.Context,
	req *connect.Request[involtv1.MoveSectorRequest],
) (*connect.Response[involtv1.MoveSectorResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok || user.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can manage sectors"))
	}
	if req.Msg.SectorId == "" || req.Msg.CommunityId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("sector_id and community_id are required"))
	}
	moved, err := h.metaRepo.MoveSector(ctx, req.Msg.SectorId, req.Msg.CommunityId)
	switch {
	case errors.Is(err, domain.ErrSectorNotFound), errors.Is(err, domain.ErrCommunityNotFound):
		return nil, connect.NewError(connect.CodeNotFound, err)
	case err != nil:
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&involtv1.MoveSectorResponse{MovedCustomers: int32(moved)}), nil
}

// sectorCommunity returns the community a sector belongs to (InvalidArgument if unknown).
func (h *AdminHandler) sectorCommunity(ctx context.Context, sectorID string) (string, error) {
	sectors, err := h.metaRepo.ListSectors(ctx)
	if err != nil {
		return "", connect.NewError(connect.CodeInternal, err)
	}
	for _, s := range sectors {
		if s.ID == sectorID {
			return s.CommunityID, nil
		}
	}
	return "", connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("unknown sector %q", sectorID))
}
