package auth

import (
	"context"
	"strings"

	"connectrpc.com/connect"
)

type contextKey string

const (
	UserContextKey contextKey = "user"
)

// UserContext contains the authenticated user information from the token
type UserContext struct {
	ID                string
	Email             string
	Role              string
	AssignedSectorIDs []string
	CompanyID         string
}

// NewAuthInterceptor creates a new ConnectRPC interceptor for JWT validation
func NewAuthInterceptor(jwtService *JWTService) connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			// Skip auth for Login method
			if strings.HasSuffix(req.Spec().Procedure, "/Login") {
				return next(ctx, req)
			}

			authHeader := req.Header().Get("Authorization")
			if authHeader == "" {
				return nil, connect.NewError(connect.CodeUnauthenticated, nil)
			}

			tokenParts := strings.Split(authHeader, " ")
			if len(tokenParts) != 2 || tokenParts[0] != "Bearer" {
				return nil, connect.NewError(connect.CodeUnauthenticated, nil)
			}

			claims, err := jwtService.ValidateToken(tokenParts[1])
			if err != nil {
				return nil, connect.NewError(connect.CodeUnauthenticated, err)
			}

			return next(WithClaims(ctx, claims), req)
		}
	}
}

// GetUserFromContext retrieves the UserContext from the context
func GetUserFromContext(ctx context.Context) (*UserContext, bool) {
	user, ok := ctx.Value(UserContextKey).(*UserContext)
	return user, ok
}

// WithClaims stores the authenticated user from a validated token in the context.
func WithClaims(ctx context.Context, claims *Claims) context.Context {
	return context.WithValue(ctx, UserContextKey, &UserContext{
		ID:                claims.UserID,
		Email:             claims.Email,
		Role:              claims.Role,
		AssignedSectorIDs: claims.AssignedSectorIDs,
		CompanyID:         claims.CompanyID,
	})
}
