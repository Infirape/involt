import { AlertTriangle, CheckCircle2, Printer, X } from "lucide-react";
import type { Payment } from "@/app/gen/involt/v1/payments_pb";
import { openPaymentVoucher } from "../../lib/api";
import { formatSoles } from "../../lib/money";

interface AccountSummaryProps {
  name: string;
  code: string;
  totalDebt: number;
  totalLateFees: number;
  overdueCount: number;
}

export function AccountSummary(props: AccountSummaryProps) {
  return (
    <div className="flex items-start justify-between gap-3">
      <div className="min-w-0">
        <p className="text-[11px] font-mono text-zinc-500">{props.code}</p>
        <h3 className="text-base font-bold text-white truncate">{props.name}</h3>
      </div>
      <div className="text-right shrink-0">
        <p className="text-[10px] uppercase tracking-wider text-zinc-500">Deuda total</p>
        <p
          className={`text-lg font-bold tabular-nums ${props.totalDebt > 0 ? "text-red-400" : "text-emerald-400"}`}
        >
          {formatSoles(props.totalDebt)}
        </p>
        {props.totalLateFees > 0 && (
          <p className="text-[10px] text-amber-300">
            incluye mora {formatSoles(props.totalLateFees)}
          </p>
        )}
        {props.overdueCount > 0 && (
          <p className="text-[10px] text-red-400 flex items-center justify-end gap-1">
            <AlertTriangle className="w-3 h-3" />
            {props.overdueCount} {props.overdueCount === 1 ? "recibo vencido" : "recibos vencidos"}
          </p>
        )}
      </div>
    </div>
  );
}

export function LastPaymentBanner({
  payment,
  onDismiss,
}: {
  payment: Payment;
  onDismiss: () => void;
}) {
  return (
    <div className="flex items-center gap-3 p-3 rounded-xl border border-emerald-500/25 bg-emerald-500/10 text-xs">
      <CheckCircle2 className="w-4 h-4 text-emerald-400 shrink-0" />
      <div className="flex-1 text-emerald-200">
        Pago de <strong>{formatSoles(payment.amount)}</strong> registrado · Comprobante N°{" "}
        {String(payment.receiptNumber).padStart(6, "0")}
      </div>
      <button
        type="button"
        onClick={() => openPaymentVoucher(payment.id)}
        className="px-2.5 py-1 rounded-lg bg-emerald-400 text-black font-semibold flex items-center gap-1 hover:bg-emerald-300"
      >
        <Printer className="w-3 h-3" /> Imprimir
      </button>
      <button
        type="button"
        onClick={onDismiss}
        aria-label="Cerrar aviso"
        className="text-emerald-300/60 hover:text-emerald-200"
      >
        <X className="w-3.5 h-3.5" />
      </button>
    </div>
  );
}
