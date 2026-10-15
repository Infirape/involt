package domain

import (
	"sort"
	"time"
)

// ReceiptLine is a receipt (reading) with its customer/sector context and paid amount,
// the raw material for collection reports.
type ReceiptLine struct {
	ReadingID      string    `db:"reading_id"`
	CustomerID     string    `db:"customer_id"`
	CustomerCode   string    `db:"customer_code"`
	CustomerName   string    `db:"customer_name"`
	SectorID       string    `db:"sector_id"`
	SectorName     string    `db:"sector_name"`
	CommunityID    string    `db:"community_id"`
	CommunityName  string    `db:"community_name"`
	Period         string    `db:"period"`
	Total          float64   `db:"total"`
	Paid           float64   `db:"paid"`
	ExpirationDate time.Time `db:"expiration_date"`
}

func (l ReceiptLine) balanceCents() int64 {
	b := toCents(l.Total) - toCents(l.Paid)
	if b < 0 {
		return 0
	}
	return b
}

func (l ReceiptLine) collectedCents() int64 {
	return min(toCents(l.Paid), toCents(l.Total))
}

// AgingBucket groups outstanding balances by how long they have been overdue.
type AgingBucket string

const (
	AgingCurrent AgingBucket = "CURRENT"
	Aging1To30   AgingBucket = "1_30"
	Aging31To60  AgingBucket = "31_60"
	Aging61To90  AgingBucket = "61_90"
	AgingOver90  AgingBucket = "OVER_90"
)

var agingOrder = []AgingBucket{AgingCurrent, Aging1To30, Aging31To60, Aging61To90, AgingOver90}

// DaysOverdue returns whole calendar days past the due date (0 if not yet due or no due date).
func DaysOverdue(expiration, today time.Time) int {
	if expiration.IsZero() {
		return 0
	}
	t := time.Date(today.Year(), today.Month(), today.Day(), 0, 0, 0, 0, time.UTC)
	e := time.Date(expiration.Year(), expiration.Month(), expiration.Day(), 0, 0, 0, 0, time.UTC)
	days := int(t.Sub(e).Hours() / 24)
	if days < 0 {
		return 0
	}
	return days
}

// ClassifyAging places a receipt's due date into an aging bucket.
func ClassifyAging(expiration, today time.Time) AgingBucket {
	switch d := DaysOverdue(expiration, today); {
	case d == 0:
		return AgingCurrent
	case d <= 30:
		return Aging1To30
	case d <= 60:
		return Aging31To60
	case d <= 90:
		return Aging61To90
	default:
		return AgingOver90
	}
}

type AgingTotal struct {
	Bucket    AgingBucket
	Amount    float64
	Receipts  int
	Customers int
}

// BuildAging sums outstanding balances per bucket; all buckets are returned in order.
func BuildAging(lines []ReceiptLine, today time.Time) []AgingTotal {
	cents := map[AgingBucket]int64{}
	receipts := map[AgingBucket]int{}
	customers := map[AgingBucket]map[string]bool{}
	for _, l := range lines {
		b := l.balanceCents()
		if b == 0 {
			continue
		}
		bucket := ClassifyAging(l.ExpirationDate, today)
		cents[bucket] += b
		receipts[bucket]++
		if customers[bucket] == nil {
			customers[bucket] = map[string]bool{}
		}
		customers[bucket][l.CustomerID] = true
	}
	out := make([]AgingTotal, 0, len(agingOrder))
	for _, bucket := range agingOrder {
		out = append(out, AgingTotal{
			Bucket: bucket, Amount: fromCents(cents[bucket]),
			Receipts: receipts[bucket], Customers: len(customers[bucket]),
		})
	}
	return out
}

type SectorSummary struct {
	SectorID      string
	SectorName    string
	CommunityID   string
	CommunityName string
	Billed        float64
	Collected     float64
	Debt          float64
	Customers     int // customers with at least one receipt in range
	Debtors       int // customers with outstanding balance in range
}

// SummarizeBySector aggregates billed/collected/debt per sector, highest billed first.
func SummarizeBySector(lines []ReceiptLine) []SectorSummary {
	type acc struct {
		summary                SectorSummary
		billed, collected, due int64
		customers, debtors     map[string]bool
	}
	bySector := map[string]*acc{}
	for _, l := range lines {
		a, ok := bySector[l.SectorID]
		if !ok {
			a = &acc{
				summary:   SectorSummary{SectorID: l.SectorID, SectorName: l.SectorName, CommunityID: l.CommunityID, CommunityName: l.CommunityName},
				customers: map[string]bool{}, debtors: map[string]bool{},
			}
			bySector[l.SectorID] = a
		}
		a.billed += toCents(l.Total)
		a.collected += l.collectedCents()
		a.due += l.balanceCents()
		a.customers[l.CustomerID] = true
		if l.balanceCents() > 0 {
			a.debtors[l.CustomerID] = true
		}
	}
	out := make([]SectorSummary, 0, len(bySector))
	for _, a := range bySector {
		s := a.summary
		s.Billed, s.Collected, s.Debt = fromCents(a.billed), fromCents(a.collected), fromCents(a.due)
		s.Customers, s.Debtors = len(a.customers), len(a.debtors)
		out = append(out, s)
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Billed != out[j].Billed {
			return out[i].Billed > out[j].Billed
		}
		return out[i].SectorName < out[j].SectorName
	})
	return out
}

type PeriodSummary struct {
	Period    string
	Billed    float64
	Collected float64
}

// SummarizeByPeriod aggregates billed vs collected per billing period, chronologically.
func SummarizeByPeriod(lines []ReceiptLine) []PeriodSummary {
	billed := map[string]int64{}
	collected := map[string]int64{}
	for _, l := range lines {
		billed[l.Period] += toCents(l.Total)
		collected[l.Period] += l.collectedCents()
	}
	out := make([]PeriodSummary, 0, len(billed))
	for p := range billed {
		out = append(out, PeriodSummary{Period: p, Billed: fromCents(billed[p]), Collected: fromCents(collected[p])})
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Period < out[j].Period })
	return out
}

// Debtor is a customer with outstanding balance and how late they are.
type Debtor struct {
	CustomerID          string
	CustomerCode        string
	CustomerName        string
	SectorID            string
	SectorName          string
	CommunityName       string
	TotalDebt           float64
	OverdueDebt         float64
	PendingReceipts     int
	OverdueReceipts     int
	OldestOverduePeriod string
	DaysOverdue         int
	LastPaymentAt       time.Time
	CutCandidate        bool
}

// BuildDebtors lists customers with outstanding balance, highest debt first. A customer is a
// service-cut candidate when they have at least cutThreshold overdue receipts.
func BuildDebtors(lines []ReceiptLine, lastPayments map[string]time.Time, today time.Time, cutThreshold int) []Debtor {
	type acc struct {
		debtor            Debtor
		total, overdue    int64
		oldestOverdueDate time.Time
	}
	byCustomer := map[string]*acc{}
	for _, l := range lines {
		b := l.balanceCents()
		if b == 0 {
			continue
		}
		a, ok := byCustomer[l.CustomerID]
		if !ok {
			a = &acc{debtor: Debtor{
				CustomerID: l.CustomerID, CustomerCode: l.CustomerCode, CustomerName: l.CustomerName,
				SectorID: l.SectorID, SectorName: l.SectorName, CommunityName: l.CommunityName,
			}}
			byCustomer[l.CustomerID] = a
		}
		a.total += b
		a.debtor.PendingReceipts++
		if DaysOverdue(l.ExpirationDate, today) > 0 {
			a.overdue += b
			a.debtor.OverdueReceipts++
			if a.oldestOverdueDate.IsZero() || l.ExpirationDate.Before(a.oldestOverdueDate) {
				a.oldestOverdueDate = l.ExpirationDate
				a.debtor.OldestOverduePeriod = l.Period
			}
		}
	}

	out := make([]Debtor, 0, len(byCustomer))
	for id, a := range byCustomer {
		d := a.debtor
		d.TotalDebt, d.OverdueDebt = fromCents(a.total), fromCents(a.overdue)
		d.DaysOverdue = DaysOverdue(a.oldestOverdueDate, today)
		d.LastPaymentAt = lastPayments[id]
		d.CutCandidate = cutThreshold > 0 && d.OverdueReceipts >= cutThreshold
		out = append(out, d)
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].TotalDebt != out[j].TotalDebt {
			return out[i].TotalDebt > out[j].TotalDebt
		}
		return out[i].CustomerName < out[j].CustomerName
	})
	return out
}

// CustomerLine is a supply (suministro) with its location, for exhaustive reports.
type CustomerLine struct {
	CustomerID    string `db:"customer_id"`
	CustomerCode  string `db:"customer_code"`
	CustomerName  string `db:"customer_name"`
	CommunityName string `db:"community_name"`
	SectorName    string `db:"sector_name"`
}

// PaymentLine is one non-voided payment allocation with its payment and customer context.
type PaymentLine struct {
	ReceiptNumber    int64     `db:"receipt_number"`
	PaidAt           time.Time `db:"paid_at"`
	Method           string    `db:"method"`
	CollectedByEmail string    `db:"collected_by_email"`
	CustomerCode     string    `db:"customer_code"`
	CustomerName     string    `db:"customer_name"`
	CommunityName    string    `db:"community_name"`
	SectorName       string    `db:"sector_name"`
	Period           string    `db:"period"`
	Amount           float64   `db:"amount"`
	LateFee          float64   `db:"late_fee"`
}
