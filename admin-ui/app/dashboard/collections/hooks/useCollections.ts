import { create } from "@bufbuild/protobuf";
import { startTransition, useCallback, useEffect, useMemo, useState } from "react";
import { toast } from "sonner";
import { type CollectionCustomer, GetCollectionsRequestSchema } from "@/app/gen/involt/v1/admin_pb";
import { ReceiptStatus } from "@/app/gen/involt/v1/payments_pb";
import { adminClient } from "@/lib/rpc";
import type { CustomerRow, Half, MatrixCell, MatrixTotals } from "../types";

const YEAR_KEY = "involt_collections_year";
const HALF_KEY = "involt_collections_half";

function readStorage(key: string): string | null {
  try {
    return localStorage.getItem(key);
  } catch {
    return null;
  }
}

function writeStorage(key: string, value: string) {
  try {
    localStorage.setItem(key, value);
  } catch {
    // Storage unavailable (private mode): the selection just isn't remembered.
  }
}

function emptyCell(customerId: string, customerName: string, period: string): MatrixCell {
  return {
    readingId: "",
    customerId,
    customerName,
    period,
    total: 0,
    paid: 0,
    balance: 0,
    status: ReceiptStatus.UNSPECIFIED,
  };
}

function toCustomerRows(entries: CollectionCustomer[], periods: string[]): CustomerRow[] {
  const rows: CustomerRow[] = [];
  for (const entry of entries) {
    const customer = entry.customer;
    if (!customer) continue;
    const cells = Object.fromEntries(
      periods.map((p) => [p, emptyCell(customer.id, customer.name, p)]),
    );
    for (const receipt of entry.receipts) {
      const r = receipt.reading;
      if (!r || !(r.period in cells)) continue;
      cells[r.period] = {
        readingId: r.id,
        customerId: customer.id,
        customerName: customer.name,
        period: r.period,
        total: r.totalToPay,
        paid: receipt.paidAmount,
        balance: receipt.balance,
        status: receipt.status,
      };
    }
    rows.push({
      customerId: customer.id,
      customerCode: customer.code,
      customerName: customer.name,
      totalDebt: entry.totalDebt,
      cells,
    });
  }
  return rows.sort((a, b) => a.customerName.localeCompare(b.customerName));
}

/** Collections matrix for one sector over a half-year, with balances and totals. */
export function useCollections(selectedSectorId: string) {
  // Server-compatible defaults; localStorage is read after mount to avoid hydration mismatch.
  const [selectedYear, setSelectedYear] = useState(() => new Date().getFullYear());
  const [selectedHalf, setSelectedHalf] = useState<Half>(() =>
    new Date().getMonth() < 6 ? "H1" : "H2",
  );
  const [customerRows, setCustomerRows] = useState<CustomerRow[]>([]);
  const [totals, setTotals] = useState<MatrixTotals>({ billed: 0, collected: 0 });
  const [loading, setLoading] = useState(false);
  const [reloadToken, setReloadToken] = useState(0);

  useEffect(() => {
    startTransition(() => {
      const savedYear = readStorage(YEAR_KEY);
      if (savedYear) setSelectedYear(Number.parseInt(savedYear, 10));
      const savedHalf = readStorage(HALF_KEY);
      if (savedHalf === "H1" || savedHalf === "H2") setSelectedHalf(savedHalf);
    });
  }, []);

  useEffect(() => writeStorage(YEAR_KEY, String(selectedYear)), [selectedYear]);
  useEffect(() => writeStorage(HALF_KEY, selectedHalf), [selectedHalf]);

  const periods = useMemo<string[]>(() => {
    const months = selectedHalf === "H1" ? [1, 2, 3, 4, 5, 6] : [7, 8, 9, 10, 11, 12];
    return months.map((m) => `${selectedYear}-${String(m).padStart(2, "0")}`);
  }, [selectedYear, selectedHalf]);

  // biome-ignore lint/correctness/useExhaustiveDependencies: reloadToken forces a refetch after payments
  useEffect(() => {
    if (!selectedSectorId) return;
    let cancelled = false;

    async function fetchCollections() {
      setLoading(true);
      try {
        const resp = await adminClient.getCollections(
          create(GetCollectionsRequestSchema, { sectorId: selectedSectorId, periods }),
        );
        if (cancelled) return;

        const rows = toCustomerRows(resp.customers, periods);
        setCustomerRows(rows);
        setTotals({ billed: resp.totalBilled, collected: resp.totalCollected });
      } catch {
        if (!cancelled) toast.error("Error al cargar datos de cobranza");
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    void fetchCollections();
    return () => {
      cancelled = true;
    };
  }, [selectedSectorId, periods, reloadToken]);

  const reload = useCallback(() => setReloadToken((t) => t + 1), []);

  return {
    periods,
    customerRows,
    totals,
    loading,
    reload,
    selectedYear,
    setSelectedYear,
    selectedHalf,
    setSelectedHalf,
  };
}
