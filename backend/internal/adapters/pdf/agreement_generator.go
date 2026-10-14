package pdf

import (
	"context"
	"fmt"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/johnfercher/maroto/v2"
	"github.com/johnfercher/maroto/v2/pkg/components/col"
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

var tableHeaderStyle = &props.Cell{BorderType: border.Bottom, BorderThickness: 0.3, BorderColor: defaultBorderColor}

// GenerateAgreement renders the payment agreement (convenio de pago) to be signed (A4).
func (g *MarotoGenerator) GenerateAgreement(_ context.Context, a *domain.Agreement, customer *domain.Customer, settings *domain.Settings) ([]byte, error) {
	cfg := config.NewBuilder().WithPageSize(pagesize.A4).WithLeftMargin(20).WithRightMargin(20).WithTopMargin(15).Build()
	m := maroto.New(cfg)

	g.addDocumentHeader(m, settings, "CONVENIO DE PAGO", a.Number)
	if a.Status == domain.AgreementCancelled {
		m.AddRows(row.New(10).Add(col.New(12).Add(
			text.New("ANULADO · "+a.CancelReason, props.Text{Top: 2, Size: 11, Style: fontstyle.Bold, Align: align.Center, Color: voidedColor}),
		)))
	}

	addLabeledRows(m, [][2]string{
		{"Fecha", a.CreatedAt.In(voucherZone).Format("02/01/2006")},
		{"Código", customer.Code},
		{"Usuario", customer.Name},
		{"Dirección", customer.Address},
		{"Registrado por", a.CreatedByEmail},
	})
	addAgreementReceipts(m, a)
	addAgreementSchedule(m, a)
	addAgreementClauses(m, a, settings)
	addSignatures(m)

	document, err := m.Generate()
	if err != nil {
		return nil, fmt.Errorf("error generating agreement: %w", err)
	}
	return document.GetBytes(), nil
}

func addLabeledRows(m core.Maroto, rows [][2]string) {
	m.AddRows(row.New(3))
	for _, r := range rows {
		m.AddRows(row.New(5).Add(
			col.New(3).Add(text.New(r[0], props.Text{Size: 9, Style: fontstyle.Bold})),
			col.New(9).Add(text.New(r[1], props.Text{Size: 9})),
		))
	}
}

func moneyCell(v float64, bold bool) core.Col {
	style := fontstyle.Normal
	if bold {
		style = fontstyle.Bold
	}
	return col.New(3).Add(text.New(fmt.Sprintf("S/ %.2f", v), props.Text{Top: 1, Size: 9, Align: align.Right, Style: style}))
}

func addAgreementReceipts(m core.Maroto, a *domain.Agreement) {
	m.AddRows(row.New(6), row.New(6).Add(
		col.New(6).Add(text.New("Deuda incluida", props.Text{Size: 9, Style: fontstyle.Bold})).WithStyle(tableHeaderStyle),
		col.New(3).Add(text.New("Recibo", props.Text{Size: 9, Style: fontstyle.Bold, Align: align.Right})).WithStyle(tableHeaderStyle),
		col.New(3).Add(text.New("Mora", props.Text{Size: 9, Style: fontstyle.Bold, Align: align.Right})).WithStyle(tableHeaderStyle),
	))
	for _, rc := range a.Receipts {
		m.AddRows(row.New(5.5).Add(
			col.New(6).Add(text.New(formatPeriod(rc.Period), props.Text{Top: 1, Size: 9})),
			moneyCell(rc.Principal, false), moneyCell(rc.LateFee, false),
		))
	}
	waived := ""
	if a.LateFeesWaived {
		waived = " (mora condonada)"
	}
	m.AddRows(row.New(7).Add(
		col.New(9).Add(text.New("TOTAL DEL CONVENIO"+waived, props.Text{Top: 2, Size: 10, Style: fontstyle.Bold})),
		moneyCell(a.Total, true),
	))
}

func addAgreementSchedule(m core.Maroto, a *domain.Agreement) {
	m.AddRows(row.New(6), row.New(6).Add(
		col.New(3).Add(text.New("Cuota", props.Text{Size: 9, Style: fontstyle.Bold})).WithStyle(tableHeaderStyle),
		col.New(6).Add(text.New("Vencimiento", props.Text{Size: 9, Style: fontstyle.Bold})).WithStyle(tableHeaderStyle),
		col.New(3).Add(text.New("Monto", props.Text{Size: 9, Style: fontstyle.Bold, Align: align.Right})).WithStyle(tableHeaderStyle),
	))
	if a.InitialAmount > 0 {
		m.AddRows(row.New(5.5).Add(
			col.New(3).Add(text.New("Inicial", props.Text{Top: 1, Size: 9})),
			col.New(6).Add(text.New("A la firma", props.Text{Top: 1, Size: 9})),
			moneyCell(a.InitialAmount, false),
		))
	}
	for _, in := range a.Installments {
		m.AddRows(row.New(5.5).Add(
			col.New(3).Add(text.New(fmt.Sprintf("%d de %d", in.Number, len(a.Installments)), props.Text{Top: 1, Size: 9})),
			col.New(6).Add(text.New(in.DueDate.Format("02/01/2006"), props.Text{Top: 1, Size: 9})),
			moneyCell(in.Amount, false),
		))
	}
}

func addAgreementClauses(m core.Maroto, a *domain.Agreement, settings *domain.Settings) {
	clauses := []string{
		fmt.Sprintf("1. El usuario reconoce la deuda detallada y se compromete a cancelarla ante %s en las fechas indicadas.", settings.Empresa),
		"2. Mientras el convenio se mantenga al día, los recibos incluidos no generarán nueva mora ni motivarán el corte del servicio.",
		"3. El atraso en el pago de una cuota, vencido el plazo de tolerancia, deja sin efecto los beneficios del convenio y la deuda pendiente será exigible.",
		"4. Los pagos se aplican a los recibos más antiguos del convenio.",
	}
	if a.Notes != "" {
		clauses = append(clauses, "Observaciones: "+a.Notes)
	}
	m.AddRows(row.New(6))
	for _, c := range clauses {
		m.AddRows(row.New(9).Add(col.New(12).Add(text.New(c, props.Text{Size: 8.5}))))
	}
}

func addSignatures(m core.Maroto) {
	line := &props.Cell{BorderType: border.Top, BorderThickness: 0.3, BorderColor: defaultBorderColor}
	m.AddRows(row.New(28), row.New(12).Add(
		col.New(5).Add(
			text.New("Firma del usuario", props.Text{Top: 1, Size: 8.5, Align: align.Center}),
			text.New("DNI: ____________________", props.Text{Top: 6, Size: 8.5, Align: align.Center}),
		).WithStyle(line),
		col.New(2),
		col.New(5).Add(text.New("Por la entidad", props.Text{Top: 1, Size: 8.5, Align: align.Center})).WithStyle(line),
	))
}
