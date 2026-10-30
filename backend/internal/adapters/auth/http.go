package auth

import (
	"net/http"
	"strings"
)

// IdentifyHTTP puts the user of a valid token (?token= or Bearer header) in the request context.
// It never rejects: the REST handlers keep doing their own authorization.
func IdentifyHTTP(jwtService *JWTService, next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token := r.URL.Query().Get("token")
		if token == "" {
			token = strings.TrimPrefix(r.Header.Get("Authorization"), "Bearer ")
		}
		if token != "" {
			if claims, err := jwtService.ValidateToken(token); err == nil {
				r = r.WithContext(WithClaims(r.Context(), claims))
			}
		}
		next.ServeHTTP(w, r)
	})
}
