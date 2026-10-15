import { create } from "@bufbuild/protobuf";
import { useEffect, useState } from "react";
import { toast } from "sonner";
import {
  GetCollectionsDashboardRequestSchema,
  type GetCollectionsDashboardResponse,
} from "@/app/gen/involt/v1/reports_pb";
import { adminClient } from "@/lib/rpc";
import { rpcErrorMessage } from "../lib/api";

export interface DashboardFilters {
  /** YYYY-MM; empty lets the backend default to the last 12 months. */
  fromPeriod: string;
  toPeriod: string;
  communityId: string;
  /** Caserío (sector); empty = all. */
  sectorId: string;
}

/** Collections dashboard (billed vs collected, by sector and month, debt aging). */
export function useCollectionsDashboard(filters: DashboardFilters) {
  const [data, setData] = useState<GetCollectionsDashboardResponse | null>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    let cancelled = false;
    setLoading(true);
    adminClient
      .getCollectionsDashboard(create(GetCollectionsDashboardRequestSchema, filters))
      .then((resp) => {
        if (!cancelled) setData(resp);
      })
      .catch((err: unknown) => {
        if (!cancelled) toast.error(rpcErrorMessage(err, "Error al cargar el resumen de cobranza"));
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [filters]);

  return { data, loading };
}
