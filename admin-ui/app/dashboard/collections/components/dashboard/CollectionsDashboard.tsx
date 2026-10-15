import { Download, Loader2 } from "lucide-react";
import { useMemo, useState } from "react";
import { MonthPicker } from "@/components/ui/date-picker";
import {
  type DashboardFilters,
  useCollectionsDashboard,
} from "../../hooks/useCollectionsDashboard";
import { downloadReport } from "../../lib/api";
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
  const [fromPeriod, setFromPeriod] = useState("");
  const [toPeriod, setToPeriod] = useState("");
  const [communityId, setCommunityId] = useState("");
  const [sectorId, setSectorId] = useState("");
  const filters = useMemo<DashboardFilters>(
    () => ({ fromPeriod, toPeriod, communityId, sectorId }),
    [fromPeriod, toPeriod, communityId, sectorId],
  );
  const sectors = communityId
    ? (communities.find((c) => c.id === communityId)?.sectors ?? [])
    : communities.flatMap((c) => c.sectors);
  const { data, loading } = useCollectionsDashboard(filters);

  return (
    <div className="flex flex-col gap-4">
      {/* Filters live in one row above every chart. */}
      <div className="flex flex-wrap items-end gap-3">
        <div className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Desde
          <MonthPicker
            aria-label="Desde"
            value={fromPeriod || data?.fromPeriod || ""}
            max={toPeriod || data?.toPeriod}
            onChange={setFromPeriod}
            className="w-40 text-xs"
          />
        </div>
        <div className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Hasta
          <MonthPicker
            aria-label="Hasta"
            value={toPeriod || data?.toPeriod || ""}
            min={fromPeriod || data?.fromPeriod}
            onChange={setToPeriod}
            className="w-40 text-xs"
          />
        </div>
        <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Comunidad
          <select
            value={communityId}
            onChange={(e) => {
              setCommunityId(e.target.value);
              setSectorId("");
            }}
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
            onChange={(e) => setSectorId(e.target.value)}
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
        <button
          type="button"
          disabled={!data}
          onClick={() =>
            downloadReport("/admin/reports/collections.xlsx", {
              from_period: fromPeriod,
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
