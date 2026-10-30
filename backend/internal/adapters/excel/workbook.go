// Package excel renders collection reports as .xlsx workbooks with native Excel tables,
// charts and pivot tables.
package excel

import (
	"fmt"
	"image"
	_ "image/png" // decode the logo for AddPicture
	"os"
	"time"

	"github.com/xuri/excelize/v2"

	"github.com/infira/involt/backend/internal/adapters/assets"
	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

// Validated chart colors (dataviz validator, light mode): billed/primary and collected.
const (
	colorPrimary   = "2A78D6"
	colorSecondary = "EB6834"
	colorHeader    = "1F2937"
)

var lima = time.FixedZone("America/Lima", -5*60*60)

type Generator struct{}

func NewGenerator() *Generator { return &Generator{} }

// book wraps an excelize file with the shared styles.
type book struct {
	f                                          *excelize.File
	title, header, label, money, int, pct, day int
	moneyBold, kpiValue, kpiMoney, note        int
	section                                    int
	ledgerStyles                               map[cellStyle]int
	letterheads                                []string // sheets that get the logo beside the title
	logo                                       string   // company logo, relative to the assets dir
}

func newBook() (*book, error) {
	f := excelize.NewFile()
	b := &book{f: f}
	moneyFmt := `"S/" #,##0.00`
	pctFmt := "0.0%"
	dayFmt := "dd/mm/yyyy"
	styles := []struct {
		dst *int
		s   *excelize.Style
	}{
		{&b.title, &excelize.Style{Font: &excelize.Font{Bold: true, Size: 16, Color: colorHeader}}},
		{&b.header, &excelize.Style{Font: &excelize.Font{Bold: true, Color: "FFFFFF"},
			Fill: excelize.Fill{Type: "pattern", Pattern: 1, Color: []string{colorHeader}}}},
		{&b.label, &excelize.Style{Font: &excelize.Font{Bold: true, Color: "52514E"}}},
		{&b.money, &excelize.Style{CustomNumFmt: &moneyFmt}},
		{&b.moneyBold, &excelize.Style{CustomNumFmt: &moneyFmt, Font: &excelize.Font{Bold: true}}},
		{&b.int, &excelize.Style{NumFmt: 3}},
		{&b.pct, &excelize.Style{CustomNumFmt: &pctFmt}},
		{&b.day, &excelize.Style{CustomNumFmt: &dayFmt}},
		{&b.kpiValue, &excelize.Style{Font: &excelize.Font{Bold: true, Size: 14}}},
		{&b.kpiMoney, &excelize.Style{Font: &excelize.Font{Bold: true, Size: 14}, CustomNumFmt: &moneyFmt}},
		{&b.note, &excelize.Style{Font: &excelize.Font{Italic: true, Color: "898781", Size: 9}}},
		{&b.section, &excelize.Style{Font: &excelize.Font{Bold: true, Size: 12, Color: colorHeader},
			Fill: excelize.Fill{Type: "pattern", Pattern: 1, Color: []string{"E5E7EB"}}}},
	}
	for _, st := range styles {
		id, err := f.NewStyle(st.s)
		if err != nil {
			return nil, err
		}
		*st.dst = id
	}
	return b, nil
}

func cell(col, row int) string {
	name, _ := excelize.CoordinatesToCellName(col, row)
	return name
}

func colName(col int) string {
	name, _ := excelize.ColumnNumberToName(col)
	return name
}

// writeHeader prints the letterhead (municipal logo, then title, entity and generation date
// beside it from column B) and the filters; returns the next free row.
func (b *book) writeHeader(sheet string, meta ports.WorkbookMeta) int {
	f := b.f
	// No gridlines: they would cross the floating logo; tables keep their own borders.
	_ = f.SetSheetView(sheet, 0, &excelize.ViewOptions{ShowGridLines: boolPtr(false)})
	b.letterheads = append(b.letterheads, sheet) // logo placed in bytes(), once column A is sized
	b.logo = meta.Logo
	_ = f.SetCellValue(sheet, "B1", meta.Title)
	_ = f.SetCellStyle(sheet, "B1", "B1", b.title)
	_ = f.SetCellValue(sheet, "B2", fmt.Sprintf("%s · %s", meta.Entity, meta.Company))
	_ = f.SetCellValue(sheet, "B3", fmt.Sprintf("Generado el %s por %s",
		meta.GeneratedAt.In(lima).Format("02/01/2006 15:04"), meta.GeneratedBy))
	_ = f.SetCellStyle(sheet, "B2", "B3", b.note)
	row := 5
	for _, kv := range meta.Filters {
		_ = f.SetCellValue(sheet, cell(1, row), kv[0])
		_ = f.SetCellStyle(sheet, cell(1, row), cell(1, row), b.label)
		_ = f.SetCellValue(sheet, cell(2, row), kv[1])
		row++
	}
	return row + 1
}

// kpi is a label/value pair; money values get the soles format.
type kpi struct {
	label string
	value any
	money bool
}

// writeKPIs prints a two-column block of headline numbers; returns the next free row.
func (b *book) writeKPIs(sheet string, row int, kpis []kpi) int {
	for _, k := range kpis {
		_ = b.f.SetCellValue(sheet, cell(1, row), k.label)
		_ = b.f.SetCellStyle(sheet, cell(1, row), cell(1, row), b.label)
		_ = b.f.SetCellValue(sheet, cell(2, row), k.value)
		style := b.kpiValue
		if k.money {
			style = b.kpiMoney
		}
		_ = b.f.SetCellStyle(sheet, cell(2, row), cell(2, row), style)
		row++
	}
	return row + 1
}

// column describes a table column: header text, width and cell style (0 = general).
type column struct {
	name  string
	width float64
	style int
}

// writeTable writes header + rows starting at (1,row) and turns them into an Excel table with
// autofilter. Returns the table range (e.g. "A10:F25") and the next free row.
func (b *book) writeTable(sheet, name string, row int, cols []column, rows [][]any) (string, int, error) {
	f := b.f
	for i, c := range cols {
		_ = f.SetCellValue(sheet, cell(i+1, row), c.name)
		if c.width > 0 {
			_ = f.SetColWidth(sheet, colName(i+1), colName(i+1), c.width)
		}
	}
	for r, values := range rows {
		if err := f.SetSheetRow(sheet, cell(1, row+1+r), &values); err != nil {
			return "", 0, err
		}
	}
	last := row + len(rows)
	if len(rows) == 0 {
		last = row + 1 // tables need at least one data row
	}
	for i, c := range cols {
		if c.style != 0 {
			_ = f.SetCellStyle(sheet, cell(i+1, row+1), cell(i+1, last), c.style)
		}
	}
	ref := fmt.Sprintf("%s:%s", cell(1, row), cell(len(cols), last))
	err := f.AddTable(sheet, &excelize.Table{Range: ref, Name: name, StyleName: "TableStyleMedium2", ShowRowStripes: boolPtr(true)})
	return ref, last + 2, err
}

func boolPtr(v bool) *bool { return &v }

// barChart adds a column chart over a table: categories in catCol, one series per valueCols
// entry. Only vertical columns are used: excelize writes horizontal bar charts with column-chart
// axis positions, and Numbers crashes when activating a sheet that contains one.
func (b *book) barChart(sheet, anchor, title string, chartType excelize.ChartType, headerRow, firstRow, lastRow, catCol int, valueCols []int) error {
	if lastRow < firstRow {
		return nil
	}
	colors := []string{colorPrimary, colorSecondary}
	var series []excelize.ChartSeries
	for i, vc := range valueCols {
		series = append(series, excelize.ChartSeries{
			Name:       fmt.Sprintf("'%s'!$%s$%d", sheet, colName(vc), headerRow),
			Categories: fmt.Sprintf("'%s'!$%s$%d:$%s$%d", sheet, colName(catCol), firstRow, colName(catCol), lastRow),
			Values:     fmt.Sprintf("'%s'!$%s$%d:$%s$%d", sheet, colName(vc), firstRow, colName(vc), lastRow),
			Fill:       excelize.Fill{Type: "pattern", Pattern: 1, Color: []string{colors[i%len(colors)]}},
		})
	}
	legend := excelize.ChartLegend{Position: "bottom"}
	if len(series) == 1 {
		legend.Position = "none"
	}
	return b.f.AddChart(sheet, anchor, &excelize.Chart{
		Type:       chartType,
		VaryColors: boolPtr(false), // per-point colors break Numbers' series styling

		Series:    series,
		Title:     []excelize.RichTextRun{{Text: title}},
		Legend:    legend,
		Dimension: excelize.ChartDimension{Width: 560, Height: 300},
		PlotArea:  excelize.ChartPlotArea{ShowVal: len(series) == 1},
		YAxis:     excelize.ChartAxis{MajorGridLines: true},
	})
}

// pivot adds a pivot table if the data range has rows; otherwise leaves a note.
func (b *book) pivot(sheet, at, dataRange, name string, hasRows bool, rows, cols, data []excelize.PivotTableField) error {
	if !hasRows {
		_ = b.f.SetCellValue(sheet, at, "Sin datos para la tabla dinámica.")
		return nil
	}
	return b.f.AddPivotTable(&excelize.PivotTableOptions{
		DataRange:           dataRange,
		PivotTableRange:     pivotRange(sheet, at),
		Name:                name,
		Rows:                rows,
		Columns:             cols,
		Data:                data,
		RowGrandTotals:      true,
		ColGrandTotals:      true,
		ShowDrill:           true,
		ShowRowHeaders:      true,
		ShowColHeaders:      true,
		ShowLastColumn:      true,
		PivotTableStyleName: "PivotStyleMedium9",
	})
}

// pivotRange gives the pivot a generous target area; Excel resizes it on refresh.
func pivotRange(sheet, at string) string {
	col, row, _ := excelize.CellNameToCoordinates(at)
	return fmt.Sprintf("%s!%s:%s", sheet, at, cell(col+7, row+40))
}

// freezeHeader keeps the header rows visible. The explicit selection mirrors what Excel itself
// writes for frozen panes; without it some Excel builds crash when activating the sheet.
// Don't freeze sheets that also hold charts.
func (b *book) freezeHeader(sheet string, row int) {
	first := cell(1, row+1)
	_ = b.f.SetPanes(sheet, &excelize.Panes{
		Freeze: true, YSplit: row, TopLeftCell: first, ActivePane: "bottomLeft",
		Selection: []excelize.Selection{{SQRef: first, ActiveCell: first, Pane: "bottomLeft"}},
	})
}

// logoPath finds the company logo, falling back to the InVolt one ("" if neither exists).
func (b *book) logoPath() string {
	if p := assets.Path(b.logo); b.logo != "" && p != "" {
		return p
	}
	return assets.Path(domain.DefaultLogo)
}

// logoSize returns the pixel size of the image at path (0, 0 if it can't be read).
func logoSize(path string) (int, int) {
	file, err := os.Open(path)
	if err != nil {
		return 0, 0
	}
	defer file.Close()
	cfg, _, err := image.DecodeConfig(file)
	if err != nil {
		return 0, 0
	}
	return cfg.Width, cfg.Height
}

// addLogo floats the company logo at cell, scaled to heightPx (no-op if no logo is found).
func (b *book) addLogo(sheet, at string, heightPx float64, offsetX, offsetY int) {
	path := b.logoPath()
	_, height := logoSize(path)
	if height == 0 {
		return
	}
	scale := heightPx / float64(height)
	_ = b.f.AddPicture(sheet, at, path, &excelize.GraphicOptions{
		ScaleX: scale, ScaleY: scale, OffsetX: offsetX, OffsetY: offsetY,
		Positioning: "oneCell", LockAspectRatio: true, AltText: "Logo",
	})
}

// letterheadLogoPx is the logo height beside the title (rows 1-3).
const letterheadLogoPx = 62

// placeLetterheadLogos puts the logo flush right in column A, right next to the title in B.
// Column widths are in characters; ~7 px each plus padding (Calibri 11).
func (b *book) placeLetterheadLogos() {
	width, height := logoSize(b.logoPath())
	if height == 0 {
		return
	}
	logoWidth := letterheadLogoPx * width / height
	for _, sheet := range b.letterheads {
		chars, _ := b.f.GetColWidth(sheet, "A")
		colPx := int(chars*7 + 5)
		b.addLogo(sheet, "A1", letterheadLogoPx, max(2, colPx-logoWidth-8), 2)
	}
}

func (b *book) bytes() ([]byte, error) {
	b.placeLetterheadLogos()
	b.f.SetActiveSheet(0)
	buf, err := b.f.WriteToBuffer()
	if err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
