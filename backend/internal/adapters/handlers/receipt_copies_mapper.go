package handlers

import (
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

func receiptCopiesToProto(raw string) involtv1.ReceiptCopies {
	if domain.NormalizeReceiptCopies(raw) == domain.ReceiptCopiesSingle {
		return involtv1.ReceiptCopies_RECEIPT_COPIES_SINGLE
	}
	return involtv1.ReceiptCopies_RECEIPT_COPIES_DUPLICATE
}

// receiptCopiesFromProto treats UNSPECIFIED (older clients) as duplicate.
func receiptCopiesFromProto(c involtv1.ReceiptCopies) string {
	if c == involtv1.ReceiptCopies_RECEIPT_COPIES_SINGLE {
		return domain.ReceiptCopiesSingle
	}
	return domain.ReceiptCopiesDuplicate
}
