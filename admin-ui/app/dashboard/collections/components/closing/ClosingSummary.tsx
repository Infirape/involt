import type { GetCashClosingResponse } from "@/app/gen/involt/v1/payments_pb";
import { paymentMethodLabel } from "../../lib/labels";
import { formatSoles } from "../../lib/money";

export function ClosingSummary({ data }: { data: GetCashClosingResponse }) {
  return (
    <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
      <Card label="Total cobrado" value={formatSoles(data.totalAmount)} tone="text-emerald-400" big>
        {data.paymentCount} {data.paymentCount === 1 ? "pago" : "pagos"}
      </Card>
      <Card label="Por medio de pago" value="">
        {data.byMethod.length === 0 ? (
          <span className="text-zinc-600">—</span>
        ) : (
          <ul className="space-y-0.5">
            {data.byMethod.map((m) => (
              <li key={m.method} className="flex justify-between gap-2 tabular-nums">
                <span className="text-zinc-400">
                  {paymentMethodLabel(m.method)} <span className="text-zinc-600">({m.count})</span>
                </span>
                <span className="text-zinc-200 font-semibold">{formatSoles(m.amount)}</span>
              </li>
            ))}
          </ul>
        )}
      </Card>
      <Card label="Por cobrador" value="">
        {data.byCollector.length === 0 ? (
          <span className="text-zinc-600">—</span>
        ) : (
          <ul className="space-y-0.5">
            {data.byCollector.map((c) => (
              <li key={c.collectedBy} className="flex justify-between gap-2 tabular-nums">
                <span className="text-zinc-400 truncate">{c.collectedByEmail || "—"}</span>
                <span className="text-zinc-200 font-semibold">{formatSoles(c.amount)}</span>
              </li>
            ))}
          </ul>
        )}
      </Card>
      <Card
        label="Anulados"
        value={formatSoles(data.voidedAmount)}
        tone={data.voidedCount > 0 ? "text-red-400" : "text-zinc-500"}
      >
        {data.voidedCount} {data.voidedCount === 1 ? "comprobante" : "comprobantes"} (no suman)
      </Card>
    </div>
  );
}

function Card({
  label,
  value,
  tone = "text-white",
  big = false,
  children,
}: {
  label: string;
  value: string;
  tone?: string;
  big?: boolean;
  children?: React.ReactNode;
}) {
  return (
    <div className="p-4 rounded-2xl border border-zinc-800 bg-zinc-900/60 text-xs">
      <p className="text-[10px] uppercase tracking-wider text-zinc-500 mb-1">{label}</p>
      {value && (
        <p className={`${big ? "text-2xl" : "text-lg"} font-bold tabular-nums ${tone}`}>{value}</p>
      )}
      <div className="text-zinc-500 mt-1">{children}</div>
    </div>
  );
}
