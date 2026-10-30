package handlers

import (
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// companyToProto maps a user's company; nil when the user has none (the apps show InVolt).
func companyToProto(c *domain.Company) *involtv1.Company {
	if c == nil {
		return nil
	}
	return &involtv1.Company{Id: c.ID, Name: c.Name, Entity: c.Entity, Logo: c.Logo}
}
