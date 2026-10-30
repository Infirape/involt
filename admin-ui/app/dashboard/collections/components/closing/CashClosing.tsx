import { CalendarRange, Download, Loader2, RefreshCw } from "lucide-react";
import { DatePicker } from "@/components/ui/date-picker";
import { useAuth } from "@/lib/hooks/useAuth";
import { useCashClosing } from "../../hooks/useCashClosing";
import { downloadReport } from "../../lib/api";
import { limaToday } from "../../lib/money";
import { currentWeek, type DateRange, previousWeek } from "../../lib/weeks";
import { ClosingSummary } from "./ClosingSummary";
import { ClosingTable } from "./ClosingTable";

const presetClass =
  "px-2 py-1 rounded-lg text-[11px] text-cyan-400 hover:bg-zinc-800 hover:text-cyan-300";

const inputClass =
  "bg-zinc-950 border border-zinc-800 text-zinc-200 text-xs rounded-xl px-2.5 py-1.5 focus:outline-none focus:border-cyan-500/50 [color-scheme:dark]";

/** Cierre de caja: what was collected in a date range, by method and collector. */
export function CashClosing() {
  const { isAdmin, isSupervisor } = useAuth();
  const closing = useCashClosing();
  const { data } = closing;
  const today = limaToday();
  const pickRange = (r: DateRange) => {
    closing.setDateFrom(r.from);
    closing.setDateTo(r.to);
  };
  const query = {
    date_from: closing.dateFrom,
    date_to: closing.dateTo,
    collected_by: closing.collectedBy,
  };

  return (
    <div className="flex flex-col gap-4 flex-1 min-h-0">
      <div className="flex flex-wrap items-end gap-3">
        <div className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Desde
          <DatePicker
            aria-label="Desde"
            value={closing.dateFrom}
            max={today}
            onChange={(v) => {
              closing.setDateFrom(v);
              if (v > closing.dateTo) closing.setDateTo(v);
            }}
            className="w-36 text-xs"
          />
        </div>
        <div className="text-[11px] text-zinc-500 flex flex-col gap-1">
          Hasta
          <DatePicker
            aria-label="Hasta"
            value={closing.dateTo}
            min={closing.dateFrom}
            max={today}
            onChange={closing.setDateTo}
            className="w-36 text-xs"
          />
        </div>
        <div className="flex items-center gap-1 pb-0.5">
          <button
            type="button"
            onClick={() => pickRange(currentWeek(today))}
            className={presetClass}
          >
            Esta semana
          </button>
          <button
            type="button"
            onClick={() => pickRange(previousWeek(today))}
            className={presetClass}
          >
            Semana pasada
          </button>
        </div>
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
            onClick={() => downloadReport("/admin/reports/cash-closing.xlsx", query)}
            disabled={!data || data.payments.length === 0}
            className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-zinc-800 text-zinc-200 hover:bg-zinc-700 flex items-center gap-1.5 disabled:opacity-40"
          >
            <Download className="w-3.5 h-3.5" /> Cierre de caja
          </button>
          <button
            type="button"
            onClick={() => downloadReport("/admin/reports/remittance.xlsx", query)}
            title="Pagos del rango agrupados por semana (lunes a domingo) con subtotales"
            className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-cyan-400 text-black hover:bg-cyan-300 flex items-center gap-1.5"
          >
            <CalendarRange className="w-3.5 h-3.5" /> Rendición semanal
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
