package domain

// WithTotalDebt sets each sector's debt and debtors from every outstanding receipt, whatever the
// period range: a sector's debt must not depend on the months being looked at. Sectors with debt
// but no receipts in range are added.
func WithTotalDebt(sectors []SectorSummary, outstanding []ReceiptLine) []SectorSummary {
	out := make([]SectorSummary, len(sectors))
	index := make(map[string]int, len(sectors))
	for i, s := range sectors {
		s.Debt, s.Debtors = 0, 0
		out[i] = s
		index[s.SectorID] = i
	}

	cents := map[string]int64{}
	debtors := map[string]map[string]bool{}
	for _, l := range outstanding {
		b := l.balanceCents()
		if b == 0 {
			continue
		}
		if _, ok := index[l.SectorID]; !ok {
			index[l.SectorID] = len(out)
			out = append(out, SectorSummary{SectorID: l.SectorID, SectorName: l.SectorName, CommunityID: l.CommunityID, CommunityName: l.CommunityName})
		}
		cents[l.SectorID] += b
		if debtors[l.SectorID] == nil {
			debtors[l.SectorID] = map[string]bool{}
		}
		debtors[l.SectorID][l.CustomerID] = true
	}

	for id, i := range index {
		out[i].Debt = fromCents(cents[id])
		out[i].Debtors = len(debtors[id])
	}
	return out
}
