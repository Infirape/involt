package domain

import "errors"

var (
	ErrSectorNotFound    = errors.New("sector not found")
	ErrCommunityNotFound = errors.New("community not found")
)
