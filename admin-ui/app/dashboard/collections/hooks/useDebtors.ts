import { create } from "@bufbuild/protobuf";
import { useCallback, useEffect, useState } from "react";
import { toast } from "sonner";
import { GetDebtorsRequestSchema, type GetDebtorsResponse } from "@/app/gen/involt/v1/reports_pb";
import { adminClient } from "@/lib/rpc";
import { rpcErrorMessage } from "../lib/api";
import { formatPeriod } from "../lib/labels";
import { buildCsv, formatLimaDateTime, limaToday } from "../lib/money";

export interface DebtorFilters {
  communityId: string;
  sectorId: string;
  search: string;
  minOverdueReceipts: number;
  minDebt: number;
  cutThreshold: number;
  onlyCutCandidates: boolean;
}

export const DEFAULT_DEBTOR_FILTERS: DebtorFilters = {
  communityId: "",
  sectorId: "",
  search: "",
  minOverdueReceipts: 0,
  minDebt: 0,
  cutThreshold: 2,
  onlyCutCandidates: false,
};

/** Debtors list (morosos) with debounced search, reload and CSV export. */
export function useDebtors(filters: DebtorFilters) {
  const [data, setData] = useState<GetDebtorsResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [reloadToken, setReloadToken] = useState(0);

  // biome-ignore lint/correctness/useExhaustiveDependencies: reloadToken forces a refetch
  useEffect(() => {
    let cancelled = false;
    // Debounce so typing in the search box doesn't fire a request per key.
    const timer = setTimeout(() => {
      setLoading(true);
      adminClient
        .getDebtors(create(GetDebtorsRequestSchema, filters))
        .then((resp) => {
          if (!cancelled) setData(resp);
        })
        .catch((err: unknown) => {
          if (!cancelled) toast.error(rpcErrorMessage(err, "Error al cargar la lista de morosos"));
        })
        .finally(() => {
          if (!cancelled) setLoading(false);
        });
    }, 250);
    return () => {
      cancelled = true;
      clearTimeout(timer);
    };
  }, [filters, reloadToken]);

  const reload = useCallback(() => setReloadToken((t) => t + 1), []);

  const exportCsv = useCallback(() => {
    if (!data) return;
    const header = [
      "Código",
      "Cliente",
      "Comunidad",
      "Caserío",
      "Deuda total",
      "Deuda vencida",
      "Recibos pendientes",
      "Recibos vencidos",
      "Vencido desde",
      "Días de atraso",
      "Último pago",
      "Candidato a corte",
    ];
    const rows = data.debtors.map((d) => [
      d.customerCode,
      d.customerName,
      d.communityName,
      d.sectorName,
      d.totalDebt.toFixed(2),
      d.overdueDebt.toFixed(2),
      String(d.pendingReceipts),
      String(d.overdueReceipts),
      d.oldestOverduePeriod ? formatPeriod(d.oldestOverduePeriod) : "",
      String(d.daysOverdue),
      d.lastPaymentAt ? formatLimaDateTime(d.lastPaymentAt) : "Nunca",
      d.cutCandidate ? "Sí" : "No",
    ]);
    const blob = new Blob([`﻿${buildCsv(header, rows)}`], { type: "text/csv;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = `morosos_${limaToday()}.csv`;
    link.click();
    URL.revokeObjectURL(url);
  }, [data]);

  return { data, loading, reload, exportCsv };
}
