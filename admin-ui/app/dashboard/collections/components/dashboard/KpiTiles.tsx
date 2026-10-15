import { AlertTriangle, Scissors } from "lucide-react";
import type { CollectionsDashboardTotals } from "@/app/gen/involt/v1/reports_pb";
import { collectionRate, formatSoles } from "../../lib/money";

interface KpiTilesProps {
  totals: CollectionsDashboardTotals;
  onShowCutCandidates: () => void;
}

export function KpiTiles({ totals, onShowCutCandidates }: KpiTilesProps) {
  const rate = collectionRate(totals.billed, totals.collected);
  return (
    <div className="grid grid-cols-2 lg:grid-cols-5 gap-3">
      <Tile label="Facturado" value={formatSoles(totals.billed)} hint="En el rango elegido" />
      <Tile
        label="Cobrado"
        value={formatSoles(totals.collected)}
        hint="De lo facturado en el rango"
      />
      <Tile label="% de cobranza" value={`${rate}%`}>
        <div className="mt-2 h-1.5 rounded-full bg-zinc-800 overflow-hidden">
          <div className="h-full bg-zinc-200" style={{ width: `${Math.min(rate, 100)}%` }} />
        </div>
      </Tile>
      <Tile
        label="Deuda total"
        value={formatSoles(totals.totalDebt)}
        hint={`${totals.debtorCount} clientes · vencido ${formatSoles(totals.overdueDebt)}`}
        icon={<AlertTriangle className="w-3.5 h-3.5 text-red-400" />}
      />
      <button
        type="button"
        onClick={onShowCutCandidates}
        className="text-left p-4 rounded-2xl border border-zinc-800 bg-zinc-900/60 hover:border-red-500/40 transition-colors"
      >
        <p className="text-[10px] uppercase tracking-wider text-zinc-500 flex items-center gap-1.5">
          <Scissors className="w-3.5 h-3.5 text-red-400" /> Candidatos a corte
        </p>
        <p className="text-xl xl:text-2xl font-bold tabular-nums whitespace-nowrap text-white mt-1">
          {totals.cutCandidates}
        </p>
        <p className="text-[11px] text-cyan-400 mt-1">Ver lista →</p>
      </button>
    </div>
  );
}

function Tile({
  label,
  value,
  hint,
  icon,
  children,
}: {
  label: string;
  value: string;
  hint?: string;
  icon?: React.ReactNode;
  children?: React.ReactNode;
}) {
  return (
    <div className="p-4 rounded-2xl border border-zinc-800 bg-zinc-900/60">
      <p className="text-[10px] uppercase tracking-wider text-zinc-500 flex items-center gap-1.5">
        {icon}
        {label}
      </p>
      <p className="text-xl xl:text-2xl font-bold tabular-nums whitespace-nowrap text-white mt-1">
        {value}
      </p>
      {hint && <p className="text-[11px] text-zinc-500 mt-1">{hint}</p>}
      {children}
    </div>
  );
}
