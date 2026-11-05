package domain

import "testing"

func debtFixture() []ReceiptLine {
	return []ReceiptLine{
		{ReadingID: "a9", CustomerID: "ana", SectorID: "s1", SectorName: "Patiño", CommunityName: "San Pablo", Period: "2026-09", Total: 10},
		{ReadingID: "a10", CustomerID: "ana", SectorID: "s1", SectorName: "Patiño", CommunityName: "San Pablo", Period: "2026-10", Total: 10},
		{ReadingID: "b10", CustomerID: "beto", SectorID: "s1", SectorName: "Patiño", CommunityName: "San Pablo", Period: "2026-10", Total: 10, Paid: 4},
		{ReadingID: "c9", CustomerID: "caro", SectorID: "s2", SectorName: "Tubo", CommunityName: "Chetilla", Period: "2026-09", Total: 5},
	}
}

func TestWithTotalDebtUsesEveryOutstandingReceipt(t *testing.T) {
	inRange := SummarizeBySector(debtFixture()[:1]) // only September of Patiño is in range

	got := WithTotalDebt(inRange, debtFixture()[:3])

	if len(got) != 1 || got[0].Debt != 26 || got[0].Debtors != 2 {
		t.Fatalf("sector = %+v, want debt 26 from 2 debtors across all periods", got)
	}
	if got[0].Billed != 10 || got[0].Customers != 1 {
		t.Fatalf("billing must stay within the range: %+v", got[0])
	}
}

func TestWithTotalDebtAddsSectorsWithoutReceiptsInRange(t *testing.T) {
	got := WithTotalDebt(SummarizeBySector(debtFixture()[:1]), debtFixture())

	if len(got) != 2 || got[1].SectorID != "s2" || got[1].SectorName != "Tubo" || got[1].CommunityName != "Chetilla" {
		t.Fatalf("sectors = %+v", got)
	}
	if got[1].Debt != 5 || got[1].Debtors != 1 || got[1].Billed != 0 {
		t.Fatalf("sector without receipts in range = %+v", got[1])
	}
}

func TestWithTotalDebtClearsSectorsWithNothingOutstanding(t *testing.T) {
	got := WithTotalDebt(SummarizeBySector(debtFixture()[:1]), nil)

	if got[0].Debt != 0 || got[0].Debtors != 0 {
		t.Fatalf("sector = %+v, want no debt", got[0])
	}
}
