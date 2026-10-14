import { Ban, Printer } from "lucide-react";
import type { Payment } from "@/app/gen/involt/v1/payments_pb";
import { openPaymentVoucher } from "../../lib/api";
import { formatPeriod, paymentMethodLabel } from "../../lib/labels";
import { formatLimaDateTime, formatSoles } from "../../lib/money";

interface PaymentHistoryProps {
  payments: Payment[];
  canVoid: boolean;
  onVoid: (payment: Payment) => void;
}

export function PaymentHistory({ payments, canVoid, onVoid }: PaymentHistoryProps) {
  return (
    <section className="space-y-2">
      <h4 className="text-[11px] font-semibold text-zinc-400 uppercase tracking-wider">
        Historial de pagos ({payments.length})
      </h4>
      {payments.length === 0 ? (
        <p className="text-xs text-zinc-500 py-3 text-center">Aún no registra pagos.</p>
      ) : (
        <ul className="space-y-1.5">
          {payments.map((p) => (
            <PaymentItem key={p.id} payment={p} canVoid={canVoid} onVoid={onVoid} />
          ))}
        </ul>
      )}
    </section>
  );
}

function PaymentItem({
  payment,
  canVoid,
  onVoid,
}: {
  payment: Payment;
  canVoid: boolean;
  onVoid: (payment: Payment) => void;
}) {
  const periods = payment.allocations.map((a) => formatPeriod(a.period)).join(", ");
  return (
    <li
      className={`p-2.5 rounded-xl border text-xs ${
        payment.voided
          ? "border-red-500/20 bg-red-500/5 opacity-70"
          : "border-zinc-800 bg-zinc-950/40"
      }`}
    >
      <div className="flex items-start gap-2">
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2">
            <span className="font-mono text-zinc-400">
              N° {String(payment.receiptNumber).padStart(6, "0")}
            </span>
            <span
              className={`font-semibold tabular-nums ${payment.voided ? "line-through text-zinc-500" : "text-white"}`}
            >
              {formatSoles(payment.amount)}
            </span>
            <span className="text-zinc-500">· {paymentMethodLabel(payment.method)}</span>
            {payment.voided && <span className="text-red-400 font-bold text-[10px]">ANULADO</span>}
          </div>
          <div className="text-[10px] text-zinc-500 mt-0.5 truncate">
            {formatLimaDateTime(payment.paidAt)} · {payment.collectedByEmail || "—"}
            {payment.reference && ` · Op. ${payment.reference}`}
          </div>
          <div className="text-[10px] text-zinc-400 mt-0.5 truncate">{periods}</div>
          {payment.voided && payment.voidReason && (
            <div className="text-[10px] text-red-400/80 mt-0.5">Motivo: {payment.voidReason}</div>
          )}
        </div>
        <button
          type="button"
          onClick={() => openPaymentVoucher(payment.id)}
          title="Imprimir comprobante"
          className="p-1.5 rounded-lg text-zinc-500 hover:text-cyan-400 hover:bg-zinc-800"
        >
          <Printer className="w-3.5 h-3.5" />
        </button>
        {canVoid && !payment.voided && (
          <button
            type="button"
            onClick={() => onVoid(payment)}
            title="Anular pago"
            className="p-1.5 rounded-lg text-zinc-500 hover:text-red-400 hover:bg-zinc-800"
          >
            <Ban className="w-3.5 h-3.5" />
          </button>
        )}
      </div>
    </li>
  );
}
