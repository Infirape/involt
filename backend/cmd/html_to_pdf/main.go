package main

import (
	"fmt"
	"log"

	"github.com/carlos7ags/folio/document"
	"github.com/carlos7ags/folio/html"
)

func main() {
	htmlContent := `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Recibo de Energía</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background: #fff;
        font-size: 12px;
    }
    .recibo {
        width: 800px;
        border: 2px solid #000;
        margin: auto;
        padding: 10px;
    }
    .header {
        display: flex;
        justify-content: space-between;
        border-bottom: 2px solid #000;
        padding-bottom: 5px;
        font-size: 12px;
    }
    .titulo {
        text-align: center;
        font-weight: bold;
    }
    .section {
        border-top: 2px solid #000;
        margin-top: 10px;
        padding-top: 5px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 12px;
    }
    td {
        padding: 4px;
        vertical-align: top;
    }
    .box {
        border: 1px solid #000;
        padding: 8px;
        margin-top: 10px;
        text-align: center;
    }
    .total {
        text-align: right;
        font-weight: bold;
        font-size: 14px;
    }
    .footer {
        margin-top: 10px;
        border-top: 2px solid #000;
        padding-top: 5px;
        font-size: 12px;
    }
</style>
</head>
<body>

<div class="recibo">

    <div class="header">
        <div>
            Chetilla<br>
            Para consulta su código es:<br>
            <strong>TANTA CUEVA JOSE SILVERIO</strong><br>
            CASERIO TAMBILLO ALTO
        </div>

        <div class="titulo">
            <strong>TAMBILLO A</strong><br>
            TAMA020
        </div>

        <div style="text-align:right">
            MUNICIPALIDAD DISTRITAL DE CHETILLA<br>
            HIDROELECTRICA QARWAQIRU MICHAY
        </div>
    </div>

    <div class="section">
        <strong>DATOS DEL SUMINISTRO Y CONSUMO</strong>

        <table>
            <tr>
                <td>
                    Tipo de Conexion: MONOFASICA<br>
                    Tarifa: 0.2500<br>
                    Medidor N°: 10000001<br><br>

                    Lectura Anterior: 0.00<br>
                    Lectura Actual: 0.00<br><br>

                    Consumo: 3 kWh<br>
                    Inicio Contrato: 25-08-2012<br>
                    Termino Contrato: Indefinido<br>
                    Fecha de Emisión: 08/04/2026
                </td>

                <td>
                    Recibo por Consumo del 2026-01-20 al 2026-02-20<br><br>

                    Cargo Fijo: 6.00<br>
                    Alumbrado Público: 0<br>
                    Ajuste Tarifario: 0.00<br>
                    <strong>SUBTOTAL: 6.00</strong><br><br>

                    Saldo por Redondeo: 0.00<br>
                    Diferencia de redondeo: 0<br><br>

                    TOTAL RECIBO ENERO-MARZO-2026: 6.00<br>
                    TOTAL RECIBOS VENCIDOS: 3.00
                </td>
            </tr>
        </table>

        <div class="box">
            Si paga hasta la fecha de vencimiento evitará cortes y gastos innecesarios.
        </div>

        <div class="total">
            TOTAL A PAGAR: S/ 18.00
        </div>
    </div>

    <div class="footer">
        <strong>FECHA DE VENCIMIENTO: 25/04/2026</strong>
    </div>

</div>

</body>
</html>`

	doc := document.NewDocument(document.PageSizeA4)

	elems, err := html.Convert(htmlContent, nil)
	if err != nil {
		log.Fatalf("failed to convert HTML: %v", err)
	}

	for _, e := range elems {
		doc.Add(e)
	}

	err = doc.Save("../docs/recibo_folio.pdf")
	if err != nil {
		log.Fatalf("failed to save PDF: %v", err)
	}

	fmt.Println("PDF generated!")
}
