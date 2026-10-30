package auth

import (
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/infira/involt/backend/internal/domain"
)

type JWTService struct {
	secret []byte
}

func NewJWTService(secret string) *JWTService {
	return &JWTService{secret: []byte(secret)}
}

type Claims struct {
	UserID            string   `json:"user_id"`
	Email             string   `json:"email"`
	Role              string   `json:"role"`
	AssignedSectorIDs []string `json:"assigned_sector_ids"`
	CompanyID         string   `json:"company_id,omitempty"`
	jwt.RegisteredClaims
}

func (s *JWTService) GenerateToken(user *domain.User) (string, error) {
	claims := Claims{
		UserID:            user.ID,
		Email:             user.Email,
		Role:              string(user.Role),
		AssignedSectorIDs: user.AssignedSectorIDs,
		CompanyID:         user.CompanyID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(s.secret)
}

func (s *JWTService) ValidateToken(tokenStr string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(tokenStr, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return s.secret, nil
	})

	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(*Claims); ok && token.Valid {
		return claims, nil
	}

	return nil, fmt.Errorf("invalid token")
}
