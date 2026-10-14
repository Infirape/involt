package domain

import (
	"testing"
	"time"
)

var reportToday = time.Date(2026, 10, 13, 0, 0, 0, 0, time.UTC)

func day(y int, m time.Month, d int) time.Time { return time.Date(y, m, d, 0, 0, 0, 0, time.UTC) }

func reportFixture() []ReceiptLine {
	return []ReceiptLine{
		// Ana: two overdue receipts (one partially paid) → cut candidate.
		{ReadingID: "a1", CustomerID: "ana", CustomerName: "Ana", SectorID: "s1", SectorName: "Centro", Period: "2026-06", Total: 10, Paid: 0, ExpirationDate: day(2026, 7, 15)},
		{ReadingID: "a2", CustomerID: "ana", CustomerName: "Ana", SectorID: "s1", SectorName: "Centro", Period: "2026-08", Total: 10, Paid: 4, ExpirationDate: day(2026, 9, 15)},
		{ReadingID: "a3", CustomerID: "ana", CustomerName: "Ana", SectorID: "s1", SectorName: "Centro", Period: "2026-09", Total: 10, Paid: 0, ExpirationDate: day(2026, 10, 15)},
		// Beto: fully paid.
		{ReadingID: "b1", CustomerID: "beto", CustomerName: "Beto", SectorID: "s1", SectorName: "Centro", Period: "2026-09", Total: 8, Paid: 8, ExpirationDate: day(2026, 10, 15)},
		// Caro: one receipt 1-30 days overdue, other sector.
		{ReadingID: "c1", CustomerID: "caro", CustomerName: "Caro", SectorID: "s2", SectorName: "Alto", Period: "2026-08", Total: 12, Paid: 0, ExpirationDate: day(2026, 9, 20)},
	}
}

func TestClassifyAging(t *testing.T) {
	cases := []struct {
		expiration time.Time
		want       AgingBucket
	}{
		{day(2026, 10, 13), AgingCurrent}, // due today
		{time.Time{}, AgingCurrent},       // no due date
		{day(2026, 10, 12), Aging1To30},
		{day(2026, 9, 13), Aging1To30}, // 30 days
		{day(2026, 9, 12), Aging31To60},
		{day(2026, 8, 14), Aging31To60}, // 60 days
		{day(2026, 7, 15), Aging61To90}, // 90 days
		{day(2026, 7, 14), AgingOver90},
	}
	for _, tc := range cases {
		if got := ClassifyAging(tc.expiration, reportToday); got != tc.want {
			t.Errorf("ClassifyAging(%s) = %s, want %s", tc.expiration.Format("2006-01-02"), got, tc.want)
		}
	}
}

func TestBuildAgingSumsOutstandingBalances(t *testing.T) {
	aging := BuildAging(reportFixture(), reportToday)

	byBucket := map[AgingBucket]AgingTotal{}
	for _, a := range aging {
		byBucket[a.Bucket] = a
	}
	if len(aging) != 5 {
		t.Fatalf("aging should list all 5 buckets in order, got %d", len(aging))
	}
	if aging[0].Bucket != AgingCurrent || aging[4].Bucket != AgingOver90 {
		t.Fatalf("bucket order = %v ... %v", aging[0].Bucket, aging[4].Bucket)
	}
	if got := byBucket[AgingCurrent]; got.Amount != 10 || got.Receipts != 1 || got.Customers != 1 {
		t.Fatalf("current = %+v, want 10 / 1 receipt / 1 customer (Ana Sep)", got)
	}
	if got := byBucket[Aging1To30]; got.Amount != 18 || got.Receipts != 2 || got.Customers != 2 {
		t.Fatalf("1-30 = %+v, want 18 (Ana Aug 6 + Caro 12)", got)
	}
	if got := byBucket[Aging61To90]; got.Amount != 10 || got.Customers != 1 {
		t.Fatalf("61-90 = %+v, want Ana Jun 10", got)
	}
}

func TestSummarizeBySector(t *testing.T) {
	sectors := SummarizeBySector(reportFixture())
	if len(sectors) != 2 || sectors[0].SectorID != "s1" {
		t.Fatalf("sectors = %+v (expected highest billed first)", sectors)
	}
	s1 := sectors[0]
	if s1.Billed != 38 || s1.Collected != 12 || s1.Debt != 26 || s1.Customers != 2 || s1.Debtors != 1 {
		t.Fatalf("s1 = %+v", s1)
	}
}

func TestSummarizeByPeriod(t *testing.T) {
	periods := SummarizeByPeriod(reportFixture())
	if len(periods) != 3 || periods[0].Period != "2026-06" || periods[2].Period != "2026-09" {
		t.Fatalf("periods = %+v (expected chronological)", periods)
	}
	if aug := periods[1]; aug.Billed != 22 || aug.Collected != 4 {
		t.Fatalf("aug = %+v, want billed 22 collected 4", aug)
	}
}

func TestBuildDebtors(t *testing.T) {
	lastPaid := map[string]time.Time{"ana": day(2026, 9, 1)}
	debtors := BuildDebtors(reportFixture(), lastPaid, reportToday, 2)

	if len(debtors) != 2 || debtors[0].CustomerID != "ana" {
		t.Fatalf("debtors = %+v (expected Ana first by debt, Beto excluded)", debtors)
	}
	ana := debtors[0]
	if ana.TotalDebt != 26 || ana.OverdueDebt != 16 || ana.OverdueReceipts != 2 || ana.PendingReceipts != 3 {
		t.Fatalf("ana = %+v", ana)
	}
	if ana.OldestOverduePeriod != "2026-06" || ana.DaysOverdue != 90 || !ana.CutCandidate {
		t.Fatalf("ana overdue info = %+v", ana)
	}
	if !ana.LastPaymentAt.Equal(day(2026, 9, 1)) {
		t.Fatalf("ana last payment = %v", ana.LastPaymentAt)
	}
	caro := debtors[1]
	if caro.CutCandidate || caro.OverdueReceipts != 1 || caro.DaysOverdue != 23 {
		t.Fatalf("caro = %+v", caro)
	}
}
