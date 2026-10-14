import { Loader2 } from "lucide-react";
import { useMemo, useState } from "react";
import {
  type DashboardFilters,
  useCollectionsDashboard,
} from "../../hooks/useCollectionsDashboard";
import { AgingChart } from "./AgingChart";
import { KpiTiles } from "./KpiTiles";
import { MonthlyChart } from "./MonthlyChart";
import { SectorTable } from "./SectorTable";

const inputClass =
  "bg-zinc-950 border border-zinc-800 text-zinc-200 text-xs rounded-xl px-2.5 py-1.5 focus:outline-none focus:border-cyan-500/50 [color-scheme:dark]";

interface CollectionsDashboardProps {
  communities: { id: string; name: string }[];
  onShowCutCandidates: () => void;
}

/** Resumen: KPIs, billed vs collected by month, debt aging and per-sector collection rate. */
export function CollectionsDashboard({
  communities,
  onShowCutCandidates,
}: CollectionsDashboardProps) {
  const [fromPeriod, setFromPeriod] = useState("");
  const [toPeriod, setToPeriod] = useState("");
  const [communityId, setCommunityId] = useState("");
  const filters = useMemo<DashboardFilters>(
    () => ({ fromPeriod, toPeriod, communityId }),
    [fromPeriod, toPeriod, communityId],
  );
  const { data, loading } = useCollectionsDashboard(filters);

  return (
    <div className="flex flex-col gap-4">
      {/* Filters live in one row above every chart. */}
      <div className="flex flex-wrap items-end gap-3">
        <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Desde
          <input
            type="month"
            value={fromPeriod || data?.fromPeriod || ""}
            onChange={(e) => setFromPeriod(e.target.value)}
            className={inputClass}
          />
        </label>
        <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Hasta
          <input
            type="month"
            value={toPeriod || data?.toPeriod || ""}
            onChange={(e) => setToPeriod(e.target.value)}
            className={inputClass}
          />
        </label>
        <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Comunidad
          <select
            value={communityId}
            onChange={(e) => setCommunityId(e.target.value)}
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
        {(fromPeriod || toPeriod) && (
          <button
            type="button"
            onClick={() => {
              setFromPeriod("");
              setToPeriod("");
            }}
            className="text-[11px] text-cyan-400 hover:text-cyan-300 pb-2"
          >
            Últimos 12 meses
          </button>
        )}
        {loading && <Loader2 className="w-4 h-4 text-zinc-500 animate-spin mb-2" />}
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
