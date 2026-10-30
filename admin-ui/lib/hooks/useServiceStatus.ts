import { create } from "@bufbuild/protobuf";
import { Code, ConnectError } from "@connectrpc/connect";
import { useCallback, useEffect, useState } from "react";
import { toast } from "sonner";
import {
  GetCustomerStatusHistoryRequestSchema,
  type ServiceStatusChange,
  SetCustomerServiceStatusRequestSchema,
} from "@/app/gen/involt/v1/admin_pb";
import type { Customer, ServiceStatus } from "@/app/gen/involt/v1/models_pb";
import { adminClient } from "@/lib/rpc";

/** History and change action for a supply's service status. */
export function useServiceStatus(customerId: string) {
  const [history, setHistory] = useState<ServiceStatusChange[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    let cancelled = false;
    adminClient
      .getCustomerStatusHistory(create(GetCustomerStatusHistoryRequestSchema, { customerId }))
      .then((resp) => {
        if (!cancelled) setHistory(resp.changes);
      })
      .catch(() => {
        if (!cancelled) toast.error("No se pudo cargar el historial de estados");
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [customerId]);

  const changeStatus = useCallback(
    async (status: ServiceStatus, reason: string): Promise<Customer | null> => {
      setSaving(true);
      try {
        const resp = await adminClient.setCustomerServiceStatus(
          create(SetCustomerServiceStatusRequestSchema, { customerId, status, reason }),
        );
        toast.success("Estado del suministro actualizado");
        return resp.customer ?? null;
      } catch (err) {
        const message =
          err instanceof ConnectError && err.code === Code.PermissionDenied
            ? "Solo un administrador puede cambiar el estado"
            : err instanceof ConnectError && err.code === Code.FailedPrecondition
              ? "Elegí un estado distinto al actual e ingresá el motivo"
              : "No se pudo cambiar el estado";
        toast.error(message);
        return null;
      } finally {
        setSaving(false);
      }
    },
    [customerId],
  );

  return { history, loading, saving, changeStatus };
}
