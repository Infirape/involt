package handlers

import (
	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

// reportScope restricts non-admin users to their assigned sectors.
func reportScope(user *auth.UserContext) ports.ReceiptLineFilter {
	if user.Role == string(domain.RoleAdmin) {
		return ports.ReceiptLineFilter{}
	}
	allowed := append([]string{}, user.AssignedSectorIDs...)
	return ports.ReceiptLineFilter{AllowedSectorIDs: allowed}
}

func cutThresholdOrDefault(v int32) int {
	if v <= 0 {
		return defaultCutThreshold
	}
	return int(v)
}
