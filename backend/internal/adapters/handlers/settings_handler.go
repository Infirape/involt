package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/infira/involt/backend/internal/adapters/repositories"
	"github.com/infira/involt/backend/internal/domain"
)

type SettingsHandler struct {
	repo *repositories.SettingsRepository
}

func NewSettingsHandler(repo *repositories.SettingsRepository) *SettingsHandler {
	return &SettingsHandler{repo: repo}
}

// GET /api/settings
func (h *SettingsHandler) GetSettings(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	settings, err := h.repo.Get(ctx)
	if err != nil || settings == nil {
		// Return default
		settings = &domain.Settings{
			ID:              "main",
			Municipalidad:   "MUNICIPALIDAD DISTRITAL DE CHETILLA",
			Empresa:         "HIDROELECTRICA QARWAQIRU MICHAY",
			DiasVencimiento: 15,
		}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(settings)
}

// PUT /api/settings
func (h *SettingsHandler) UpdateSettings(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	var settings domain.Settings
	if err := json.NewDecoder(r.Body).Decode(&settings); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	settings.ID = "main"
	settings.UpdatedAt = time.Now()

	if err := h.repo.Upsert(ctx, &settings); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(settings)
}
