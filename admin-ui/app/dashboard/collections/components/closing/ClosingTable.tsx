import { Printer } from "lucide-react";
import type { Payment } from "@/app/gen/involt/v1/payments_pb";
import { openPaymentVoucher } from "../../lib/api";
import { formatPeriod, paymentMethodLabel } from "../../lib/labels";
import { formatLimaDateTime, formatSoles } from "../../lib/money";

export function ClosingTable({ payments }: { payments: Payment[] }) {
  if (payments.length === 0) {
    return <p className="text-sm text-zinc-500 text-center py-16">No hay pagos en este rango.</p>;
  }
  return (
    <table className="w-full text-xs border-collapse">
      <thead className="sticky top-0 bg-zinc-900 z-10">
        <tr className="border-b border-zinc-800 text-zinc-400">
          <th className="text-left px-3 py-2.5 font-semibold">N°</th>
          <th className="text-left px-3 py-2.5 font-semibold">Fecha</th>
          <th className="text-left px-3 py-2.5 font-semibold">Cliente</th>
          <th className="text-left px-3 py-2.5 font-semibold">Periodos</th>
          <th className="text-left px-3 py-2.5 font-semibold">Medio</th>
          <th className="text-left px-3 py-2.5 font-semibold">Cobrado por</th>
          <th className="text-right px-3 py-2.5 font-semibold">Monto</th>
          <th className="px-3 py-2.5" />
        </tr>
      </thead>
      <tbody>
        {payments.map((p) => (
          <tr
            key={p.id}
            className={`border-b border-zinc-800/50 ${p.voided ? "opacity-50" : "hover:bg-zinc-800/20"}`}
          >
            <td className="px-3 py-2 font-mono text-zinc-400">
              {String(p.receiptNumber).padStart(6, "0")}
            </td>
            <td className="px-3 py-2 text-zinc-400 whitespace-nowrap">
              {formatLimaDateTime(p.paidAt)}
            </td>
            <td className="px-3 py-2">
              <div className="text-zinc-200 truncate max-w-[220px]">{p.customerName}</div>
              <div className="text-[10px] font-mono text-zinc-600">{p.customerCode}</div>
            </td>
            <td className="px-3 py-2 text-zinc-400">
              {p.allocations.map((a) => formatPeriod(a.period)).join(", ")}
            </td>
            <td className="px-3 py-2 text-zinc-300">
              {paymentMethodLabel(p.method)}
              {p.reference && <div className="text-[10px] text-zinc-600">Op. {p.reference}</div>}
            </td>
            <td className="px-3 py-2 text-zinc-500 truncate max-w-[160px]">
              {p.collectedByEmail || "—"}
            </td>
            <td className="px-3 py-2 text-right tabular-nums font-semibold">
              {p.voided ? (
                <span className="text-red-400" title={p.voidReason}>
                  <span className="line-through">{formatSoles(p.amount)}</span> ANULADO
                </span>
              ) : (
                <span className="text-white">{formatSoles(p.amount)}</span>
              )}
            </td>
            <td className="px-3 py-2 text-right">
              <button
                type="button"
                onClick={() => openPaymentVoucher(p.id)}
                title="Imprimir comprobante"
                className="p-1.5 rounded-lg text-zinc-500 hover:text-cyan-400 hover:bg-zinc-800"
              >
                <Printer className="w-3.5 h-3.5" />
              </button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
