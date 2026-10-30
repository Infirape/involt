package domain

import "time"

// DefaultBrandName is shown when a user has no company (or before login).
const DefaultBrandName = "InVolt"

// DefaultLogo is the InVolt logo, relative to the backend assets directory.
const DefaultLogo = "involt.png"

// Company is the client organisation a user works for; it owns the brand shown in the apps
// and printed on documents.
type Company struct {
	ID        string    `db:"id"`
	Name      string    `db:"name"`   // e.g. the utility or company name
	Entity    string    `db:"entity"` // e.g. the municipality that runs it; may be empty
	Logo      string    `db:"logo"`   // path relative to the assets directory; empty = InVolt logo
	CreatedAt time.Time `db:"created_at"`
	UpdatedAt time.Time `db:"updated_at"`
}
