import { useMemo, useState } from "react";
import type { SectorCollectionSummary } from "@/app/gen/involt/v1/reports_pb";
import { collectionRate, formatSoles } from "../../lib/money";

type SortKey = "billed" | "rate" | "debt";

const SORTS: { key: SortKey; label: string }[] = [
  { key: "billed", label: "Facturado" },
  { key: "rate", label: "% cobranza" },
  { key: "debt", label: "Deuda" },
];

export function SectorTable({ sectors }: { sectors: SectorCollectionSummary[] }) {
  const [sort, setSort] = useState<SortKey>("rate");

  const rows = useMemo(() => {
    const withRate = sectors.map((s) => ({ ...s, rate: collectionRate(s.billed, s.collected) }));
    return withRate.sort((a, b) => {
      if (sort === "rate") return a.rate - b.rate; // worst first
      return sort === "debt" ? b.debt - a.debt : b.billed - a.billed;
    });
  }, [sectors, sort]);

  return (
    <section className="p-4 rounded-2xl border border-zinc-800 bg-zinc-900/60 flex flex-col min-h-0">
      <div className="flex items-center justify-between mb-3">
        <h3 className="text-sm font-semibold text-white">Cobranza por caserío</h3>
        <div className="flex items-center gap-1 text-[11px]">
          <span className="text-zinc-500 mr-1">Ordenar:</span>
          {SORTS.map((s) => (
            <button
              key={s.key}
              type="button"
              onClick={() => setSort(s.key)}
              className={`px-2 py-0.5 rounded-md ${sort === s.key ? "bg-zinc-800 text-white" : "text-zinc-400 hover:text-zinc-200"}`}
            >
              {s.label}
            </button>
          ))}
        </div>
      </div>
      {rows.length === 0 ? (
        <p className="text-xs text-zinc-500 text-center py-8">Sin recibos en este rango.</p>
      ) : (
        <div className="overflow-auto max-h-[420px]">
          <table className="w-full text-xs">
            <thead className="sticky top-0 bg-zinc-900 text-zinc-400">
              <tr>
                <th className="text-left py-2 font-semibold">Caserío</th>
                <th className="text-right py-2 font-semibold">Facturado</th>
                <th className="text-right py-2 font-semibold">Cobrado</th>
                <th className="py-2 font-semibold w-40">% cobranza</th>
                <th className="text-right py-2 font-semibold">Deuda</th>
                <th className="text-right py-2 font-semibold">Morosos</th>
              </tr>
            </thead>
            <tbody className="tabular-nums">
              {rows.map((s) => (
                <tr key={s.sectorId} className="border-t border-zinc-800/60 text-zinc-300">
                  <td className="py-2">
                    <div className="text-zinc-200">{s.sectorName || "Sin caserío"}</div>
                    <div className="text-[10px] text-zinc-600">{s.communityName}</div>
                  </td>
                  <td className="text-right">{formatSoles(s.billed)}</td>
                  <td className="text-right">{formatSoles(s.collected)}</td>
                  <td className="px-3">
                    <div className="flex items-center gap-2">
                      <div className="h-1.5 flex-1 rounded-full bg-zinc-800 overflow-hidden">
                        <div
                          className="h-full bg-zinc-300"
                          style={{ width: `${Math.min(s.rate, 100)}%` }}
                        />
                      </div>
                      <span className="w-10 text-right text-zinc-200">{s.rate}%</span>
                    </div>
                  </td>
                  <td className={`text-right ${s.debt > 0 ? "text-red-400" : "text-zinc-600"}`}>
                    {formatSoles(s.debt)}
                  </td>
                  <td className="text-right text-zinc-400">
                    {s.debtors}/{s.customers}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </section>
  );
}
