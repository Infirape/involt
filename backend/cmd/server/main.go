package main

import (
	_ "embed"
	"log"
	"net/http"
	"os"
	"time"

	"connectrpc.com/connect"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/adapters/handlers"
	"github.com/infira/involt/backend/internal/adapters/pdf"
	"github.com/infira/involt/backend/internal/adapters/repositories"
	"github.com/infira/involt/backend/internal/gen/involt/v1/involtv1connect"
	"github.com/rs/cors"
	"strings"
)

func main() {
	// 1. Database Connection
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		dbURL = "postgres://involt_user:involt_password@127.0.0.1:5432/involt_db?sslmode=disable"
	}

	var db *sqlx.DB
	var err error
	for i := 0; i < 5; i++ {
		db, err = sqlx.Connect("postgres", dbURL)
		if err == nil {
			break
		}
		time.Sleep(2 * time.Second)
	}

	if err != nil {
		log.Fatalf("❌ Database connection failed after 5 attempts: %v", err)
	}
	defer db.Close()

	// Initialize database schema
	if err := initSchema(db); err != nil {
	}

	// 2. Initialize Repositories
	metaRepo := repositories.NewPostgresMetadataRepository(db)
	customerRepo := repositories.NewPostgresCustomerRepository(db)
	readingRepo := repositories.NewPostgresReadingRepository(db)
	settingsRepo := repositories.NewSettingsRepository(db)
	adminRepo := repositories.NewPostgresAdminRepository(db)
	periodRepo := repositories.NewPostgresPeriodRepository(db)
	pdfGen := pdf.NewMarotoGenerator()

	// 3. Initialize Handlers
	jwtSecret := os.Getenv("JWT_SECRET")
	if jwtSecret == "" {
		jwtSecret = "super-secret-key-change-me-in-prod"
	}

	syncHandler := handlers.NewSyncHandler(metaRepo, customerRepo, readingRepo, periodRepo, adminRepo, pdfGen)
	settingsHandler := handlers.NewSettingsHandler(settingsRepo)
	adminSvcHandler := handlers.NewAdminHandler(adminRepo, metaRepo, customerRepo, readingRepo, periodRepo, jwtSecret, pdfGen)

	// 4. Setup Mux
	mux := http.NewServeMux()

	// ConnectRPC endpoints
	authInterceptor := auth.NewAuthInterceptor(auth.NewJWTService(jwtSecret))

	path, handler := involtv1connect.NewSyncServiceHandler(
		syncHandler,
		connect.WithInterceptors(authInterceptor),
	)
	mux.Handle(path, handler)

	adminPath, adminHandlerRPC := involtv1connect.NewAdminServiceHandler(
		adminSvcHandler,
		connect.WithInterceptors(authInterceptor),
	)
	mux.Handle(adminPath, adminHandlerRPC)

	// REST endpoints for settings
	mux.HandleFunc("/api/settings", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			settingsHandler.GetSettings(w, r)
		case http.MethodPut:
			settingsHandler.UpdateSettings(w, r)
		default:
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})

	// REST endpoints for PDF export
	mux.HandleFunc("/admin/readings/bulk-pdf", adminSvcHandler.BulkPDF)
	mux.HandleFunc("/admin/readings/pdf/", adminSvcHandler.DownloadReadingPDF)

	// API Health check
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/" {
			w.Write([]byte("InVolt API is running"))
			return
		}
		http.NotFound(w, r)
	})

	assetsDir := resolveAssetsDir()
	log.Printf("🖼️ Serving assets from %s at /assets/", assetsDir)
	mux.Handle("/assets/", http.StripPrefix("/assets/", http.FileServer(http.Dir(assetsDir))))

	// 5. Start Server with h2c (HTTP/2 Cleartext) and CORS
	allowedOrigins := []string{"http://localhost:3000", "http://localhost:3001", "http://localhost:3002", "http://localhost:3008"}
	if envOrigins := os.Getenv("ALLOWED_ORIGINS"); envOrigins != "" {
		for _, origin := range strings.Split(envOrigins, ",") {
			allowedOrigins = append(allowedOrigins, strings.TrimSpace(origin))
		}
	}
	log.Printf("🔒 CORS Allowed Origins: %v\n", allowedOrigins)

	c := cors.New(cors.Options{
		AllowedOrigins:   allowedOrigins,
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Connect-Protocol-Version", "Content-Type", "Authorization"},
		ExposedHeaders:   []string{"Connect-Protocol-Version", "Content-Disposition"},
		AllowCredentials: true,
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("🚀 InVolt Backend running on http://localhost:%s\n", port)
	err = http.ListenAndServe(
		"0.0.0.0:"+port,
		c.Handler(h2c.NewHandler(mux, &http2.Server{})),
	)
	if err != nil {
		log.Fatalf("❌ Server failed: %v", err)
	}
}

func resolveAssetsDir() string {
	candidates := []string{
		"../assets",   // running from /backend
		"assets",      // running from project root
		"../../assets", // fallback when running from /backend/cmd/server
	}

	for _, candidate := range candidates {
		info, err := os.Stat(candidate)
		if err == nil && info.IsDir() {
			return candidate
		}
	}

	return "../assets"
}

//go:embed schema.sql
var schemaSQL string

func initSchema(db *sqlx.DB) error {
	_, err := db.Exec(schemaSQL)
	return err
}
