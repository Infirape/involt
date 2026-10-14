package pdf

import (
	"context"
	"fmt"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/johnfercher/maroto/v2"
	"github.com/johnfercher/maroto/v2/pkg/components/col"
	mimage "github.com/johnfercher/maroto/v2/pkg/components/image"
	"github.com/johnfercher/maroto/v2/pkg/components/row"
	"github.com/johnfercher/maroto/v2/pkg/components/text"
	"github.com/johnfercher/maroto/v2/pkg/config"
	"github.com/johnfercher/maroto/v2/pkg/consts/align"
	"github.com/johnfercher/maroto/v2/pkg/consts/border"
	"github.com/johnfercher/maroto/v2/pkg/consts/fontstyle"
	"github.com/johnfercher/maroto/v2/pkg/consts/pagesize"
	"github.com/johnfercher/maroto/v2/pkg/core"
	"github.com/johnfercher/maroto/v2/pkg/props"
)

// voucherZone prints payment times in Peru local time (UTC-5, no DST).
var voucherZone = time.FixedZone("America/Lima", -5*60*60)

var voidedColor = &props.Color{Red: 200, Green: 30, Blue: 30}

func paymentMethodLabel(method string) string {
	switch domain.PaymentMethod(method) {
	case domain.PaymentMethodCash:
		return "Efectivo"
	case domain.PaymentMethodYape:
		return "Yape"
	case domain.PaymentMethodPlin:
		return "Plin"
	case domain.PaymentMethodTransfer:
		return "Transferencia"
	case domain.PaymentMethodOther:
		return "Otro"
	}
	return method
}

// GenerateVoucher renders the proof of payment (A5) handed to the customer at the cash desk.
func (g *MarotoGenerator) GenerateVoucher(_ context.Context, payment *domain.Payment, customer *domain.Customer, settings *domain.Settings) ([]byte, error) {
	cfg := config.NewBuilder().
		WithPageSize(pagesize.A5).
		WithLeftMargin(12).
		WithRightMargin(12).
		WithTopMargin(10).
		Build()
	m := maroto.New(cfg)

	g.addVoucherHeader(m, payment, settings)
	addVoucherDetails(m, payment, customer)
	addVoucherAllocations(m, payment)
	addVoucherFooter(m, payment)

	document, err := m.Generate()
	if err != nil {
		return nil, fmt.Errorf("error generating payment voucher: %w", err)
	}
	return document.GetBytes(), nil
}

func (g *MarotoGenerator) addVoucherHeader(m core.Maroto, payment *domain.Payment, settings *domain.Settings) {
	ruc := ""
	if settings.RUC != "" {
		ruc = "RUC " + settings.RUC
	}
	m.AddRows(row.New(20).Add(
		col.New(3).Add(mimage.NewFromFile(g.resolveLogoPath(), props.Rect{Center: true, Percent: 90})),
		col.New(9).Add(
			text.New(settings.Municipalidad, props.Text{Top: 2, Size: 9, Style: fontstyle.Bold, Align: align.Right}),
			text.New(settings.Empresa, props.Text{Top: 7, Size: 8, Align: align.Right}),
			text.New(ruc, props.Text{Top: 11, Size: 7, Align: align.Right}),
			text.New(settings.Direccion, props.Text{Top: 14.5, Size: 7, Align: align.Right}),
		),
	))

	m.AddRows(row.New(12).Add(
		col.New(12).Add(
			text.New("COMPROBANTE DE PAGO", props.Text{Top: 1.5, Size: 12, Style: fontstyle.Bold, Align: align.Center}),
			text.New(fmt.Sprintf("N° %06d", payment.ReceiptNumber), props.Text{Top: 7, Size: 10, Style: fontstyle.Bold, Align: align.Center}),
		).WithStyle(&props.Cell{BorderType: border.Full, BorderThickness: 0.4, BorderColor: defaultBorderColor}),
	))

	if payment.IsVoided() {
		m.AddRows(row.New(12).Add(col.New(12).Add(
			text.New("ANULADO", props.Text{Top: 1, Size: 14, Style: fontstyle.Bold, Align: align.Center, Color: voidedColor}),
			text.New(fmt.Sprintf("%s · %s", payment.VoidedAt.In(voucherZone).Format("02/01/2006 15:04"), payment.VoidReason),
				props.Text{Top: 7.5, Size: 7, Align: align.Center, Color: voidedColor}),
		)))
	}
}

func addVoucherDetails(m core.Maroto, payment *domain.Payment, customer *domain.Customer) {
	method := paymentMethodLabel(payment.Method)
	if payment.Reference != "" {
		method = fmt.Sprintf("%s (Op. %s)", method, payment.Reference)
	}
	rows := [][2]string{
		{"Fecha de pago", payment.PaidAt.In(voucherZone).Format("02/01/2006 15:04")},
		{"Código", customer.Code},
		{"Usuario", customer.Name},
		{"Dirección", customer.Address},
		{"Medio de pago", method},
		{"Cobrado por", payment.CollectedByEmail},
	}
	m.AddRows(row.New(3))
	for _, r := range rows {
		m.AddRows(row.New(5).Add(
			col.New(4).Add(text.New(r[0], props.Text{Size: 8, Style: fontstyle.Bold})),
			col.New(8).Add(text.New(r[1], props.Text{Size: 8})),
		))
	}
}

func addVoucherAllocations(m core.Maroto, payment *domain.Payment) {
	headerStyle := &props.Cell{BorderType: border.Bottom, BorderThickness: 0.3, BorderColor: defaultBorderColor}
	m.AddRows(row.New(4))
	m.AddRows(row.New(6).Add(
		col.New(8).Add(text.New("Recibo / periodo", props.Text{Size: 8, Style: fontstyle.Bold})).WithStyle(headerStyle),
		col.New(4).Add(text.New("Importe aplicado", props.Text{Size: 8, Style: fontstyle.Bold, Align: align.Right})).WithStyle(headerStyle),
	))
	for _, a := range payment.Allocations {
		m.AddRows(row.New(5.5).Add(
			col.New(8).Add(text.New(formatPeriod(a.Period), props.Text{Top: 1, Size: 8})),
			col.New(4).Add(text.New(fmt.Sprintf("S/ %.2f", a.Amount), props.Text{Top: 1, Size: 8, Align: align.Right})),
		))
	}
	m.AddRows(row.New(8).Add(
		col.New(8).Add(text.New("TOTAL PAGADO", props.Text{Top: 2, Size: 10, Style: fontstyle.Bold})).
			WithStyle(&props.Cell{BorderType: border.Top, BorderThickness: 0.4, BorderColor: defaultBorderColor}),
		col.New(4).Add(text.New(fmt.Sprintf("S/ %.2f", payment.Amount), props.Text{Top: 2, Size: 10, Style: fontstyle.Bold, Align: align.Right})).
			WithStyle(&props.Cell{BorderType: border.Top, BorderThickness: 0.4, BorderColor: defaultBorderColor}),
	))
}

func addVoucherFooter(m core.Maroto, payment *domain.Payment) {
	if payment.Observation != "" {
		m.AddRows(row.New(8).Add(col.New(12).Add(
			text.New("Observación: "+payment.Observation, props.Text{Top: 3, Size: 7.5, Style: fontstyle.Italic}),
		)))
	}
	m.AddRows(row.New(18).Add(col.New(12).Add(
		text.New("Este comprobante acredita el pago de los recibos detallados.", props.Text{Top: 8, Size: 6.5, Align: align.Center}),
		text.New("No es un comprobante de pago electrónico SUNAT.", props.Text{Top: 11, Size: 6.5, Align: align.Center}),
		text.New(fmt.Sprintf("Impreso: %s", time.Now().In(voucherZone).Format("02/01/2006 15:04")),
			props.Text{Top: 14, Size: 5.5, Style: fontstyle.Italic, Align: align.Center}),
	)))
}
