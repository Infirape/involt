import { useState } from "react";
import { AgingBucket, type AgingTotal } from "@/app/gen/involt/v1/reports_pb";
import { AGING_COLORS } from "../../lib/chart";
import { formatSoles } from "../../lib/money";

const BUCKET_LABELS: Record<AgingBucket, string> = {
  [AgingBucket.AGING_BUCKET_UNSPECIFIED]: "—",
  [AgingBucket.AGING_BUCKET_CURRENT]: "Por vencer",
  [AgingBucket.AGING_BUCKET_1_30]: "1 – 30 días",
  [AgingBucket.AGING_BUCKET_31_60]: "31 – 60 días",
  [AgingBucket.AGING_BUCKET_61_90]: "61 – 90 días",
  [AgingBucket.AGING_BUCKET_OVER_90]: "Más de 90 días",
};

/** Horizontal bars of outstanding debt by days overdue (ordinal blue ramp). */
export function AgingChart({ aging }: { aging: AgingTotal[] }) {
  const [hover, setHover] = useState<number | null>(null);
  const max = Math.max(0, ...aging.map((a) => a.amount));

  return (
    <section className="p-4 rounded-2xl border border-zinc-800 bg-zinc-900/60">
      <h3 className="text-sm font-semibold text-white">Antigüedad de la deuda</h3>
      <p className="text-[11px] text-zinc-500 mb-3">Todo el saldo pendiente, por días de atraso</p>
      <ul className="space-y-2.5">
        {aging.map((a, i) => (
          <li
            key={a.bucket}
            onMouseEnter={() => setHover(i)}
            onMouseLeave={() => setHover(null)}
            className={`grid grid-cols-[96px_1fr_auto] items-center gap-3 text-xs rounded-lg px-1 -mx-1 ${hover === i ? "bg-white/[0.03]" : ""}`}
          >
            <span className="text-zinc-400">{BUCKET_LABELS[a.bucket]}</span>
            <div className="h-3.5 rounded-r-[4px] bg-zinc-800/40 overflow-hidden">
              <div
                className="h-full rounded-r-[4px]"
                style={{
                  width:
                    max > 0 ? `${Math.max((a.amount / max) * 100, a.amount > 0 ? 1.5 : 0)}%` : "0%",
                  background: AGING_COLORS[i] ?? AGING_COLORS[AGING_COLORS.length - 1],
                }}
              />
            </div>
            <span className="text-right tabular-nums min-w-[88px]">
              <span className="text-zinc-100 font-semibold">{formatSoles(a.amount)}</span>
              <span className="block text-[10px] text-zinc-500">
                {hover === i
                  ? `${a.receipts} recibos · ${a.customers} clientes`
                  : `${a.customers} ${a.customers === 1 ? "cliente" : "clientes"}`}
              </span>
            </span>
          </li>
        ))}
      </ul>
    </section>
  );
}
