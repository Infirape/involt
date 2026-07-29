package handlers

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"strings"
	"time"
	"archive/zip"
	"bytes"
	"math"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/gen/involt/v1/involtv1connect"
	"github.com/infira/involt/backend/internal/ports"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

type AdminHandler struct {
	adminRepo    ports.AdminRepository
	metaRepo     ports.MetadataRepository
	customerRepo ports.CustomerRepository
	readingRepo  ports.ReadingRepository
	periodRepo   ports.PeriodRepository
	jwtService   *auth.JWTService
	pdfGen       ports.ReceiptGenerator
}

func NewAdminHandler(
	adminRepo ports.AdminRepository,
	metaRepo ports.MetadataRepository,
	customerRepo ports.CustomerRepository,
	readingRepo ports.ReadingRepository,
	periodRepo ports.PeriodRepository,
	jwtSecret string,
	pdfGen ports.ReceiptGenerator,
) *AdminHandler {
	return &AdminHandler{
		adminRepo:    adminRepo,
		metaRepo:     metaRepo,
		customerRepo: customerRepo,
		readingRepo:  readingRepo,
		periodRepo:   periodRepo,
		jwtService:   auth.NewJWTService(jwtSecret),
		pdfGen:       pdfGen,
	}
}

func (h *AdminHandler) Login(
	ctx context.Context,
	req *connect.Request[involtv1.LoginRequest],
) (*connect.Response[involtv1.LoginResponse], error) {
	user, err := h.adminRepo.GetUserByEmail(ctx, req.Msg.Email)
	if err != nil {
		return nil, connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("invalid credentials"))
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Msg.Password))
	if err != nil {
		return nil, connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("invalid credentials"))
	}

	token, err := h.jwtService.GenerateToken(user)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to generate token"))
	}

	return connect.NewResponse(&involtv1.LoginResponse{
		Token: token,
		User: &involtv1.User{
			Id:                user.ID,
			Email:             user.Email,
			Role:              mapDomainRoleToProto(user.Role),
			AssignedSectorIds: user.AssignedSectorIDs,
		},
	}), nil
}

func (h *AdminHandler) GetUsers(
	ctx context.Context,
	req *connect.Request[involtv1.GetUsersRequest],
) (*connect.Response[involtv1.GetUsersResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can list users"))
	}
	users, err := h.adminRepo.ListUsers(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &involtv1.GetUsersResponse{
		Users: make([]*involtv1.User, len(users)),
	}
	for i, u := range users {
		resp.Users[i] = &involtv1.User{
			Id:                u.ID,
			Email:             u.Email,
			Role:              mapDomainRoleToProto(u.Role),
			AssignedSectorIds: u.AssignedSectorIDs,
		}
	}

	return connect.NewResponse(resp), nil
}

func (h *AdminHandler) UpsertUser(
	ctx context.Context,
	req *connect.Request[involtv1.UpsertUserRequest],
) (*connect.Response[involtv1.UpsertUserResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can manage users"))
	}
	u := req.Msg.User
	if u.Email == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("email is required"))
	}

	// Map proto to domain
	domainUser := &domain.User{
		ID:                u.Id,
		Email:             u.Email,
		Role:              mapProtoRoleToDomain(u.Role),
		AssignedSectorIDs: u.AssignedSectorIds,
	}

	if domainUser.ID == "" {
		domainUser.ID = uuid.New().String()
	}

	if req.Msg.Password != "" {
		hash, err := bcrypt.GenerateFromPassword([]byte(req.Msg.Password), bcrypt.DefaultCost)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		domainUser.PasswordHash = string(hash)
	} else if u.Id != "" {
		// If editing and no password provided, keep existing
		existing, err := h.adminRepo.GetUserByID(ctx, u.Id)
		if err == nil {
			domainUser.PasswordHash = existing.PasswordHash
		}
	}

	err := h.adminRepo.UpsertUser(ctx, domainUser)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.UpsertUserResponse{
		User: &involtv1.User{
			Id:                domainUser.ID,
			Email:             domainUser.Email,
			Role:              u.Role,
			AssignedSectorIds: domainUser.AssignedSectorIDs,
		},
	}), nil
}

func (h *AdminHandler) GetSectors(
	ctx context.Context,
	req *connect.Request[involtv1.GetSectorsRequest],
) (*connect.Response[involtv1.GetSectorsResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, nil)
	}

	sectors, err := h.metaRepo.ListSectors(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Filter sectors if not ADMIN
	var filtered []domain.Sector
	if user.Role == string(domain.RoleAdmin) {
		filtered = sectors
	} else {
		for _, s := range sectors {
			if contains(user.AssignedSectorIDs, s.ID) {
				filtered = append(filtered, s)
			}
		}
	}

	resp := &involtv1.GetSectorsResponse{
		Sectors: make([]*involtv1.Sector, len(filtered)),
	}
	for i, s := range filtered {
		resp.Sectors[i] = &involtv1.Sector{
			Id:          s.ID,
			CommunityId: s.CommunityID,
			Name:        s.Name,
		}
	}

	return connect.NewResponse(resp), nil
}

func (h *AdminHandler) UpsertSector(
	ctx context.Context,
	req *connect.Request[involtv1.UpsertSectorRequest],
) (*connect.Response[involtv1.UpsertSectorResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can manage sectors"))
	}

	s := req.Msg.Sector
	if s.Name == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("sector name is required"))
	}

	domainSector := domain.Sector{
		ID:          s.Id,
		CommunityID: s.CommunityId,
		Name:        s.Name,
	}

	if domainSector.ID == "" {
		domainSector.ID = uuid.New().String()
	}

	// SaveSectors takes a slice
	err := h.metaRepo.SaveSectors(ctx, []domain.Sector{domainSector})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.UpsertSectorResponse{
		Sector: &involtv1.Sector{
			Id:          domainSector.ID,
			CommunityId: domainSector.CommunityID,
			Name:        domainSector.Name,
		},
	}), nil
}

func (h *AdminHandler) GetCommunities(
	ctx context.Context,
	req *connect.Request[involtv1.GetCommunitiesRequest],
) (*connect.Response[involtv1.GetCommunitiesResponse], error) {
	communities, err := h.metaRepo.ListCommunities(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &involtv1.GetCommunitiesResponse{
		Communities: make([]*involtv1.Community, len(communities)),
	}
	for i, c := range communities {
		resp.Communities[i] = &involtv1.Community{
			Id:            c.ID,
			Name:          c.Name,
			CustomerCount: uint32(c.CustomerCount),
		}
	}

	return connect.NewResponse(resp), nil
}

func (h *AdminHandler) UpsertCommunity(
	ctx context.Context,
	req *connect.Request[involtv1.UpsertCommunityRequest],
) (*connect.Response[involtv1.UpsertCommunityResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can manage communities"))
	}

	c := req.Msg.Community
	if c.Name == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("community name is required"))
	}

	domainCommunity := domain.Community{
		ID:   c.Id,
		Name: c.Name,
	}

	if domainCommunity.ID == "" {
		domainCommunity.ID = uuid.New().String()
	}

	err := h.metaRepo.SaveCommunities(ctx, []domain.Community{domainCommunity})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.UpsertCommunityResponse{
		Community: &involtv1.Community{
			Id:   domainCommunity.ID,
			Name: domainCommunity.Name,
		},
	}), nil
}

func (h *AdminHandler) GetCustomers(
	ctx context.Context,
	req *connect.Request[involtv1.GetCustomersRequest],
) (*connect.Response[involtv1.GetCustomersResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, nil)
	}

	pageSize := req.Msg.PageSize
	if pageSize <= 0 {
		pageSize = 20
	}
	offset := (req.Msg.PageNumber - 1) * pageSize
	if offset < 0 {
		offset = 0
	}

	var allowedSectors []string
	if user.Role != string(domain.RoleAdmin) {
		if req.Msg.SectorId != "" {
			if !contains(user.AssignedSectorIDs, req.Msg.SectorId) {
				return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("sector not assigned"))
			}
			allowedSectors = []string{req.Msg.SectorId}
		} else {
			allowedSectors = user.AssignedSectorIDs
		}
	} else if req.Msg.SectorId != "" {
		allowedSectors = []string{req.Msg.SectorId}
	}

	log.Printf("🔍 Admin: GetCustomers (Sector: %s, Community: %s, Search: %s, ExcludePeriod: %s)", req.Msg.SectorId, req.Msg.CommunityId, req.Msg.SearchQuery, req.Msg.ExcludePeriodId)
	customers, total, err := h.customerRepo.List(ctx, allowedSectors, req.Msg.SearchQuery, int(pageSize), int(offset), req.Msg.ExcludePeriodId, req.Msg.CommunityId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &involtv1.GetCustomersResponse{
		Customers:  make([]*involtv1.Customer, len(customers)),
		TotalCount: int32(total),
	}
	for i, c := range customers {
		resp.Customers[i] = &involtv1.Customer{
			Id:               c.ID,
			Code:             c.Code,
			Name:             c.Name,
			CommunityId:      c.CommunityID,
			SectorId:         c.SectorID,
			Address:          c.Address,
			ConnectionType:   mapDomainConnectionTypeToProto(c.ConnectionType),
			Tariff:           c.Tariff,
			MeterNumber:      c.MeterNumber,
			Latitude:         c.Latitude,
			Longitude:        c.Longitude,
			InitialReading:   0, // Always 0, calculated from reading history
			LastReadingValue: c.LastReadingValue,
		}
	}

	return connect.NewResponse(resp), nil
}

func contains(slice []string, item string) bool {
	for _, s := range slice {
		if s == item {
			return true
		}
	}
	return false
}

func (h *AdminHandler) GetReadings(
	ctx context.Context,
	req *connect.Request[involtv1.GetReadingsRequest],
) (*connect.Response[involtv1.GetReadingsResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, nil)
	}

	pageSize := req.Msg.PageSize
	if pageSize <= 0 {
		pageSize = 20
	}
	offset := (req.Msg.PageNumber - 1) * pageSize
	if offset < 0 {
		offset = 0
	}

	sectorID := req.Msg.SectorId
	if user.Role != string(domain.RoleAdmin) {
		if sectorID != "" {
			allowed := false
			for _, id := range user.AssignedSectorIDs {
				if id == sectorID {
					allowed = true
					break
				}
			}
			if !allowed {
				return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("sector not assigned"))
			}
		} else {
			// If non-admin and no sector selected, we MUST force filtering by assigned sectors.
			// However, since Repo.List currently takes a single string, we'll return an error 
			// or default to the first assigned sector if available.
			if len(user.AssignedSectorIDs) > 0 {
				sectorID = user.AssignedSectorIDs[0]
			} else {
				return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("no assigned sectors"))
			}
		}
	}

	readings, total, err := h.readingRepo.List(ctx, req.Msg.CustomerId, sectorID, req.Msg.Period, int(pageSize), int(offset))
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	settings, _ := h.metaRepo.GetSettings(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}

	customers, _ := h.customerRepo.ListAll(ctx)
	custMap := make(map[string]string)
	for _, c := range customers {
		custMap[c.ID] = c.Name
	}

	resp := &involtv1.GetReadingsResponse{
		Readings:   make([]*involtv1.Reading, len(readings)),
		TotalCount: int32(total),
	}

	for i, r := range readings {
		r.CustomerName = custMap[r.CustomerID]
		// If total is 0 but there is consumption, try to recalculate for display
		if r.TotalToPay == 0 && r.Consumption > 0 {
			consumptionCharge := r.Consumption * safeFloat(settings.TarifaKWh)
			cargoFijo := 0.0
			alumbrado := 0.0
			mantenimiento := 0.0

			if p, err := h.periodRepo.GetByID(ctx, r.Period); err == nil && p != nil {
				if p.IsBillingPeriod {
					cargoFijo = safeFloat(settings.CargoFijo)
					alumbrado = safeFloat(settings.Alumbrado)
					mantenimiento = safeFloat(settings.Mantenimiento)
				}
			}

			r.Subtotal = consumptionCharge + cargoFijo + alumbrado + mantenimiento
			r.TotalToPay = r.Subtotal + r.SaldoRedondeo
			r.CargoFijo = cargoFijo
			r.AlumbradoPublico = alumbrado
			r.Mantenimiento = mantenimiento
		}
		resp.Readings[i] = domain.MapReadingToProto(&r)
	}

	return connect.NewResponse(resp), nil
}

func (h *AdminHandler) GetSettings(
	ctx context.Context,
	req *connect.Request[involtv1.GetSettingsRequest],
) (*connect.Response[involtv1.GetSettingsResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can view settings"))
	}

	settings, err := h.metaRepo.GetSettings(ctx)
	if err != nil {
		// If no settings found, return an empty/default one instead of erroring out
		return connect.NewResponse(&involtv1.GetSettingsResponse{
			Settings: &involtv1.Settings{},
		}), nil
	}

	return connect.NewResponse(&involtv1.GetSettingsResponse{
		Settings: &involtv1.Settings{
			Municipalidad:   settings.Municipalidad,
			Empresa:         settings.Empresa,
			Ruc:             settings.RUC,
			Direccion:       settings.Direccion,
			Telefono:        settings.Telefono,
			Email:           settings.Email,
			DiasVencimiento: int32(settings.DiasVencimiento),
			TarifaKwh:       safeFloat(settings.TarifaKWh),
			CargoFijo:       safeFloat(settings.CargoFijo),
			Alumbrado:       safeFloat(settings.Alumbrado),
			Mantenimiento:   safeFloat(settings.Mantenimiento),
			Igv:             settings.IGV,
		},
	}), nil
}

func (h *AdminHandler) UpdateSettings(
	ctx context.Context,
	req *connect.Request[involtv1.UpdateSettingsRequest],
) (*connect.Response[involtv1.UpdateSettingsResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can update settings"))
	}
	s := req.Msg.Settings
	domainSettings := &domain.Settings{
		Municipalidad:   s.Municipalidad,
		Empresa:         s.Empresa,
		RUC:             s.Ruc,
		Direccion:       s.Direccion,
		Telefono:        s.Telefono,
		Email:           s.Email,
		DiasVencimiento: int(s.DiasVencimiento),
		TarifaKWh:       safeFloat(s.TarifaKwh),
		CargoFijo:       safeFloat(s.CargoFijo),
		Alumbrado:       safeFloat(s.Alumbrado),
		Mantenimiento:   safeFloat(s.Mantenimiento),
		IGV:             s.Igv,
	}

	err := h.metaRepo.SaveSettings(ctx, domainSettings)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.UpdateSettingsResponse{
		Settings: s,
	}), nil
}

func (h *AdminHandler) UpsertCustomer(
	ctx context.Context,
	req *connect.Request[involtv1.UpsertCustomerRequest],
) (*connect.Response[involtv1.UpsertCustomerResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can manage customers"))
	}
	c := req.Msg.Customer
	contractStart, _ := time.Parse(time.RFC3339, c.ContractStart)

	domainCustomer := &domain.Customer{
		ID:               c.Id,
		Code:             c.Code,
		Name:             c.Name,
		CommunityID:      c.CommunityId,
		SectorID:         c.SectorId,
		Address:          c.Address,
		ConnectionType:   mapProtoConnectionTypeToDomain(c.ConnectionType),
		Tariff:           c.Tariff,
		MeterNumber:      c.MeterNumber,
		Latitude:         c.Latitude,
		Longitude:        c.Longitude,
		InitialReading:   0, // Always 0, calculated from reading history
		LastReadingValue: c.LastReadingValue,
		ContractStart:    contractStart,
	}

	err := h.customerRepo.Save(ctx, domainCustomer)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.UpsertCustomerResponse{
		Customer: c,
	}), nil
}

func (h *AdminHandler) DeleteCustomer(
	ctx context.Context,
	req *connect.Request[involtv1.DeleteCustomerRequest],
) (*connect.Response[involtv1.DeleteCustomerResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can delete customers"))
	}
	err := h.customerRepo.Delete(ctx, req.Msg.Id)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.DeleteCustomerResponse{
		Success: true,
	}), nil
}

func (h *AdminHandler) GetDashboardStats(
	ctx context.Context,
	req *connect.Request[involtv1.GetDashboardStatsRequest],
) (*connect.Response[involtv1.GetDashboardStatsResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, nil)
	}

	period := req.Msg.Period
	if period == "" {
		// Use OPEN period instead of current month
		periods, _ := h.periodRepo.List(ctx)
		for _, p := range periods {
			if p.Status == domain.PeriodStatusOpen {
				period = p.ID
				break
			}
		}
		// Fallback to current month if no open period
		if period == "" {
			period = time.Now().Format("2006-01")
		}
		fmt.Printf("📊 Dashboard using period: %s (open: %v, periods: %v)\n", period, periods, len(periods))
	}

	// Calculate previous period (YYYY-MM)
	t, _ := time.Parse("2006-01", period)
	prevPeriod := t.AddDate(0, -1, 0).Format("2006-01")

	// Get all sectors first to filter
	allSectors, _ := h.metaRepo.ListSectors(ctx)
	var sectors []domain.Sector
	if userCtx.Role == string(domain.RoleAdmin) {
		sectors = allSectors
	} else {
		for _, s := range allSectors {
			if contains(userCtx.AssignedSectorIDs, s.ID) {
				sectors = append(sectors, s)
			}
		}
	}

	// Calculate Sector Stats and Aggregate Totals
	sectorStats := make([]*involtv1.SectorStat, len(sectors))
	var totalCustomers, totalReadings, totalPending int32
	var totalRevenue, totalConsumption, totalPrevConsumption float64

	for i, s := range sectors {
		count, _ := h.customerRepo.CountBySector(ctx, s.ID)
		registered, _ := h.readingRepo.CountBySectorAndPeriod(ctx, s.ID, period)
		sConsumption, _ := h.readingRepo.SumConsumptionBySectorAndPeriod(ctx, s.ID, period)
		sRevenue, _ := h.readingRepo.SumRevenueBySectorAndPeriod(ctx, s.ID, period)
		sPrevConsumption, _ := h.readingRepo.SumConsumptionBySectorAndPeriod(ctx, s.ID, prevPeriod)

		totalCustomers += int32(count)
		totalReadings += int32(registered)
		totalPending += int32(count - registered)
		totalRevenue += sRevenue
		totalConsumption += sConsumption
		totalPrevConsumption += sPrevConsumption

		progress := int32(0)
		if count > 0 {
			progress = int32((registered * 100) / count)
		}

		sectorStats[i] = &involtv1.SectorStat{
			SectorId:           s.ID,
			SectorName:         s.Name,
			RegisteredCount:    int32(registered),
			TotalCount:         int32(count),
			ProgressPercentage: progress,
			TotalConsumption:   sConsumption,
		}
	}

	// Total Users (Only show total for ADMIN)
	var totalUsers int32
	if userCtx.Role == string(domain.RoleAdmin) {
		users, _ := h.adminRepo.ListUsers(ctx)
		totalUsers = int32(len(users))
	}

	return connect.NewResponse(&involtv1.GetDashboardStatsResponse{
		TotalCustomers:         totalCustomers,
		TotalUsers:             totalUsers,
		TotalReadingsPeriod:    totalReadings,
		PendingReadingsPeriod:  totalPending,
		TotalRevenue:           totalRevenue,
		TotalConsumptionKwh:    totalConsumption,
		PreviousConsumptionKwh: totalPrevConsumption,
		SectorStats:            sectorStats,
	}), nil
}

func mapDomainConnectionTypeToProto(conn domain.ConnectionType) involtv1.ConnectionType {
	switch conn {
	case domain.ConnectionTypeMonofasica:
		return involtv1.ConnectionType_CONNECTION_TYPE_MONOFASICA
	case domain.ConnectionTypeTrifasica:
		return involtv1.ConnectionType_CONNECTION_TYPE_TRIFASICA
	default:
		return involtv1.ConnectionType_CONNECTION_TYPE_UNSPECIFIED
	}
}

func mapDomainRoleToProto(role domain.UserRole) involtv1.UserRole {
	switch role {
	case domain.RoleAdmin:
		return involtv1.UserRole_USER_ROLE_ADMIN
	case domain.RoleSupervisor:
		return involtv1.UserRole_USER_ROLE_SUPERVISOR
	case domain.RoleReader:
		return involtv1.UserRole_USER_ROLE_READER
	default:
		return involtv1.UserRole_USER_ROLE_UNSPECIFIED
	}
}

func mapProtoRoleToDomain(role involtv1.UserRole) domain.UserRole {
	switch role {
	case involtv1.UserRole_USER_ROLE_ADMIN:
		return domain.RoleAdmin
	case involtv1.UserRole_USER_ROLE_SUPERVISOR:
		return domain.RoleSupervisor
	case involtv1.UserRole_USER_ROLE_READER:
		return domain.RoleReader
	default:
		return domain.RoleReader // Default to safest
	}
}

func mapProtoConnectionTypeToDomain(conn involtv1.ConnectionType) domain.ConnectionType {
	switch conn {
	case involtv1.ConnectionType_CONNECTION_TYPE_MONOFASICA:
		return domain.ConnectionTypeMonofasica
	case involtv1.ConnectionType_CONNECTION_TYPE_TRIFASICA:
		return domain.ConnectionTypeTrifasica
	default:
		return domain.ConnectionTypeMonofasica
	}
}

func (h *AdminHandler) ListPeriods(ctx context.Context, req *connect.Request[involtv1.ListPeriodsRequest]) (*connect.Response[involtv1.ListPeriodsResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can manage periods"))
	}

	periods, err := h.periodRepo.List(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoPeriods []*involtv1.Period
	for _, p := range periods {
		protoPeriods = append(protoPeriods, &involtv1.Period{
			Id:        p.ID,
			StartDate: p.StartDate.Format("2006-01-02"),
			EndDate:   p.EndDate.Format("2006-01-02"),
			Status:    mapDomainStatusToProto(p.Status),
		})
	}

	return connect.NewResponse(&involtv1.ListPeriodsResponse{Periods: protoPeriods}), nil
}

func (h *AdminHandler) GetPeriodStats(ctx context.Context, req *connect.Request[involtv1.GetPeriodStatsRequest]) (*connect.Response[involtv1.GetPeriodStatsResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can view period stats"))
	}

	stats, err := h.periodRepo.GetStats(ctx, req.Msg.PeriodId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var missing []*involtv1.MissingCustomer
	for _, m := range stats.MissingCustomers {
		missing = append(missing, &involtv1.MissingCustomer{
			Id:         m.ID,
			Name:       m.Name,
			Code:       m.Code,
			SectorName: m.SectorName,
			Supervisor: m.Supervisor,
		})
	}

	return connect.NewResponse(&involtv1.GetPeriodStatsResponse{
		TotalCustomers:   int32(stats.TotalCustomers),
		ReadingsCaptured: int32(stats.ReadingsCaptured),
		MissingReadings:  int32(stats.MissingReadings),
		MissingCustomers: missing,
	}), nil
}

func (h *AdminHandler) OpenPeriod(ctx context.Context, req *connect.Request[involtv1.OpenPeriodRequest]) (*connect.Response[involtv1.OpenPeriodResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can open periods"))
	}

	start, _ := time.Parse("2006-01-02", req.Msg.StartDate)
	end, _ := time.Parse("2006-01-02", req.Msg.EndDate)

	p := &domain.Period{
		ID:        req.Msg.Id,
		StartDate: start,
		EndDate:   end,
		Status:    domain.PeriodStatusOpen,
	}

	if err := h.periodRepo.Save(ctx, p); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.OpenPeriodResponse{
		Period: &involtv1.Period{
			Id:        p.ID,
			StartDate: p.StartDate.Format("2006-01-02"),
			EndDate:   p.EndDate.Format("2006-01-02"),
			Status:    involtv1.PeriodStatus_PERIOD_STATUS_OPEN,
		},
	}), nil
}

func (h *AdminHandler) ClosePeriod(ctx context.Context, req *connect.Request[involtv1.ClosePeriodRequest]) (*connect.Response[involtv1.ClosePeriodResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	if !ok || userCtx.Role != string(domain.RoleAdmin) {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("only admins can close periods"))
	}

	p, err := h.periodRepo.GetByID(ctx, req.Msg.Id)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("period not found"))
	}

	p.Status = domain.PeriodStatusClosed
	if err := h.periodRepo.Save(ctx, p); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &involtv1.ClosePeriodResponse{
		ClosedPeriod: &involtv1.Period{
			Id:        p.ID,
			StartDate: p.StartDate.Format("2006-01-02"),
			EndDate:   p.EndDate.Format("2006-01-02"),
			Status:    involtv1.PeriodStatus_PERIOD_STATUS_CLOSED,
		},
	}

	if req.Msg.OpenNext {
		// Calculate next month
		t, _ := time.Parse("2006-01", p.ID)
		nextT := t.AddDate(0, 1, 0)
		nextID := nextT.Format("2006-01")
		nextStart := nextT.Format("2006-01-02")
		nextEnd := nextT.AddDate(0, 1, -1).Format("2006-01-02")

		nextP := &domain.Period{
			ID:        nextID,
			StartDate: nextT,
			EndDate:   nextT.AddDate(0, 1, -1),
			Status:    domain.PeriodStatusOpen,
		}

		if err := h.periodRepo.Save(ctx, nextP); err == nil {
			resp.NextPeriod = &involtv1.Period{
				Id:        nextID,
				StartDate: nextStart,
				EndDate:   nextEnd,
				Status:    involtv1.PeriodStatus_PERIOD_STATUS_OPEN,
			}
		}
	}

	return connect.NewResponse(resp), nil
}

func mapDomainStatusToProto(s domain.PeriodStatus) involtv1.PeriodStatus {
	switch s {
	case domain.PeriodStatusOpen:
		return involtv1.PeriodStatus_PERIOD_STATUS_OPEN
	case domain.PeriodStatusClosed:
		return involtv1.PeriodStatus_PERIOD_STATUS_CLOSED
	default:
		return involtv1.PeriodStatus_PERIOD_STATUS_UNSPECIFIED
	}
}

func (h *AdminHandler) DownloadReadingPDF(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	// URL path is /admin/readings/pdf/{id}
	readingID := strings.TrimPrefix(r.URL.Path, "/admin/readings/pdf/")

	// 1. Authenticate User
	tokenStr := r.URL.Query().Get("token")
	if tokenStr == "" {
		tokenStr = r.Header.Get("Authorization")
		if strings.HasPrefix(tokenStr, "Bearer ") {
			tokenStr = strings.TrimPrefix(tokenStr, "Bearer ")
		}
	}

	if tokenStr == "" {
		http.Error(w, "Unauthorized: missing token", http.StatusUnauthorized)
		return
	}

	claims, err := h.jwtService.ValidateToken(tokenStr)
	if err != nil {
		http.Error(w, "Unauthorized: invalid token", http.StatusUnauthorized)
		return
	}

	// 2. Fetch Data
	reading, err := h.readingRepo.GetByID(ctx, readingID)
	if err != nil {
		http.Error(w, "Reading not found", http.StatusNotFound)
		return
	}

	customer, err := h.customerRepo.GetByID(ctx, reading.CustomerID)
	if err != nil {
		http.Error(w, "Customer not found", http.StatusNotFound)
		return
	}

	// 3. Permission Checks
	if claims.Role != string(domain.RoleAdmin) {
		allowed := false
		for _, id := range claims.AssignedSectorIDs {
			if id == customer.SectorID {
				allowed = true
				break
			}
		}
		if !allowed {
			http.Error(w, "Forbidden: sector not assigned", http.StatusForbidden)
			return
		}
	}

	// 4. Enrich and Generate
	settings, _ := h.metaRepo.GetSettings(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}

	// Recalculate components if zero (similar to GetReadings)
	if reading.TotalToPay == 0 && reading.Consumption > 0 {
		consumptionCharge := reading.Consumption * safeFloat(settings.TarifaKWh)
		cargoFijo := 0.0
		alumbrado := 0.0
		mantenimiento := 0.0

		if p, err := h.periodRepo.GetByID(ctx, reading.Period); err == nil && p != nil {
			if p.IsBillingPeriod {
				cargoFijo = safeFloat(settings.CargoFijo)
				alumbrado = safeFloat(settings.Alumbrado)
				mantenimiento = safeFloat(settings.Mantenimiento)
			}
		}

		reading.Subtotal = consumptionCharge + cargoFijo + alumbrado + mantenimiento
		reading.TotalToPay = reading.Subtotal + reading.SaldoRedondeo
		reading.CargoFijo = cargoFijo
		reading.AlumbradoPublico = alumbrado
		reading.Mantenimiento = mantenimiento
	}

	communities, _ := h.metaRepo.ListCommunities(ctx)
	sectors, _ := h.metaRepo.ListSectors(ctx)
	
	commName := ""
	for _, c := range communities {
		if c.ID == customer.CommunityID {
			commName = c.Name
			break
		}
	}
	
	sectName := ""
	for _, s := range sectors {
		if s.ID == customer.SectorID {
			sectName = s.Name
			break
		}
	}

	allHistory, _, err := h.readingRepo.List(ctx, reading.CustomerID, "", "", 50, 0)
	if err != nil {
		allHistory = []domain.Reading{}
	}
	var history []domain.Reading
	for _, r := range allHistory {
		if r.Period <= reading.Period {
			history = append(history, r)
			if len(history) == 6 {
				break
			}
		}
	}

	pdfData, err := h.pdfGen.Generate(ctx, reading, customer, settings, commName, sectName, history)
	if err != nil {
		http.Error(w, "Error generating PDF", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/pdf")
	w.Header().Set("Content-Disposition", fmt.Sprintf("inline; filename=recibo_%s.pdf", readingID))
	w.Write(pdfData)
}

func (h *AdminHandler) BulkPDF(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// 1. Authenticate User
	tokenStr := r.URL.Query().Get("token")
	if tokenStr == "" {
		tokenStr = r.Header.Get("Authorization")
		if strings.HasPrefix(tokenStr, "Bearer ") {
			tokenStr = strings.TrimPrefix(tokenStr, "Bearer ")
		}
	}

	if tokenStr == "" {
		http.Error(w, "Unauthorized: missing token", http.StatusUnauthorized)
		return
	}

	claims, err := h.jwtService.ValidateToken(tokenStr)
	if err != nil {
		http.Error(w, "Unauthorized: invalid token", http.StatusUnauthorized)
		return
	}

	// 2. Parse Filters
	period := r.URL.Query().Get("period")
	if period == "" {
		period = time.Now().Format("2006-01")
	}
	sectorID := r.URL.Query().Get("sectorId")

	// 3. Permission Checks
	var allowedSectors []string
	if claims.Role != string(domain.RoleAdmin) {
		if sectorID != "" {
			allowed := false
			for _, id := range claims.AssignedSectorIDs {
				if id == sectorID {
					allowed = true
					break
				}
			}
			if !allowed {
				http.Error(w, "Forbidden: sector not assigned", http.StatusForbidden)
				return
			}
			allowedSectors = []string{sectorID}
		} else {
			allowedSectors = claims.AssignedSectorIDs
			if len(allowedSectors) == 0 {
				http.Error(w, "Forbidden: no sectors assigned", http.StatusForbidden)
				return
			}
		}
	} else if sectorID != "" {
		allowedSectors = []string{sectorID}
	}

	finalSectorID := ""
	if len(allowedSectors) == 1 {
		finalSectorID = allowedSectors[0]
	} else if len(allowedSectors) > 1 {
		finalSectorID = allowedSectors[0]
	} else if sectorID != "" {
		finalSectorID = sectorID
	}

	log.Printf("📊 Bulk PDF: Period=%s, Sector=%s", period, finalSectorID)
	readings, _, err := h.readingRepo.List(ctx, "", finalSectorID, period, 2000, 0)
	if err != nil {
		http.Error(w, "Error fetching readings", http.StatusInternalServerError)
		return
	}

	if len(readings) == 0 {
		http.Error(w, "No readings found for this period", http.StatusNotFound)
		return
	}

	allCustomers, err := h.customerRepo.ListAll(ctx)
	if err != nil {
		http.Error(w, "Error fetching customers", http.StatusInternalServerError)
		return
	}

	customerMap := make(map[string]*domain.Customer)
	for i := range allCustomers {
		customerMap[allCustomers[i].ID] = &allCustomers[i]
	}

	communities, _ := h.metaRepo.ListCommunities(ctx)
	sectors, _ := h.metaRepo.ListSectors(ctx)
	
	commMap := make(map[string]string)
	for _, c := range communities {
		commMap[c.ID] = c.Name
	}
	sectMap := make(map[string]string)
	for _, s := range sectors {
		sectMap[s.ID] = s.Name
	}

	for _, c := range customerMap {
		c.CommunityName = commMap[c.CommunityID]
		c.SectorName = sectMap[c.SectorID]
	}

	settings, err := h.metaRepo.GetSettings(ctx)
	if err != nil {
		settings = &domain.Settings{}
	}

	readingsBySector := make(map[string][]domain.Reading)
	if sectorID == "" {
		for _, r := range readings {
			cust := customerMap[r.CustomerID]
			sID := "sin_sector"
			if cust != nil && cust.SectorID != "" {
				sID = cust.SectorID
			}
			readingsBySector[sID] = append(readingsBySector[sID], r)
		}
	}

	historyMap := make(map[string][]domain.Reading)
	for _, r := range readings {
		if _, ok := historyMap[r.CustomerID]; !ok {
			allHist, _, _ := h.readingRepo.List(ctx, r.CustomerID, "", "", 50, 0)
			var history []domain.Reading
			for _, h := range allHist {
				if h.Period <= r.Period {
					history = append(history, h)
					if len(history) == 6 {
						break
					}
				}
			}
			historyMap[r.CustomerID] = history
		}
	}

	if sectorID != "" {
		pdfData, err := h.pdfGen.GenerateBatch(ctx, readings, customerMap, settings, historyMap)
		if err != nil {
			http.Error(w, "Error generating PDF", http.StatusInternalServerError)
			return
		}

		fileName := fmt.Sprintf("recibos_%s_%s.pdf", sectMap[sectorID], period)
		w.Header().Set("Content-Type", "application/pdf")
		w.Header().Set("Content-Disposition", fmt.Sprintf("attachment; filename=%s", fileName))
		w.Write(pdfData)
	} else {
		buf := new(bytes.Buffer)
		zw := zip.NewWriter(buf)

		for sID, rs := range readingsBySector {
			sName := sectMap[sID]
			if sName == "" {
				sName = sID
			}

			pdfData, err := h.pdfGen.GenerateBatch(ctx, rs, customerMap, settings, historyMap)
			if err != nil {
				continue
			}

			f, err := zw.Create(fmt.Sprintf("%s_%s.pdf", sName, period))
			if err != nil {
				continue
			}
			f.Write(pdfData)
		}

		zw.Close()
		w.Header().Set("Content-Type", "application/zip")
		w.Header().Set("Content-Disposition", fmt.Sprintf("attachment; filename=recibos_todos_%s.zip", period))
		w.Write(buf.Bytes())
	}
}

func safeFloat(f float64) float64 {
	if math.IsNaN(f) || math.IsInf(f, 0) {
		return 0
	}
	return f
}

// Ensure AdminHandler implements the generated interface
var _ involtv1connect.AdminServiceHandler = (*AdminHandler)(nil)
