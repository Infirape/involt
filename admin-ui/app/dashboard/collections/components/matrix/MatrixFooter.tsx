import { ReceiptStatus } from "@/app/gen/involt/v1/payments_pb";
import { RECEIPT_STATUS_STYLES } from "../../lib/labels";
import { collectionRate, formatSoles } from "../../lib/money";
import type { MatrixTotals } from "../../types";

const LEGEND = [
  ReceiptStatus.PAID,
  ReceiptStatus.PARTIAL,
  ReceiptStatus.PENDING,
  ReceiptStatus.OVERDUE,
];

export function MatrixFooter({ totals }: { totals: MatrixTotals }) {
  const rate = collectionRate(totals.billed, totals.collected);
  return (
    <div className="border-t border-zinc-800 p-3 flex flex-wrap items-center gap-x-6 gap-y-2 text-[11px]">
      <Stat label="Facturado" value={formatSoles(totals.billed)} />
      <Stat label="Cobrado" value={formatSoles(totals.collected)} tone="text-emerald-400" />
      <Stat
        label="Por cobrar"
        value={formatSoles(Math.max(totals.billed - totals.collected, 0))}
        tone="text-red-400"
      />
      <div className="flex items-center gap-2 min-w-[140px]">
        <div className="h-1.5 flex-1 rounded-full bg-zinc-800 overflow-hidden">
          <div className="h-full bg-emerald-500" style={{ width: `${Math.min(rate, 100)}%` }} />
        </div>
        <span className="text-zinc-300 font-semibold tabular-nums">{rate}%</span>
      </div>

      <div className="flex items-center gap-3 ml-auto text-[10px] text-zinc-500">
        {LEGEND.map((status) => (
          <span key={status} className="flex items-center gap-1.5">
            <span className={`w-3 h-3 rounded border ${RECEIPT_STATUS_STYLES[status].swatch}`} />
            {RECEIPT_STATUS_STYLES[status].label}
          </span>
        ))}
        <span className="flex items-center gap-1.5">
          <span className="text-zinc-600 font-bold">+</span> Sin recibo
        </span>
      </div>
    </div>
  );
}

function Stat({
  label,
  value,
  tone = "text-white",
}: {
  label: string;
  value: string;
  tone?: string;
}) {
  return (
    <div>
      <span className="text-zinc-500 mr-1.5">{label}</span>
      <span className={`font-semibold tabular-nums ${tone}`}>{value}</span>
    </div>
  );
}
