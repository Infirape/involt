package domain

import "time"

type UserRole string

const (
	RoleAdmin      UserRole = "ADMIN"
	RoleSupervisor UserRole = "SUPERVISOR"
	RoleReader     UserRole = "READER"
)

type User struct {
	ID                string     `db:"id"`
	Email             string     `db:"email"`
	PasswordHash      string     `db:"password_hash"`
	Role              UserRole   `db:"role"`
	AssignedSectorIDs []string   `db:"-"` // Handled separately or via join
	CompanyID         string     `db:"company_id"` // empty when the user has no company
	Company           *Company   `db:"-"`
	CreatedAt         time.Time  `db:"created_at"`
	UpdatedAt         time.Time  `db:"updated_at"`
}
