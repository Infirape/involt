"use client";

import { BarChart3, DollarSign, Grid3x3, Receipt, UserX, Wallet } from "lucide-react";
import { useMemo, useState } from "react";
import { CollectionsMatrix } from "./components/CollectionsMatrix";
import { CashClosing } from "./components/closing/CashClosing";
import { CollectionsDashboard } from "./components/dashboard/CollectionsDashboard";
import { DebtorsView } from "./components/debtors/DebtorsView";
import { CashDesk } from "./components/desk/CashDesk";
import { SectorSidebar } from "./components/SectorSidebar";
import { DEFAULT_DEBTOR_FILTERS, type DebtorFilters } from "./hooks/useDebtors";
import { useSectors } from "./hooks/useSectors";

type Tab = "summary" | "matrix" | "debtors" | "desk" | "closing";

const TABS: { id: Tab; label: string; icon: typeof Grid3x3 }[] = [
  { id: "summary", label: "Resumen", icon: BarChart3 },
  { id: "matrix", label: "Por caserío", icon: Grid3x3 },
  { id: "debtors", label: "Morosos", icon: UserX },
  { id: "desk", label: "Caja", icon: Wallet },
  { id: "closing", label: "Cierre de caja", icon: Receipt },
];

export default function CollectionsPage() {
  const [tab, setTab] = useState<Tab>("summary");
  const sectors = useSectors();
  // Lifted so the dashboard's "candidatos a corte" tile can open a pre-filtered list.
  const [debtorFilters, setDebtorFilters] = useState<DebtorFilters>(DEFAULT_DEBTOR_FILTERS);
  const communities = useMemo(
    () =>
      Object.entries(sectors.communitiesWithSectors).map(([id, c]) => ({
        id,
        name: c.name,
        sectors: c.sectors,
      })),
    [sectors.communitiesWithSectors],
  );

  return (
    <div className="h-full flex flex-col gap-5 p-6">
      <div className="flex flex-wrap items-center gap-4 justify-between">
        <div className="flex items-center gap-3">
          <div className="p-2 rounded-xl bg-emerald-500/10 border border-emerald-500/20">
            <DollarSign className="w-6 h-6 text-emerald-400" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-white">Cobranzas</h1>
            <p className="text-sm text-zinc-400">Resumen, morosos, pagos y cierre de caja</p>
          </div>
        </div>

        <div
          role="tablist"
          className="flex items-center bg-zinc-900/80 border border-zinc-800 rounded-xl p-1"
        >
          {TABS.map(({ id, label, icon: Icon }) => (
            <button
              key={id}
              type="button"
              role="tab"
              aria-selected={tab === id}
              onClick={() => setTab(id)}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-colors ${
                tab === id ? "bg-zinc-800 text-white" : "text-zinc-400 hover:text-zinc-200"
              }`}
            >
              <Icon className="w-3.5 h-3.5" />
              {label}
            </button>
          ))}
        </div>
      </div>

      {tab === "summary" && (
        <CollectionsDashboard
          communities={communities}
          onShowCutCandidates={() => {
            setDebtorFilters({ ...DEFAULT_DEBTOR_FILTERS, onlyCutCandidates: true });
            setTab("debtors");
          }}
        />
      )}
      {tab === "debtors" && (
        <DebtorsView
          filters={debtorFilters}
          onFiltersChange={setDebtorFilters}
          communities={communities}
        />
      )}
      {tab === "matrix" && (
        <div className="flex gap-4 flex-1 min-h-0">
          <SectorSidebar
            communitiesWithSectors={sectors.communitiesWithSectors}
            selectedSectorId={sectors.selectedSectorId}
            expandedCommunities={sectors.expandedCommunities}
            onSelectSector={sectors.selectSector}
            onToggleCommunity={sectors.toggleCommunity}
          />
          <CollectionsMatrix
            selectedSectorId={sectors.selectedSectorId}
            selectedSector={sectors.selectedSector}
          />
        </div>
      )}
      {tab === "desk" && <CashDesk />}
      {tab === "closing" && <CashClosing />}
    </div>
  );
}
