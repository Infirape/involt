package auth

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/infira/involt/backend/internal/domain"
)

func TestIdentifyHTTPCarriesTheCompanyFromTheToken(t *testing.T) {
	svc := NewJWTService("secret")
	token, err := svc.GenerateToken(&domain.User{ID: "u1", Role: domain.RoleAdmin, CompanyID: "acme"})
	if err != nil {
		t.Fatal(err)
	}

	var got *UserContext
	h := IdentifyHTTP(svc, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		got, _ = GetUserFromContext(r.Context())
	}))

	h.ServeHTTP(httptest.NewRecorder(), httptest.NewRequest(http.MethodGet, "/x?token="+token, nil))
	if got == nil || got.ID != "u1" || got.CompanyID != "acme" {
		t.Fatalf("user from ?token = %+v", got)
	}

	req := httptest.NewRequest(http.MethodGet, "/x", nil)
	req.Header.Set("Authorization", "Bearer "+token)
	got = nil
	h.ServeHTTP(httptest.NewRecorder(), req)
	if got == nil || got.CompanyID != "acme" {
		t.Fatalf("user from Bearer header = %+v", got)
	}

	got = nil
	h.ServeHTTP(httptest.NewRecorder(), httptest.NewRequest(http.MethodGet, "/x?token=bad", nil))
	if got != nil {
		t.Fatalf("an invalid token must not identify anyone, got %+v", got)
	}
}
