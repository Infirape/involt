import { create } from "@bufbuild/protobuf";
import { useCallback, useEffect, useState } from "react";
import { toast } from "sonner";
import {
  GetCashClosingRequestSchema,
  type GetCashClosingResponse,
} from "@/app/gen/involt/v1/payments_pb";
import { adminClient } from "@/lib/rpc";
import { rpcErrorMessage } from "../lib/api";
import { limaToday } from "../lib/money";

/** Cash closing (cierre de caja) for a Lima date range, optionally per collector. */
export function useCashClosing() {
  const [dateFrom, setDateFrom] = useState(() => limaToday());
  const [dateTo, setDateTo] = useState(() => limaToday());
  const [collectedBy, setCollectedBy] = useState("");
  const [data, setData] = useState<GetCashClosingResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [reloadToken, setReloadToken] = useState(0);

  // biome-ignore lint/correctness/useExhaustiveDependencies: reloadToken forces a refetch
  useEffect(() => {
    let cancelled = false;
    setLoading(true);
    adminClient
      .getCashClosing(create(GetCashClosingRequestSchema, { dateFrom, dateTo, collectedBy }))
      .then((resp) => {
        if (!cancelled) setData(resp);
      })
      .catch((err: unknown) => {
        if (!cancelled) toast.error(rpcErrorMessage(err, "Error al cargar el cierre de caja"));
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [dateFrom, dateTo, collectedBy, reloadToken]);

  const reload = useCallback(() => setReloadToken((t) => t + 1), []);

  return {
    dateFrom,
    setDateFrom,
    dateTo,
    setDateTo,
    collectedBy,
    setCollectedBy,
    data,
    loading,
    reload,
  };
}
