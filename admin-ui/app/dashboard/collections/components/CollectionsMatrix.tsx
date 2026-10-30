import { DollarSign, Loader2, XCircle } from "lucide-react";
import { type ReactNode, useMemo, useState } from "react";
import { useCollections } from "../hooks/useCollections";
import { createFlatCharge } from "../hooks/useCustomerAccount";
import type { MatrixCell, SectorTab } from "../types";
import { AccountDrawer } from "./account/AccountDrawer";
import { FlatChargeDialog } from "./FlatChargeDialog";
import { MatrixFooter } from "./matrix/MatrixFooter";
import { MatrixTable } from "./matrix/MatrixTable";
import { MatrixToolbar } from "./matrix/MatrixToolbar";

interface CollectionsMatrixProps {
  selectedSectorId: string;
  selectedSector?: SectorTab;
}

export function CollectionsMatrix({ selectedSectorId, selectedSector }: CollectionsMatrixProps) {
  const matrix = useCollections(selectedSectorId);
  const [query, setQuery] = useState("");
  const [onlyDebtors, setOnlyDebtors] = useState(false);
  const [drawer, setDrawer] = useState<{ customerId: string; readingId?: string } | null>(null);
  const [flatCell, setFlatCell] = useState<MatrixCell | null>(null);
  const [creatingCharge, setCreatingCharge] = useState(false);

  const visibleRows = useMemo(() => {
    const q = query.trim().toLowerCase();
    return matrix.customerRows.filter(
      (row) =>
        (!onlyDebtors || row.totalDebt > 0) &&
        (!q ||
          row.customerName.toLowerCase().includes(q) ||
          row.customerCode.toLowerCase().includes(q)),
    );
  }, [matrix.customerRows, query, onlyDebtors]);

  const handleCreateCharge = async (amount: number, observation: string) => {
    if (!flatCell) return;
    setCreatingCharge(true);
    const readingId = await createFlatCharge(
      flatCell.customerId,
      flatCell.period,
      amount,
      observation,
    );
    setCreatingCharge(false);
    if (!readingId) return;
    setFlatCell(null);
    matrix.reload();
    setDrawer({ customerId: flatCell.customerId, readingId });
  };

  return (
    <div className="flex-1 min-w-0 bg-zinc-900/60 border border-zinc-800 rounded-2xl overflow-hidden flex flex-col">
      <MatrixToolbar
        selectedSector={selectedSector}
        visibleCount={visibleRows.length}
        totalCount={matrix.customerRows.length}
        loading={matrix.loading}
        selectedYear={matrix.selectedYear}
        setSelectedYear={matrix.setSelectedYear}
        selectedHalf={matrix.selectedHalf}
        setSelectedHalf={matrix.setSelectedHalf}
        query={query}
        setQuery={setQuery}
        onlyDebtors={onlyDebtors}
        setOnlyDebtors={setOnlyDebtors}
      />

      <div className="flex-1 overflow-auto">
        {!selectedSectorId ? (
          <EmptyState
            icon={<DollarSign className="w-12 h-12 opacity-30" />}
            message="Seleccioná un caserío para ver los pagos"
          />
        ) : matrix.loading && matrix.customerRows.length === 0 ? (
          <div className="flex items-center justify-center h-full">
            <Loader2 className="w-8 h-8 text-zinc-600 animate-spin" />
          </div>
        ) : visibleRows.length === 0 ? (
          <EmptyState
            icon={<XCircle className="w-10 h-10 opacity-30" />}
            message={
              matrix.customerRows.length
                ? "Ningún suministro coincide con el filtro"
                : "Sin suministros registrados para este caserío"
            }
          />
        ) : (
          <MatrixTable
            rows={visibleRows}
            periods={matrix.rowPeriods}
            onOpenCustomer={(customerId, readingId) => setDrawer({ customerId, readingId })}
            onEmptyCell={setFlatCell}
          />
        )}
      </div>

      {matrix.customerRows.length > 0 && <MatrixFooter totals={matrix.totals} />}

      {drawer && (
        <AccountDrawer
          customerId={drawer.customerId}
          preselectedReadingId={drawer.readingId}
          onClose={() => setDrawer(null)}
          onChanged={matrix.reload}
        />
      )}
      {flatCell && (
        <FlatChargeDialog
          customerName={flatCell.customerName}
          period={flatCell.period}
          submitting={creatingCharge}
          onCancel={() => setFlatCell(null)}
          onConfirm={handleCreateCharge}
        />
      )}
    </div>
  );
}

function EmptyState({ icon, message }: { icon: ReactNode; message: string }) {
  return (
    <div className="flex flex-col items-center justify-center h-full gap-3 text-zinc-600 py-16">
      {icon}
      <p className="text-sm">{message}</p>
    </div>
  );
}
