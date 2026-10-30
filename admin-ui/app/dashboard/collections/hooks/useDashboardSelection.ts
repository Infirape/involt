import { useCallback, useEffect, useState } from "react";
import {
  DASHBOARD_FILTERS_STORAGE_KEY,
  type DashboardSelection,
  EMPTY_DASHBOARD_FILTERS,
  parseStoredFilters,
} from "../lib/dashboardFilters";

function readStorage(): string | null {
  try {
    return localStorage.getItem(DASHBOARD_FILTERS_STORAGE_KEY);
  } catch {
    return null;
  }
}

function writeStorage(selection: DashboardSelection) {
  try {
    localStorage.setItem(DASHBOARD_FILTERS_STORAGE_KEY, JSON.stringify(selection));
  } catch {
    // Storage unavailable (private mode): the selection just isn't remembered.
  }
}

/**
 * Summary filters remembered in localStorage across visits. Storage is read after mount
 * (server-compatible first render); `hydrated` tells callers when the real selection is known.
 */
export function useDashboardSelection() {
  const [selection, setSelection] = useState<DashboardSelection>(EMPTY_DASHBOARD_FILTERS);
  const [hydrated, setHydrated] = useState(false);

  useEffect(() => {
    setSelection(parseStoredFilters(readStorage()));
    setHydrated(true);
  }, []);

  const update = useCallback((patch: Partial<DashboardSelection>) => {
    setSelection((prev) => {
      const next = { ...prev, ...patch };
      writeStorage(next);
      return next;
    });
  }, []);

  return { selection, update, hydrated };
}
