package repositories

import (
	"context"
	"sync"

	"github.com/infira/involt/backend/internal/domain"
)

type MemMetadataRepository struct {
	mu          sync.RWMutex
	communities map[string]domain.Community
	sectors     map[string]domain.Sector
}

func NewMemMetadataRepository() *MemMetadataRepository {
	repo := &MemMetadataRepository{
		communities: make(map[string]domain.Community),
		sectors:     make(map[string]domain.Sector),
	}
	repo.seed()
	return repo
}

func (r *MemMetadataRepository) seed() {
	r.communities["com-1"] = domain.Community{ID: "com-1", Name: "Comunidad Demo"}

	sectors := []string{"Sector Alto", "Sector Bajo", "Sector Centro", "Sector Norte", "Sector Sur"}
	for i, name := range sectors {
		id := "sec-" + string(rune('1'+i))
		r.sectors[id] = domain.Sector{
			ID:          id,
			CommunityID: "com-1",
			Name:        name,
		}
	}
}

func (r *MemMetadataRepository) ListCommunities(ctx context.Context) ([]domain.Community, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	res := make([]domain.Community, 0, len(r.communities))
	for _, c := range r.communities {
		res = append(res, c)
	}
	return res, nil
}

func (r *MemMetadataRepository) ListSectors(ctx context.Context) ([]domain.Sector, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	res := make([]domain.Sector, 0, len(r.sectors))
	for _, s := range r.sectors {
		res = append(res, s)
	}
	return res, nil
}

func (r *MemMetadataRepository) SaveCommunities(ctx context.Context, communities []domain.Community) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for _, c := range communities {
		r.communities[c.ID] = c
	}
	return nil
}

func (r *MemMetadataRepository) SaveSectors(ctx context.Context, sectors []domain.Sector) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for _, s := range sectors {
		r.sectors[s.ID] = s
	}
	return nil
}

func (r *MemMetadataRepository) DeleteSector(ctx context.Context, id string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	delete(r.sectors, id)
	return nil
}

func (r *MemMetadataRepository) DeleteCommunity(ctx context.Context, id string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	delete(r.communities, id)
	return nil
}

func (r *MemMetadataRepository) GetAppConfig(ctx context.Context) (*domain.AppConfig, error) {
	return &domain.AppConfig{}, nil
}

func (r *MemMetadataRepository) GetSettings(ctx context.Context) (*domain.Settings, error) {
	return &domain.Settings{}, nil
}

func (r *MemMetadataRepository) SaveSettings(ctx context.Context, settings *domain.Settings) error {
	return nil
}

// MoveSector reassigns the sector; the in-memory store keeps no supplies, so none move.
func (r *MemMetadataRepository) MoveSector(ctx context.Context, sectorID, communityID string) (int, error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	s, ok := r.sectors[sectorID]
	if !ok {
		return 0, domain.ErrSectorNotFound
	}
	if _, ok := r.communities[communityID]; !ok {
		return 0, domain.ErrCommunityNotFound
	}
	s.CommunityID = communityID
	r.sectors[sectorID] = s
	return 0, nil
}
