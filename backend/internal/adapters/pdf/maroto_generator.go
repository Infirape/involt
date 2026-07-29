package pdf

import (
	"bytes"
	"context"
	"fmt"
	"image"
	"image/color"
	"image/png"
	"os"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/johnfercher/maroto/v2"
	"github.com/johnfercher/maroto/v2/pkg/components/col"
	mimage "github.com/johnfercher/maroto/v2/pkg/components/image"
	"github.com/johnfercher/maroto/v2/pkg/components/row"
	"github.com/johnfercher/maroto/v2/pkg/components/text"
	"github.com/johnfercher/maroto/v2/pkg/config"
	"github.com/johnfercher/maroto/v2/pkg/consts/align"
	"github.com/johnfercher/maroto/v2/pkg/consts/border"
	"github.com/johnfercher/maroto/v2/pkg/consts/extension"
	"github.com/johnfercher/maroto/v2/pkg/consts/fontstyle"
	"github.com/johnfercher/maroto/v2/pkg/consts/pagesize"
	"github.com/johnfercher/maroto/v2/pkg/core"
	"github.com/johnfercher/maroto/v2/pkg/props"
)

var defaultBorderColor = &props.Color{Red: 100, Green: 130, Blue: 160}

type MarotoGenerator struct{}

func NewMarotoGenerator() *MarotoGenerator {
	return &MarotoGenerator{}
}

func (g *MarotoGenerator) resolveLogoPath() string {
	candidates := []string{
		"assets/logo_chetilla.png",
		"../assets/logo_chetilla.png",
		"../../assets/logo_chetilla.png",
		"../../../assets/logo_chetilla.png",
		"backend/assets/logo_chetilla.png",
		"../backend/assets/logo_chetilla.png",
		"../../backend/assets/logo_chetilla.png",
	}
	for _, c := range candidates {
		if _, err := os.Stat(c); err == nil {
			return c
		}
	}
	return "assets/logo_chetilla.png" // fallback
}

func (g *MarotoGenerator) drawSmiley(img *image.RGBA, x0, y0, r int, happy bool) {
	faceColor := color.RGBA{R: 240, G: 240, B: 240, A: 255}
	for x := -r; x <= r; x++ {
		for y := -r; y <= r; y++ {
			if x*x+y*y <= r*r {
				img.Set(x0+x, y0+y, faceColor)
			}
		}
	}

	borderColor := color.RGBA{R: 100, G: 130, B: 160, A: 255} // Match defaultBorderColor
	for x := -r; x <= r; x++ {
		for y := -r; y <= r; y++ {
			d2 := x*x + y*y
			if d2 >= (r-1)*(r-1) && d2 <= r*r {
				img.Set(x0+x, y0+y, borderColor)
			}
		}
	}

	eyeColor := color.RGBA{R: 0, G: 0, B: 0, A: 255}
	img.Set(x0-4, y0-3, eyeColor)
	img.Set(x0-3, y0-3, eyeColor)
	img.Set(x0-4, y0-2, eyeColor)
	img.Set(x0-3, y0-2, eyeColor)

	img.Set(x0+3, y0-3, eyeColor)
	img.Set(x0+4, y0-3, eyeColor)
	img.Set(x0+3, y0-2, eyeColor)
	img.Set(x0+4, y0-2, eyeColor)

	if happy {
		for x := -5; x <= 5; x++ {
			y := (x*x)/5 + 2
			img.Set(x0+x, y0+y, eyeColor)
			img.Set(x0+x, y0+y+1, eyeColor)
		}
	} else {
		for x := -5; x <= 5; x++ {
			y := -(x*x)/5 + 3
			img.Set(x0+x, y0+y, eyeColor)
			img.Set(x0+x, y0+y+1, eyeColor)
		}
	}
}

func (g *MarotoGenerator) generateSmileysImage(history []domain.Reading) []byte {
	width := 120
	height := 30
	img := image.NewRGBA(image.Rect(0, 0, width, height))

	white := color.RGBA{R: 255, G: 255, B: 255, A: 255}
	for x := 0; x < width; x++ {
		for y := 0; y < height; y++ {
			img.Set(x, y, white)
		}
	}

	n := len(history)
	for i := 0; i < 3; i++ {
		idx := n - 3 + i
		if idx >= 0 && idx < n {
			happy := history[idx].IsPaid
			x0 := 20 + i*40
			y0 := 15
			g.drawSmiley(img, x0, y0, 10, happy)
		}
	}

	var buf bytes.Buffer
	_ = png.Encode(&buf, img)
	return buf.Bytes()
}

func (g *MarotoGenerator) generateChartImage(history []domain.Reading) []byte {
	width := 240
	height := 80
	img := image.NewRGBA(image.Rect(0, 0, width, height))

	white := color.RGBA{R: 255, G: 255, B: 255, A: 255}
	for x := 0; x < width; x++ {
		for y := 0; y < height; y++ {
			img.Set(x, y, white)
		}
	}

	grey := color.RGBA{R: 220, G: 220, B: 220, A: 255}
	darkGrey := color.RGBA{R: 100, G: 130, B: 160, A: 255} // Match defaultBorderColor
	magenta := color.RGBA{R: 255, G: 0, B: 255, A: 255}

	for x := 10; x < width-10; x++ {
		img.Set(x, 15, grey)
		img.Set(x, 35, grey)
		img.Set(x, 55, grey)
	}

	for x := 10; x < width-10; x++ {
		img.Set(x, 70, darkGrey)
	}

	n := len(history)
	if n > 6 {
		n = 6
	}
	hist := make([]domain.Reading, n)
	for i := 0; i < n; i++ {
		hist[i] = history[n-1-i]
	}

	maxVal := 10.0
	for _, r := range hist {
		if r.Consumption > maxVal {
			maxVal = r.Consumption
		}
	}

	for i, r := range hist {
		hVal := r.Consumption
		if hVal < 0 {
			hVal = 0
		}
		barHeight := int((hVal / maxVal) * 50.0)
		if barHeight > 50 {
			barHeight = 50
		}

		slotIdx := 6 - len(hist) + i
		xStart := 10 + slotIdx*36 + 8
		xEnd := xStart + 20
		yEnd := 70
		yStart := yEnd - barHeight

		for x := xStart; x < xEnd; x++ {
			for y := yStart; y < yEnd; y++ {
				img.Set(x, y, magenta)
			}
		}
	}

	var buf bytes.Buffer
	_ = png.Encode(&buf, img)
	return buf.Bytes()
}

func (g *MarotoGenerator) enrichReadingDates(reading *domain.Reading, settings *domain.Settings) {
	if reading.PeriodStart.IsZero() || reading.PeriodStart.Year() < 1970 {
		if t, err := time.Parse("2006-01", reading.Period); err == nil {
			reading.PeriodStart = time.Date(t.Year(), t.Month(), 1, 0, 0, 0, 0, time.UTC)
		}
	}
	if reading.PeriodEnd.IsZero() || reading.PeriodEnd.Year() < 1970 {
		if !reading.PeriodStart.IsZero() {
			reading.PeriodEnd = reading.PeriodStart.AddDate(0, 1, -1)
		}
	}
	if !reading.PeriodStart.IsZero() {
		dueDay := settings.DiasVencimiento
		if dueDay <= 0 || dueDay > 28 {
			dueDay = 15
		}
		nextMonth := reading.PeriodStart.AddDate(0, 1, 0)
		reading.ExpirationDate = time.Date(nextMonth.Year(), nextMonth.Month(), dueDay, 0, 0, 0, 0, time.UTC)
	}
}

func (g *MarotoGenerator) Generate(ctx context.Context, reading *domain.Reading, customer *domain.Customer, settings *domain.Settings, community, sector string, history []domain.Reading) ([]byte, error) {
	g.enrichReadingDates(reading, settings)

	cfg := config.NewBuilder().
		WithPageSize(pagesize.A4).
		WithLeftMargin(31).
		WithRightMargin(31).
		WithTopMargin(15).
		Build()

	m := maroto.New(cfg)
	g.addReceiptComponents(m, reading, customer, settings, community, sector, "USUARIO", history)
	
	m.AddRows(row.New(8).Add(
		col.New(12).WithStyle(&props.Cell{BorderType: border.Bottom, BorderThickness: 0.1, BorderColor: defaultBorderColor}),
	))
	
	g.addReceiptComponents(m, reading, customer, settings, community, sector, "ADMINISTRATIVO", history)

	document, err := m.Generate()
	if err != nil {
		return nil, err
	}

	return g.applyWatermark(document.GetBytes())
}

func (g *MarotoGenerator) GenerateBatch(ctx context.Context, readings []domain.Reading, customers map[string]*domain.Customer, settings *domain.Settings, historyMap map[string][]domain.Reading) ([]byte, error) {
	if len(readings) == 0 {
		return nil, nil
	}

	cfg := config.NewBuilder().
		WithPageSize(pagesize.A4).
		WithLeftMargin(31).
		WithRightMargin(31).
		WithTopMargin(15).
		Build()
	m := maroto.New(cfg)

	for i, r := range readings {
		customer := customers[r.CustomerID]
		if customer == nil {
			customer = &domain.Customer{Name: "Desconocido", Code: "N/A"}
		}
		
		g.enrichReadingDates(&r, settings)
		
		g.addReceiptComponents(m, &r, customer, settings, customer.CommunityName, customer.SectorName, "USUARIO", historyMap[r.CustomerID])
		
		m.AddRows(row.New(8).Add(
			col.New(12).WithStyle(&props.Cell{BorderType: border.Bottom, BorderThickness: 0.1, BorderColor: defaultBorderColor}),
		))
		
		g.addReceiptComponents(m, &r, customer, settings, customer.CommunityName, customer.SectorName, "ADMINISTRATIVO", historyMap[r.CustomerID])
		
		if (i + 1) < len(readings) {
			m.AddRows(row.New(10))
		}
	}

	document, err := m.Generate()
	if err != nil {
		return nil, err
	}

	return g.applyWatermark(document.GetBytes())
}

func (g *MarotoGenerator) addReceiptComponents(m core.Maroto, reading *domain.Reading, customer *domain.Customer, settings *domain.Settings, community, sector string, copyType string, history []domain.Reading) {
	fontSmall := 7.0
	fontNormal := 8.5
	fontLarge := 11.0
	borderThick := 0.6 

	// ===== COPY TYPE & PERIOD LABEL (USUARIO/ADMINISTRATIVO - MES AÑO) =====
	labelText := fmt.Sprintf("%s - %s", copyType, formatPeriod(reading.Period))
	m.AddRows(
		row.New(4).Add(
			col.New(12).Add(
				text.New(labelText, props.Text{Right: 1, Top: 0.5, Size: fontNormal, Style: fontstyle.Bold, Align: align.Right}),
			),
		),
	)

	// ===== HEADER SECTION (3 COLUMNS: TEXT - LOGO - TEXT) =====
	m.AddRows(
		row.New(18).Add(
			col.New(4).Add(
				text.New(community, props.Text{Left: 1, Top: 1, Size: fontSmall}),
				text.New(fmt.Sprintf("Cód: %s", customer.Code), props.Text{Left: 1, Top: 3.5, Size: fontSmall, Style: fontstyle.Bold}),
				text.New(customer.Name, props.Text{Left: 1, Top: 6, Size: fontNormal, Style: fontstyle.Bold}),
				text.New(fmt.Sprintf("Impreso: %s", time.Now().Format("02/01/2006")), props.Text{
					Left: 1, 
					Top: func() float64 {
						if len(customer.Name) > 22 { return 11.5 }
						return 9.0
					}(), 
					Size: 5.5, 
					Style: fontstyle.Italic,
				}),
				text.New(customer.Address, props.Text{
					Left: 1, 
					Top: func() float64 {
						if len(customer.Name) > 22 { return 14.0 }
						return 11.5
					}(), 
					Size: fontSmall,
				}),
			).WithStyle(&props.Cell{BorderType: border.Left | border.Top, BorderThickness: borderThick, BorderColor: defaultBorderColor}),

			col.New(4).Add(
				mimage.NewFromFile(g.resolveLogoPath(), props.Rect{
					Center:  true,
					Percent: 75,
					Top:     0.5,
				}),
			).WithStyle(&props.Cell{BorderType: border.Top, BorderThickness: borderThick, BorderColor: defaultBorderColor}),

			col.New(4).Add(
				text.New(sector, props.Text{Right: 1, Top: 1, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				text.New(settings.Municipalidad, props.Text{Right: 1, Top: 3.5, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				text.New(settings.Empresa, props.Text{Right: 1, Top: 9.5, Size: fontSmall, Align: align.Right}),
			).WithStyle(&props.Cell{BorderType: border.Right | border.Top, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
		),
	)

	m.AddRows(
		row.New(0.5).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Bottom, BorderThickness: borderThick, BorderColor: defaultBorderColor})),
		row.New(0.5).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Bottom, BorderThickness: borderThick, BorderColor: defaultBorderColor})),
	)

	// ===== DATOS DEL SUMINISTRO Y CONSUMO TITLE =====
	m.AddRows(
		row.New(4.5).Add(
			col.New(12).Add(
				text.New("DATOS DEL SUMINISTRO Y CONSUMO", props.Text{Left: 3, Top: 0.5, Size: fontNormal, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Left | border.Right, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
		),
	)

	m.AddRows(
		row.New(0.5).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Bottom, BorderThickness: borderThick, BorderColor: defaultBorderColor})),
	)

	// ===== BODY SECTION =====
	m.AddRows(
		row.New(36).Add(
			col.New(5).Add(
				text.New("Tipo de Conexión:", props.Text{Left: 3, Top: 1, Size: fontSmall}),
				text.New(string(customer.ConnectionType), props.Text{Top: 1, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Tarifa:", props.Text{Left: 3, Top: 4, Size: fontSmall}),
				text.New(fmt.Sprintf("%.4f", settings.TarifaKWh), props.Text{Top: 4, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Medidor N°:", props.Text{Left: 3, Top: 7, Size: fontSmall}),
				text.New(customer.MeterNumber, props.Text{Top: 7, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Lectura Anterior:", props.Text{Left: 3, Top: 12, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.PreviousValue), props.Text{Top: 12, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Lectura Actual:", props.Text{Left: 3, Top: 15, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.CurrentValue), props.Text{Top: 15, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Consumo:", props.Text{Left: 3, Top: 20, Size: fontNormal, Style: fontstyle.Bold}),
				text.New(fmt.Sprintf("%.2f kWh", reading.Consumption), props.Text{Top: 20, Size: fontNormal, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Fecha de Emisión:", props.Text{Left: 3, Top: 23, Size: fontSmall}),
				text.New(formatDate(reading.Timestamp), props.Text{Top: 23, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Left, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
			
			col.New(2).Add(), // GAP
			
			col.New(5).Add(
				text.New(fmt.Sprintf("Recibo por Consumo del %s al %s", formatDateShort(reading.PeriodStart), formatDateShort(reading.PeriodEnd)), props.Text{Right: 3, Top: 1, Size: fontSmall, Align: align.Right}),
				
				text.New("Consumo (kWh x Tarifa):", props.Text{Top: 6, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.Consumption*settings.TarifaKWh), props.Text{Right: 3, Top: 6, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Cargo Fijo:", props.Text{Top: 9, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.CargoFijo), props.Text{Right: 3, Top: 9, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Alumbrado Público:", props.Text{Top: 12, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.AlumbradoPublico), props.Text{Right: 3, Top: 12, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Mantenimiento:", props.Text{Top: 15, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.Mantenimiento), props.Text{Right: 3, Top: 15, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("SUBTOTAL:", props.Text{Top: 19, Size: fontSmall, Style: fontstyle.Bold}),
				text.New(fmt.Sprintf("%.2f", reading.Subtotal), props.Text{Right: 3, Top: 19, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Saldo Anterior:", props.Text{Top: 23, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.PreviousBalance), props.Text{Right: 3, Top: 23, Size: fontSmall, Align: align.Right}),
				
				text.New("Recibos Vencidos:", props.Text{Top: 26, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.OverdueTotal), props.Text{Right: 3, Top: 26, Size: fontSmall, Align: align.Right}),
				
				text.New("TOTAL RECIBO:", props.Text{Top: 30, Size: fontNormal, Style: fontstyle.Bold}),
				text.New(fmt.Sprintf("S/ %.2f", reading.TotalToPay), props.Text{Right: 3, Top: 30, Size: fontNormal, Align: align.Right, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Right, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
		),
	)

	m.AddRows(row.New(1).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right, BorderThickness: borderThick, BorderColor: defaultBorderColor})))

	// ===== WARNING BOX =====
	m.AddRows(
		row.New(6).Add(
			col.New(1).WithStyle(&props.Cell{BorderType: border.Left, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
			col.New(10).Add(
				text.New("Si paga hasta la fecha de vencimiento evitará cortes y gastos innecesarios.", props.Text{Top: 1.5, Size: fontSmall, Align: align.Center, Style: fontstyle.Italic}),
			).WithStyle(&props.Cell{BorderType: border.Full, BorderThickness: 0.6, BorderColor: defaultBorderColor}),
			col.New(1).WithStyle(&props.Cell{BorderType: border.Right, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
		),
	)

	m.AddRows(row.New(1).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right, BorderThickness: borderThick, BorderColor: defaultBorderColor})))

	// ===== HISTORIAL DE CONSUMO Y ESTADO DE PAGO SECTION =====
	chartBytes := g.generateChartImage(history)
	
	var smileysHistory []domain.Reading
	for _, r := range history {
		if r.Period < reading.Period {
			smileysHistory = append(smileysHistory, r)
		}
	}
	smileysBytes := g.generateSmileysImage(smileysHistory)

	m.AddRows(
		row.New(6).Add(
			col.New(12).Add(
				text.New("HISTORIAL DE CONSUMO Y ESTADO DE PAGO", props.Text{Left: 3, Top: 1, Size: fontNormal, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Top, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
		),
	)

	m.AddRows(
		row.New(20).Add(
			col.New(8).Add(
				mimage.NewFromBytes(chartBytes, extension.Png, props.Rect{
					Center:  true,
					Percent: 95,
					Top:     0.5,
				}),
			).WithStyle(&props.Cell{BorderType: border.Left, BorderThickness: borderThick, BorderColor: defaultBorderColor}),

			col.New(4).Add(
				mimage.NewFromBytes(smileysBytes, extension.Png, props.Rect{
					Center:  true,
					Percent: 80,
					Top:     0.5,
				}),
				text.New("Estado de Pago (Últimos 3 Meses)", props.Text{Top: 14, Size: 6.0, Align: align.Center, Style: fontstyle.Italic}),
			).WithStyle(&props.Cell{BorderType: border.Right, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
		),
	)

	n := len(history)
	if n > 6 {
		n = 6
	}
	hist := make([]domain.Reading, n)
	for i := 0; i < n; i++ {
		hist[i] = history[n-1-i]
	}

	monthLabels := []string{"-", "-", "-", "-", "-", "-"}
	for i, r := range hist {
		slotIdx := 6 - len(hist) + i
		if t, err := time.Parse("2006-01", r.Period); err == nil {
			monthLabels[slotIdx] = shortMonthName(t.Month())
		}
	}

	m.AddRows(
		row.New(4).Add(
			col.New(1).Add().WithStyle(&props.Cell{BorderType: border.Left, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
			col.New(1).Add(text.New(monthLabels[0], props.Text{Size: 5.5, Align: align.Center})),
			col.New(1).Add(text.New(monthLabels[1], props.Text{Size: 5.5, Align: align.Center})),
			col.New(1).Add(text.New(monthLabels[2], props.Text{Size: 5.5, Align: align.Center})),
			col.New(1).Add(text.New(monthLabels[3], props.Text{Size: 5.5, Align: align.Center})),
			col.New(1).Add(text.New(monthLabels[4], props.Text{Size: 5.5, Align: align.Center})),
			col.New(1).Add(text.New(monthLabels[5], props.Text{Size: 5.5, Align: align.Center})),
			col.New(1).Add(),
			col.New(4).Add().WithStyle(&props.Cell{BorderType: border.Right, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
		),
	)

	m.AddRows(row.New(1).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right, BorderThickness: borderThick, BorderColor: defaultBorderColor})))

	// ===== TOTAL SECTION =====
	m.AddRows(
		row.New(7).Add(
			col.New(12).Add(
				text.New(fmt.Sprintf("TOTAL A PAGAR: S/ %.2f", reading.TotalToPay), props.Text{Right: 3, Top: 1, Size: fontLarge, Align: align.Right, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Left | border.Right, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
		),
	)

	m.AddRows(
		row.New(0.5).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Bottom, BorderThickness: borderThick, BorderColor: defaultBorderColor})),
	)

	// ===== EXPIRATION DATE =====
	m.AddRows(
		row.New(7).Add(
			col.New(12).Add(
				text.New(fmt.Sprintf("FECHA DE VENCIMIENTO: %s", formatDate(reading.ExpirationDate)), props.Text{Top: 1.5, Size: fontNormal, Align: align.Center, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Bottom, BorderThickness: borderThick, BorderColor: defaultBorderColor}),
		),
	)
}

func (g *MarotoGenerator) applyWatermark(pdfData []byte) ([]byte, error) {
	return pdfData, nil
}

func formatDate(t time.Time) string {
	if t.IsZero() {
		return "-"
	}
	return t.Format("02/01/2006")
}

func formatDateShort(t time.Time) string {
	if t.IsZero() {
		return "-"
	}
	return t.Format("02/01/2006")
}

func formatPeriod(period string) string {
	t, err := time.Parse("2006-01", period)
	if err != nil {
		return period
	}

	months := map[time.Month]string{
		time.January:   "ENERO",
		time.February:  "FEBRERO",
		time.March:     "MARZO",
		time.April:     "ABRIL",
		time.May:       "MAYO",
		time.June:      "JUNIO",
		time.July:      "JULIO",
		time.August:    "AGOSTO",
		time.September: "SEPTIEMBRE",
		time.October:   "OCTUBRE",
		time.November:  "NOVIEMBRE",
		time.December:  "DICIEMBRE",
	}

	monthStr := months[t.Month()]
	if monthStr == "" {
		monthStr = t.Month().String()
	}

	return fmt.Sprintf("%s %d", monthStr, t.Year())
}

func shortMonthName(m time.Month) string {
	months := map[time.Month]string{
		time.January:   "Ene",
		time.February:  "Feb",
		time.March:     "Mar",
		time.April:     "Abr",
		time.May:       "May",
		time.June:      "Jun",
		time.July:      "Jul",
		time.August:    "Ago",
		time.September: "Set",
		time.October:   "Oct",
		time.November:  "Nov",
		time.December:  "Dic",
	}
	return months[m]
}
