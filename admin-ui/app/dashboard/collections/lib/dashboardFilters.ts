import { COLLECTIONS_FIRST_PERIOD } from "./periods.ts";

/** Filters picked on the collections summary; empty strings mean "default" / "all". */
export interface DashboardSelection {
  fromPeriod: string;
  toPeriod: string;
  communityId: string;
  sectorId: string;
}

export const EMPTY_DASHBOARD_FILTERS: DashboardSelection = {
  fromPeriod: "",
  toPeriod: "",
  communityId: "",
  sectorId: "",
};

export const DASHBOARD_FILTERS_STORAGE_KEY = "involt.collections.dashboardFilters";

const str = (v: unknown) => (typeof v === "string" ? v : "");

const validPeriod = (v: unknown) => {
  const p = str(v);
  return /^\d{4}-(0[1-9]|1[0-2])$/.test(p) && p >= COLLECTIONS_FIRST_PERIOD ? p : "";
};

/** Reads a stored selection defensively: anything invalid falls back to the default. */
export function parseStoredFilters(raw: string | null): DashboardSelection {
  let value: unknown;
  try {
    value = raw ? JSON.parse(raw) : null;
  } catch {
    return EMPTY_DASHBOARD_FILTERS;
  }
  if (!value || typeof value !== "object" || Array.isArray(value)) return EMPTY_DASHBOARD_FILTERS;
  const v = value as Record<string, unknown>;
  const fromPeriod = validPeriod(v.fromPeriod);
  const toPeriod = validPeriod(v.toPeriod);
  return {
    fromPeriod,
    toPeriod: fromPeriod && toPeriod && toPeriod < fromPeriod ? "" : toPeriod,
    communityId: str(v.communityId),
    sectorId: str(v.sectorId),
  };
}
