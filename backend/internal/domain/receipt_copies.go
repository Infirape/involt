package domain

// Receipt copy modes for the consumption receipt PDF.
const (
	ReceiptCopiesDuplicate = "DUPLICATE" // copia del usuario + copia administrativa (default)
	ReceiptCopiesSingle    = "SINGLE"    // solo la copia del suministro (usuario)
)

// NormalizeReceiptCopies maps unknown or empty values to the default (duplicate).
func NormalizeReceiptCopies(raw string) string {
	if raw == ReceiptCopiesSingle {
		return ReceiptCopiesSingle
	}
	return ReceiptCopiesDuplicate
}

// ReceiptCopyLabels lists the copies to print for each receipt, in order.
func (s Settings) ReceiptCopyLabels() []string {
	if NormalizeReceiptCopies(s.ReceiptCopies) == ReceiptCopiesSingle {
		return []string{"USUARIO"}
	}
	return []string{"USUARIO", "ADMINISTRATIVO"}
}
