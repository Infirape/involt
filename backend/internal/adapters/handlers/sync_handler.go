package handlers

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/gen/involt/v1/involtv1connect"
	"github.com/infira/involt/backend/internal/ports"
)

type SyncHandler struct {
	metaRepo     ports.MetadataRepository
	customerRepo ports.CustomerRepository
	readingRepo  ports.ReadingRepository
	periodRepo   ports.PeriodRepository
	adminRepo    ports.AdminRepository
	pdfGen       ports.ReceiptGenerator
}

func NewSyncHandler(
	metaRepo ports.MetadataRepository,
	customerRepo ports.CustomerRepository,
	readingRepo ports.ReadingRepository,
	periodRepo ports.PeriodRepository,
	adminRepo ports.AdminRepository,
	pdfGen ports.ReceiptGenerator,
) *SyncHandler {
	return &SyncHandler{
		metaRepo:     metaRepo,
		customerRepo: customerRepo,
		readingRepo:  readingRepo,
		periodRepo:   periodRepo,
		adminRepo:    adminRepo,
		pdfGen:       pdfGen,
	}
}

func (h *SyncHandler) PullMetadata(
	ctx context.Context,
	req *connect.Request[involtv1.PullMetadataRequest],
) (*connect.Response[involtv1.PullMetadataResponse], error) {
	userCtx, ok := auth.GetUserFromContext(ctx)
	isAdmin := ok && userCtx.Role == string(domain.RoleAdmin)

	communities, err := h.metaRepo.ListCommunities(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to list communities: %w", err))
	}

	allSectors, err := h.metaRepo.ListSectors(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to list sectors: %w", err))
	}

	allCustomers, err := h.customerRepo.ListAll(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to list customers: %w", err))
	}

	// Filter based on role
	var sectors []domain.Sector
	var customers []domain.Customer
	allowedSectorIDs := make(map[string]bool)

	if isAdmin {
		sectors = allSectors
		customers = allCustomers
	} else {
		// Reader: Filter by assigned sectors
		assignedMap := make(map[string]bool)
		for _, id := range userCtx.AssignedSectorIDs {
			assignedMap[id] = true
		}

		for _, s := range allSectors {
			if assignedMap[s.ID] {
				sectors = append(sectors, s)
				allowedSectorIDs[s.ID] = true
			}
		}

		for _, c := range allCustomers {
			if allowedSectorIDs[c.SectorID] {
				customers = append(customers, c)
			}
		}
	}

	config, err := h.metaRepo.GetAppConfig(ctx)
	if err != nil {
		log.Printf("⚠️ Error getting app config: %v", err)
		config = &domain.AppConfig{}
	}

	settings, err := h.metaRepo.GetSettings(ctx)
	if err != nil {
		log.Printf("⚠️ Error getting settings: %v", err)
		settings = &domain.Settings{}
	}

	mapUrl := config.MapURLTemplate
	if mapUrl == "" {
		mapUrl = "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
	}
	mapUserAgent := config.MapUserAgent
	if mapUserAgent == "" {
		mapUserAgent = "InVoltApp/1.0 (com.infira.involt; android)"
	}

	resp := &involtv1.PullMetadataResponse{
		Communities: make([]*involtv1.Community, 0),
		Sectors:     make([]*involtv1.Sector, len(sectors)),
		Customers:   make([]*involtv1.Customer, len(customers)),
		Config: &involtv1.AppConfig{
			MapUrlTemplate: mapUrl,
			MapUserAgent:   mapUserAgent,
		},
		Settings: &involtv1.Settings{
			Municipalidad:   settings.Municipalidad,
			Empresa:         settings.Empresa,
			Ruc:             settings.RUC,
			Direccion:       settings.Direccion,
			Telefono:        settings.Telefono,
			Email:           settings.Email,
			DiasVencimiento: int32(settings.DiasVencimiento),
			TarifaKwh:       settings.TarifaKWh,
			CargoFijo:       settings.CargoFijo,
			Alumbrado:       settings.Alumbrado,
			Mantenimiento:   settings.Mantenimiento,
			Igv:             settings.IGV,
		},
	}

	// Filter communities to only those that have at least one allowed sector
	allowedCommunityIDs := make(map[string]bool)
	for _, s := range sectors {
		allowedCommunityIDs[s.CommunityID] = true
	}
	for _, c := range communities {
		if allowedCommunityIDs[c.ID] {
			resp.Communities = append(resp.Communities, &involtv1.Community{Id: c.ID, Name: c.Name})
		}
	}

	for i, s := range sectors {
		resp.Sectors[i] = &involtv1.Sector{Id: s.ID, CommunityId: s.CommunityID, Name: s.Name}
	}

	for i, c := range customers {
		resp.Customers[i] = domain.MapCustomerToProto(&c)
	}

	// Fetch and map readings (Filter by allowed customers if reader)
	allReadings, err := h.readingRepo.ListAll(ctx)
	if err != nil {
		log.Printf("⚠️ Error getting readings for sync: %v", err)
	} else {
		allowedCustomerIDs := make(map[string]bool)
		for _, c := range customers {
			allowedCustomerIDs[c.ID] = true
		}

		filteredReadings := make([]*involtv1.Reading, 0)
		for _, r := range allReadings {
			if allowedCustomerIDs[r.CustomerID] {
				filteredReadings = append(filteredReadings, domain.MapReadingToProto(&r))
			}
		}
		resp.Readings = filteredReadings
	}

	// Fetch current open period
	if openPeriod, err := h.periodRepo.GetCurrent(ctx); err == nil && openPeriod != nil {
		resp.CurrentPeriod = domain.MapPeriodToProto(openPeriod)
	}

	// Fetch operators for offline login
	users, err := h.adminRepo.ListUsers(ctx)
	if err != nil {
		log.Printf("⚠️ Error getting users for sync: %v", err)
	} else {
		resp.Operators = make([]*involtv1.Operator, len(users))
		for i, u := range users {
			resp.Operators[i] = domain.MapUserToOperatorProto(&u)
		}
	}

	return connect.NewResponse(resp), nil
}

func (h *SyncHandler) PushReadings(
	ctx context.Context,
	req *connect.Request[involtv1.PushReadingsRequest],
) (*connect.Response[involtv1.PushReadingsResponse], error) {
	syncedCount := 0
	settings, _ := h.metaRepo.GetSettings(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}

	log.Printf("📥 Sync: Received PushReadings request with %d readings", len(req.Msg.Readings))
	for _, r := range req.Msg.Readings {
		reading := domain.MapProtoToReading(r)
		
		// 1. Get true previous value from server DB to ensure consistency
		// We look for the latest reading that is NOT this one.
		prevReading, err := h.readingRepo.GetLatestByCustomerExcludingID(ctx, r.CustomerId, r.Id)
		actualPrevValue := r.PreviousValue // fallback to what App sent
		
		if err == nil && prevReading != nil && prevReading.CurrentValue > 0 {
			// Database has a non-zero history, keep it for consistency
			actualPrevValue = prevReading.CurrentValue
		} else if r.PreviousValue > 0 {
			// Prioritize user-provided previous value if DB is 0 or missing
			actualPrevValue = r.PreviousValue

			// Backfill previous period reading if it doesn't exist
			// This ensures that GetCustomers for the current period will find this history
			prevPeriod := getPreviousPeriodID(r.Period)
			if prevPeriod != "" {
				prevID := fmt.Sprintf("read-%s-%s", r.CustomerId, prevPeriod)
				if _, err := h.readingRepo.GetByID(ctx, prevID); err != nil {
					// Create a base reading for the previous period so it exists in the history
					h.readingRepo.Save(ctx, &domain.Reading{
						ID:           prevID,
						CustomerID:   r.CustomerId,
						CurrentValue: r.PreviousValue,
						Period:       prevPeriod,
						Timestamp:    time.Now(),
					})
				}
			}
		} else if actualPrevValue <= 0 {
			// Fallback to customer initial reading if everything else is 0
			if cust, err := h.customerRepo.GetByID(ctx, r.CustomerId); err == nil && cust != nil {
				if cust.InitialReading > 0 {
					actualPrevValue = cust.InitialReading
				}
			}
		}

		log.Printf("   -> Processing %s for %s (Curr: %.2f, AppPrev: %.2f, DBPrev: %.2f)", 
			r.Id, r.CustomerId, r.CurrentValue, r.PreviousValue, actualPrevValue)
		
		// Recalculate components based on SERVER truth
		reading.PreviousValue = actualPrevValue
		consumption := reading.CurrentValue - actualPrevValue
		if consumption < 0 {
			consumption = 0
		}

		// Initial calculation: only consumption
		consumptionCharge := consumption * settings.TarifaKWh
		
		// Fixed charges: only if it's a billing period
		cargoFijo := 0.0
		alumbrado := 0.0
		mantenimiento := 0.0

		var periodStart, periodEnd, expirationDate time.Time
		if period, err := h.periodRepo.GetByID(ctx, reading.Period); err == nil && period != nil {
			periodStart = period.StartDate
			periodEnd = period.EndDate
			if period.IsBillingPeriod {
				cargoFijo = settings.CargoFijo
				alumbrado = settings.Alumbrado
				mantenimiento = settings.Mantenimiento
			}
		} else {
			// Parse from YYYY-MM fallback
			if t, err := time.Parse("2006-01", reading.Period); err == nil {
				periodStart = time.Date(t.Year(), t.Month(), 1, 0, 0, 0, 0, time.UTC)
				periodEnd = periodStart.AddDate(0, 1, -1)
			}
		}

		if !periodStart.IsZero() {
			// Use DiasVencimiento as the day of the month, defaulting to 15
			dueDay := settings.DiasVencimiento
			if dueDay <= 0 || dueDay > 28 {
				dueDay = 15
			}
			nextMonth := periodStart.AddDate(0, 1, 0)
			expirationDate = time.Date(nextMonth.Year(), nextMonth.Month(), dueDay, 0, 0, 0, 0, time.UTC)
		}

		// Final totals
		subtotal := consumptionCharge + cargoFijo + alumbrado + mantenimiento
		total := subtotal + reading.SaldoRedondeo

		// Update reading object
		reading.CargoFijo = cargoFijo
		reading.AlumbradoPublico = alumbrado
		reading.Mantenimiento = mantenimiento
		reading.Consumption = consumption
		reading.Subtotal = subtotal
		reading.TotalToPay = total
		reading.PeriodStart = periodStart
		reading.PeriodEnd = periodEnd
		reading.ExpirationDate = expirationDate

		if err := h.readingRepo.Save(ctx, reading); err != nil {
			log.Printf("⚠️ Error saving reading %s: %v", r.Id, err)
			continue
		}
		syncedCount++
	}

	return connect.NewResponse(&involtv1.PushReadingsResponse{
		Success:     true,
		SyncedCount: int32(syncedCount),
	}), nil
}

func (h *SyncHandler) UploadPhoto(
	ctx context.Context,
	req *connect.Request[involtv1.UploadPhotoRequest],
) (*connect.Response[involtv1.UploadPhotoResponse], error) {
	fileName := fmt.Sprintf("%d_%s", time.Now().UnixNano(), req.Msg.FileName)
	filePath := fmt.Sprintf("uploads/%s", fileName)

	err := os.WriteFile(filePath, req.Msg.Data, 0644)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to save photo: %w", err))
	}

	// For now, returning a local path. In production, this would be a full URL (S3/CDN).
	return connect.NewResponse(&involtv1.UploadPhotoResponse{
		Url: filePath,
	}), nil
}

func (h *SyncHandler) DownloadReceipt(
	ctx context.Context,
	req *connect.Request[involtv1.DownloadReceiptRequest],
) (*connect.Response[involtv1.DownloadReceiptResponse], error) {
	reading, err := h.readingRepo.GetByID(ctx, req.Msg.ReadingId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("reading %s not found: %w", req.Msg.ReadingId, err))
	}

	customer, err := h.customerRepo.GetByID(ctx, reading.CustomerID)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("customer %s not found: %w", reading.CustomerID, err))
	}

	settings, _ := h.metaRepo.GetSettings(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}

	communities, _ := h.metaRepo.ListCommunities(ctx)
	commName := ""
	for _, c := range communities {
		if c.ID == customer.CommunityID {
			commName = c.Name
			break
		}
	}

	sectors, _ := h.metaRepo.ListSectors(ctx)
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
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to generate PDF: %w", err))
	}

	return connect.NewResponse(&involtv1.DownloadReceiptResponse{
		PdfData: pdfData,
	}), nil
}

// Ensure SyncHandler implements the generated interface
var _ involtv1connect.SyncServiceHandler = (*SyncHandler)(nil)

func getPreviousPeriodID(periodID string) string {
	t, err := time.Parse("2006-01", periodID)
	if err != nil {
		return ""
	}
	return t.AddDate(0, -1, 0).Format("2006-01")
}
