import { Download, Loader2, RefreshCw } from "lucide-react";
import { useAuth } from "@/lib/hooks/useAuth";
import { useCashClosing } from "../../hooks/useCashClosing";
import { limaToday } from "../../lib/money";
import { ClosingSummary } from "./ClosingSummary";
import { ClosingTable } from "./ClosingTable";

const inputClass =
  "bg-zinc-950 border border-zinc-800 text-zinc-200 text-xs rounded-xl px-2.5 py-1.5 focus:outline-none focus:border-cyan-500/50 [color-scheme:dark]";

/** Cierre de caja: what was collected in a date range, by method and collector. */
export function CashClosing() {
  const { isAdmin, isSupervisor } = useAuth();
  const closing = useCashClosing();
  const { data } = closing;
  const today = limaToday();

  return (
    <div className="flex flex-col gap-4 flex-1 min-h-0">
      <div className="flex flex-wrap items-end gap-3">
        <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Desde
          <input
            type="date"
            value={closing.dateFrom}
            max={today}
            onChange={(e) => {
              closing.setDateFrom(e.target.value);
              if (e.target.value > closing.dateTo) closing.setDateTo(e.target.value);
            }}
            className={inputClass}
          />
        </label>
        <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Hasta
          <input
            type="date"
            value={closing.dateTo}
            min={closing.dateFrom}
            max={today}
            onChange={(e) => closing.setDateTo(e.target.value)}
            className={inputClass}
          />
        </label>
        {(isAdmin || isSupervisor) && (
          <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
            Cobrador
            <select
              value={closing.collectedBy}
              onChange={(e) => closing.setCollectedBy(e.target.value)}
              className={inputClass}
            >
              <option value="">Todos</option>
              {data?.byCollector.map((c) => (
                <option key={c.collectedBy} value={c.collectedBy}>
                  {c.collectedByEmail || c.collectedBy}
                </option>
              ))}
            </select>
          </label>
        )}
        <div className="flex items-center gap-2 ml-auto">
          <button
            type="button"
            onClick={closing.reload}
            className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-zinc-800 text-zinc-300 hover:bg-zinc-700 flex items-center gap-1.5"
          >
            {closing.loading ? (
              <Loader2 className="w-3.5 h-3.5 animate-spin" />
            ) : (
              <RefreshCw className="w-3.5 h-3.5" />
            )}
            Actualizar
          </button>
          <button
            type="button"
            onClick={closing.exportCsv}
            disabled={!data || data.payments.length === 0}
            className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-cyan-400 text-black hover:bg-cyan-300 flex items-center gap-1.5 disabled:opacity-40"
          >
            <Download className="w-3.5 h-3.5" /> Exportar CSV
          </button>
        </div>
      </div>

      {data && <ClosingSummary data={data} />}

      <div className="flex-1 min-h-[50vh] bg-zinc-900/60 border border-zinc-800 rounded-2xl overflow-auto">
        {data ? (
          <ClosingTable payments={data.payments} />
        ) : (
          <div className="flex justify-center py-16">
            <Loader2 className="w-6 h-6 text-zinc-600 animate-spin" />
          </div>
        )}
      </div>
    </div>
  );
}
