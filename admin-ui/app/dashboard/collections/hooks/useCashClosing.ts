import { create } from "@bufbuild/protobuf";
import { useCallback, useEffect, useState } from "react";
import { toast } from "sonner";
import {
  GetCashClosingRequestSchema,
  type GetCashClosingResponse,
} from "@/app/gen/involt/v1/payments_pb";
import { adminClient } from "@/lib/rpc";
import { rpcErrorMessage } from "../lib/api";
import { paymentMethodLabel } from "../lib/labels";
import { buildCsv, formatLimaDateTime, limaToday } from "../lib/money";

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

  const exportCsv = useCallback(() => {
    if (!data) return;
    const header = [
      "N° comprobante",
      "Fecha",
      "Código",
      "Cliente",
      "Periodos",
      "Medio",
      "Referencia",
      "Cobrado por",
      "Monto",
      "Estado",
    ];
    const rows = data.payments.map((p) => [
      String(p.receiptNumber),
      formatLimaDateTime(p.paidAt),
      p.customerCode,
      p.customerName,
      p.allocations.map((a) => a.period).join(" "),
      paymentMethodLabel(p.method),
      p.reference,
      p.collectedByEmail,
      p.amount.toFixed(2),
      p.voided ? `ANULADO: ${p.voidReason}` : "Válido",
    ]);
    // BOM so Excel opens accents correctly.
    const blob = new Blob([`﻿${buildCsv(header, rows)}`], { type: "text/csv;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = `cierre_caja_${dateFrom}${dateTo !== dateFrom ? `_${dateTo}` : ""}.csv`;
    link.click();
    URL.revokeObjectURL(url);
  }, [data, dateFrom, dateTo]);

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
    exportCsv,
  };
}
