import { Download, Loader2 } from "lucide-react";
import { useCallback, useState } from "react";
import { type DebtorFilters, useDebtors } from "../../hooks/useDebtors";
import { downloadReport } from "../../lib/api";
import { formatSoles } from "../../lib/money";
import type { SectorTab } from "../../types";
import { AccountDrawer } from "../account/AccountDrawer";
import { DebtorsFilters } from "./DebtorsFilters";
import { DebtorsTable } from "./DebtorsTable";

interface DebtorsViewProps {
  filters: DebtorFilters;
  onFiltersChange: (filters: DebtorFilters) => void;
  communities: { id: string; name: string; sectors: SectorTab[] }[];
}

const toQuery = (f: DebtorFilters) => ({
  community_id: f.communityId,
  sector_id: f.sectorId,
  search: f.search.trim(),
  min_overdue_receipts: f.minOverdueReceipts,
  min_debt: f.minDebt,
  cut_threshold: f.cutThreshold,
  only_cut_candidates: f.onlyCutCandidates,
});

/** Morosos: who owes, how much and for how long; export and jump to the cash desk. */
export function DebtorsView({ filters, onFiltersChange, communities }: DebtorsViewProps) {
  const { data, loading, reload } = useDebtors(filters);
  const [openCustomerId, setOpenCustomerId] = useState<string | null>(null);
  const patch = useCallback(
    (p: Partial<DebtorFilters>) => onFiltersChange({ ...filters, ...p }),
    [filters, onFiltersChange],
  );

  return (
    <div className="flex flex-col gap-4 flex-1 min-h-[calc(100vh-9rem)]">
      <div className="flex flex-wrap items-end justify-between gap-3">
        <DebtorsFilters filters={filters} onChange={patch} communities={communities} />
        <button
          type="button"
          onClick={() => downloadReport("/admin/reports/debtors.xlsx", toQuery(filters))}
          disabled={!data || data.debtors.length === 0}
          className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-cyan-400 text-black hover:bg-cyan-300 flex items-center gap-1.5 disabled:opacity-40"
        >
          <Download className="w-3.5 h-3.5" /> Exportar Excel
        </button>
      </div>

      {data && (
        <div className="flex flex-wrap items-center gap-x-6 gap-y-1 text-xs">
          <span className="text-zinc-400">
            <strong className="text-white tabular-nums">{data.debtors.length}</strong> clientes con
            deuda
          </span>
          <span className="text-zinc-400">
            Deuda{" "}
            <strong className="text-red-400 tabular-nums">{formatSoles(data.totalDebt)}</strong>
          </span>
          <span className="text-zinc-400">
            Vencida{" "}
            <strong className="text-zinc-200 tabular-nums">{formatSoles(data.overdueDebt)}</strong>
          </span>
          <span className="text-zinc-400">
            Candidatos a corte{" "}
            <strong className="text-zinc-200 tabular-nums">{data.cutCandidates}</strong>
          </span>
          {loading && <Loader2 className="w-3.5 h-3.5 text-zinc-500 animate-spin" />}
        </div>
      )}

      <div className="flex-1 min-h-[50vh] bg-zinc-900/60 border border-zinc-800 rounded-2xl overflow-auto">
        {data ? (
          <DebtorsTable debtors={data.debtors} onOpen={setOpenCustomerId} />
        ) : (
          <div className="flex justify-center py-16">
            <Loader2 className="w-6 h-6 text-zinc-600 animate-spin" />
          </div>
        )}
      </div>

      {openCustomerId && (
        <AccountDrawer
          customerId={openCustomerId}
          onClose={() => setOpenCustomerId(null)}
          onChanged={reload}
        />
      )}
    </div>
  );
}
