import { limaToday } from "./money.ts";

/** Collections data before this month (YYYY-MM) is not reliable: filters never go earlier. */
export const COLLECTIONS_FIRST_PERIOD = "2026-09";

/** Lowest month a filter may take: the given bound, but never before the floor. */
export function earliestPeriod(bound = ""): string {
  return bound > COLLECTIONS_FIRST_PERIOD ? bound : COLLECTIONS_FIRST_PERIOD;
}

/** Start of the default range: the 12 months ending `currentPeriod`, clamped to the floor. */
export function defaultFromPeriod(currentPeriod: string = limaToday().slice(0, 7)): string {
  const [year, month] = currentPeriod.split("-").map(Number);
  const index = year * 12 + (month - 1) - 11;
  const start = `${Math.floor(index / 12)}-${String((index % 12) + 1).padStart(2, "0")}`;
  return earliestPeriod(start);
}
