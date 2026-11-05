package pdf

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/johnfercher/go-tree/node"
	"github.com/johnfercher/maroto/v2/pkg/core"

	"github.com/infira/involt/backend/internal/domain"
)

func batchFixture(n int) ([]domain.Reading, map[string]*domain.Customer) {
	readings := make([]domain.Reading, n)
	customers := make(map[string]*domain.Customer, n)
	for i := range readings {
		id := fmt.Sprintf("C%d", i)
		readings[i] = domain.Reading{ID: "R" + id, CustomerID: id, Period: "2026-09", TotalToPay: 10, Timestamp: time.Date(2026, 10, 7, 0, 0, 0, 0, time.UTC)}
		customers[id] = &domain.Customer{Code: id, Name: "Cliente " + id, SectorName: "CACHIPAMPA"}
	}
	return readings, customers
}

// copyLabelsByPage returns the copy labels printed on each page of the document.
func copyLabelsByPage(root *node.Node[core.Structure]) [][]string {
	var pages [][]string
	var walk func(n *node.Node[core.Structure], labels *[]string)
	walk = func(n *node.Node[core.Structure], labels *[]string) {
		data := n.GetData()
		if value, ok := data.Value.(string); ok && data.Type == "text" {
			for _, copyType := range []string{"USUARIO", "ADMINISTRATIVO"} {
				if strings.HasPrefix(value, copyType+" - ") {
					*labels = append(*labels, copyType)
				}
			}
		}
		for _, next := range n.GetNexts() {
			walk(next, labels)
		}
	}
	for _, page := range root.GetNexts() {
		labels := []string{}
		walk(page, &labels)
		pages = append(pages, labels)
	}
	return pages
}

func TestBatchKeepsEachCopyLabelWithItsReceipt(t *testing.T) {
	cases := []struct {
		name   string
		copies string
		want   string
	}{
		{"duplicate", domain.ReceiptCopiesDuplicate, "[[USUARIO ADMINISTRATIVO] [USUARIO ADMINISTRATIVO] [USUARIO ADMINISTRATIVO]]"},
		{"single", domain.ReceiptCopiesSingle, "[[USUARIO USUARIO] [USUARIO]]"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			readings, customers := batchFixture(3)
			settings := &domain.Settings{ReceiptCopies: tc.copies, DiasVencimiento: 15}
			m := NewMarotoGenerator().buildBatch(readings, customers, settings, nil)
			if got := fmt.Sprint(copyLabelsByPage(m.GetStructure())); got != tc.want {
				t.Fatalf("labels by page = %s, want %s", got, tc.want)
			}
		})
	}
}

func TestReceiptCopyHeightMatchesItsRows(t *testing.T) {
	readings, customers := batchFixture(1)
	settings := &domain.Settings{ReceiptCopies: domain.ReceiptCopiesSingle, DiasVencimiento: 15}
	root := NewMarotoGenerator().buildBatch(readings, customers, settings, nil).GetStructure()

	rows := root.GetNexts()[0].GetNexts()
	var total float64
	for _, r := range rows[:len(rows)-1] { // the last row is the filler up to the end of the page
		total += r.GetData().Value.(float64)
	}
	if total != receiptCopyHeight {
		t.Fatalf("copy rows add up to %v mm, receiptCopyHeight is %v", total, receiptCopyHeight)
	}
}
