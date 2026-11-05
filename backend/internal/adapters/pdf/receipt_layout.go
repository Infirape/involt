package pdf

import (
	"github.com/johnfercher/maroto/v2/pkg/components/page"
	"github.com/johnfercher/maroto/v2/pkg/core"
)

const (
	// receiptCopyHeight is the total height in mm of the rows addReceiptComponents prints.
	receiptCopyHeight = 115.5
	// receiptCutLineHeight is the gap in mm holding the cut line between two copies.
	receiptCutLineHeight = 8.0
)

// fitsOrBreaksPage starts a new page unless a whole copy (label included) fits in the current one,
// so a label is never left alone at the bottom of a page. It reports whether the copy stayed on
// the current page.
func fitsOrBreaksPage(m core.Maroto, height float64) bool {
	if m.FitlnCurrentPage(height) {
		return true
	}
	m.AddPages(page.New())
	return false
}
