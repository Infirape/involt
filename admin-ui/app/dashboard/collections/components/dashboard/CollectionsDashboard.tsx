import { Download, Loader2 } from "lucide-react";
import { useMemo } from "react";
import { MonthPicker } from "@/components/ui/date-picker";
import {
  type DashboardFilters,
  useCollectionsDashboard,
} from "../../hooks/useCollectionsDashboard";
import { useDashboardSelection } from "../../hooks/useDashboardSelection";
import { downloadReport } from "../../lib/api";
import { defaultFromPeriod, earliestPeriod } from "../../lib/periods";
import { AgingChart } from "./AgingChart";
import { KpiTiles } from "./KpiTiles";
import { MonthlyChart } from "./MonthlyChart";
import { SectorTable } from "./SectorTable";

const inputClass =
  "bg-zinc-950 border border-zinc-800 text-zinc-200 text-xs rounded-xl px-2.5 py-1.5 focus:outline-none focus:border-cyan-500/50 [color-scheme:dark]";

interface CollectionsDashboardProps {
  communities: { id: string; name: string; sectors: { id: string; name: string }[] }[];
  onShowCutCandidates: () => void;
}

/** Resumen: KPIs, billed vs collected by month, debt aging and per-sector collection rate. */
export function CollectionsDashboard({
  communities,
  onShowCutCandidates,
}: CollectionsDashboardProps) {
  // Remembered across visits (localStorage).
  const { selection, update, hydrated } = useDashboardSelection();
  const { fromPeriod, toPeriod, communityId, sectorId } = selection;
  // Months before September 2026 are blocked; the default range starts there at the earliest.
  const effectiveFrom = fromPeriod || defaultFromPeriod();
  const filters = useMemo<DashboardFilters>(
    () => ({ fromPeriod: effectiveFrom, toPeriod, communityId, sectorId }),
    [effectiveFrom, toPeriod, communityId, sectorId],
  );
  const sectors = communityId
    ? (communities.find((c) => c.id === communityId)?.sectors ?? [])
    : communities.flatMap((c) => c.sectors);
  const { data, loading } = useCollectionsDashboard(filters, hydrated);

  return (
    <div className="flex flex-col gap-4">
      {/* Filters live in one row above every chart. */}
      <div className="flex flex-wrap items-end gap-3">
        <div className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Desde
          <MonthPicker
            aria-label="Desde"
            value={effectiveFrom}
            min={earliestPeriod()}
            max={toPeriod || data?.toPeriod}
            onChange={(v) => update({ fromPeriod: v })}
            className="w-40 text-xs"
          />
        </div>
        <div className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Hasta
          <MonthPicker
            aria-label="Hasta"
            value={toPeriod || data?.toPeriod || ""}
            min={earliestPeriod(effectiveFrom)}
            onChange={(v) => update({ toPeriod: v })}
            className="w-40 text-xs"
          />
        </div>
        <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Comunidad
          <select
            value={communityId}
            onChange={(e) => update({ communityId: e.target.value, sectorId: "" })}
            className={inputClass}
          >
            <option value="">Todas</option>
            {communities.map((c) => (
              <option key={c.id} value={c.id}>
                {c.name}
              </option>
            ))}
          </select>
        </label>
        <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Caserío
          <select
            value={sectorId}
            onChange={(e) => update({ sectorId: e.target.value })}
            className={inputClass}
          >
            <option value="">Todos</option>
            {sectors.map((s) => (
              <option key={s.id} value={s.id}>
                {s.name}
              </option>
            ))}
          </select>
        </label>
        {(fromPeriod || toPeriod) && (
          <button
            type="button"
            onClick={() => update({ fromPeriod: "", toPeriod: "" })}
            className="text-[11px] text-cyan-400 hover:text-cyan-300 pb-2"
          >
            Restablecer
          </button>
        )}
        {loading && <Loader2 className="w-4 h-4 text-zinc-500 animate-spin mb-2" />}
        <button
          type="button"
          disabled={!data}
          onClick={() =>
            downloadReport("/admin/reports/collections.xlsx", {
              from_period: effectiveFrom,
              to_period: toPeriod,
              community_id: communityId,
              sector_id: sectorId,
            })
          }
          className="ml-auto px-3 py-1.5 rounded-xl text-xs font-semibold bg-cyan-400 text-black hover:bg-cyan-300 flex items-center gap-1.5 disabled:opacity-40"
        >
          <Download className="w-3.5 h-3.5" /> Exportar Excel
        </button>
      </div>

      {!data ? (
        <div className="flex justify-center py-16">
          <Loader2 className="w-6 h-6 text-zinc-600 animate-spin" />
        </div>
      ) : (
        <>
          {data.totals && (
            <KpiTiles totals={data.totals} onShowCutCandidates={onShowCutCandidates} />
          )}
          <div className="grid grid-cols-1 xl:grid-cols-[2fr_1fr] gap-4">
            <MonthlyChart periods={data.byPeriod} />
            <AgingChart aging={data.aging} />
          </div>
          <SectorTable sectors={data.bySector} />
        </>
      )}
    </div>
  );
}
