import { create } from "@bufbuild/protobuf";
import { useCallback, useEffect, useState } from "react";
import { toast } from "sonner";
import { ServiceStatus } from "@/app/gen/involt/v1/models_pb";
import { GetDebtorsRequestSchema, type GetDebtorsResponse } from "@/app/gen/involt/v1/reports_pb";
import { adminClient } from "@/lib/rpc";
import { rpcErrorMessage } from "../lib/api";

export interface DebtorFilters {
  communityId: string;
  sectorId: string;
  search: string;
  minOverdueReceipts: number;
  minDebt: number;
  cutThreshold: number;
  onlyCutCandidates: boolean;
  serviceStatus: ServiceStatus;
}

export const DEFAULT_DEBTOR_FILTERS: DebtorFilters = {
  communityId: "",
  sectorId: "",
  search: "",
  minOverdueReceipts: 0,
  minDebt: 0,
  cutThreshold: 2,
  onlyCutCandidates: false,
  serviceStatus: ServiceStatus.UNSPECIFIED,
};

/** Debtors list (morosos) with debounced search and reload. */
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

  return { data, loading, reload };
}
