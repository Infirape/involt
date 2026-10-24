package excel

import "github.com/xuri/excelize/v2"

// Ledger palette, after the accounting ledger template treasury uses.
const (
	ledgerTitle     = "4A86C8"
	ledgerNavy      = "333F4F"
	ledgerSteel     = "8497B0"
	ledgerCharcoal  = "404040"
	ledgerGroupBlue = "D9E1F2"
	ledgerGroupGray = "D0CECE"
	ledgerSection   = "F2F2F2"
	ledgerZebra     = "EAEEF3"
	ledgerAccGray   = "D9D9D9"
	ledgerAccBlue   = "C9D3E0"
	ledgerBorder    = "D9D9D9"
)

// Accounting format: "S/" pinned left, zero shown as "-".
const ledgerMoney = `_("S/"* #,##0.00_);_("S/"* (#,##0.00);_("S/"* "-"??_);_(@_)`

// cellStyle describes a ledger cell; styles are created once per distinct description.
type cellStyle struct {
	fill, color     string
	bold, italic    bool
	size            float64
	align           string // left (default), center, right
	money, day      bool
	wrap            bool
	topRule, border bool
}

func (b *book) ledger(s cellStyle) int {
	if id, ok := b.ledgerStyles[s]; ok {
		return id
	}
	st := &excelize.Style{
		Font:      &excelize.Font{Bold: s.bold, Italic: s.italic, Size: s.size, Color: s.color},
		Alignment: &excelize.Alignment{Horizontal: s.align, Vertical: "center", WrapText: s.wrap},
	}
	if s.size == 0 {
		st.Font.Size = 10
	}
	if s.fill != "" {
		st.Fill = excelize.Fill{Type: "pattern", Pattern: 1, Color: []string{s.fill}}
	}
	if s.money {
		f := ledgerMoney
		st.CustomNumFmt = &f
	}
	if s.day {
		f := "dd/mm/yyyy"
		st.CustomNumFmt = &f
	}
	if s.border {
		st.Border = []excelize.Border{
			{Type: "left", Color: ledgerBorder, Style: 1}, {Type: "right", Color: ledgerBorder, Style: 1},
			{Type: "bottom", Color: ledgerBorder, Style: 1},
		}
	}
	if s.topRule {
		st.Border = append(st.Border, excelize.Border{Type: "top", Color: ledgerNavy, Style: 2})
	}
	id, _ := b.f.NewStyle(st)
	if b.ledgerStyles == nil {
		b.ledgerStyles = map[cellStyle]int{}
	}
	b.ledgerStyles[s] = id
	return id
}

// paint applies a style to a single cell.
func (b *book) paint(sheet string, col, row int, s cellStyle) {
	_ = b.f.SetCellStyle(sheet, cell(col, row), cell(col, row), b.ledger(s))
}

// band merges and styles a horizontal range, writing value into its first cell.
func (b *book) band(sheet string, fromCol, toCol, row int, value any, s cellStyle) {
	if fromCol != toCol {
		_ = b.f.MergeCell(sheet, cell(fromCol, row), cell(toCol, row))
	}
	_ = b.f.SetCellValue(sheet, cell(fromCol, row), value)
	_ = b.f.SetCellStyle(sheet, cell(fromCol, row), cell(toCol, row), b.ledger(s))
}
