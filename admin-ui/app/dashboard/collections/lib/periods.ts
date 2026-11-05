import { limaToday } from "./money.ts";

/** Collections data before this month (YYYY-MM) is not reliable: filters never go earlier. */
export const COLLECTIONS_FIRST_PERIOD = "2026-09";

/** Lowest month a filter may take: the given bound, but never before the floor. */
export function earliestPeriod(bound = ""): string {
  return bound > COLLECTIONS_FIRST_PERIOD ? bound : COLLECTIONS_FIRST_PERIOD;
}

/** Drops periods before the floor, so they never reach a filter. */
export function visiblePeriods<T extends { id: string }>(periods: T[]): T[] {
  return periods.filter((p) => p.id >= COLLECTIONS_FIRST_PERIOD);
}

type Semester = "H1" | "H2";

const [FIRST_YEAR, FIRST_MONTH] = COLLECTIONS_FIRST_PERIOD.split("-").map(Number);
const FIRST_SEMESTER: Semester = FIRST_MONTH <= 6 ? "H1" : "H2";

export const COLLECTIONS_FIRST_YEAR = FIRST_YEAR;

/** Moves a semester before the floor up to the first one that has data. */
export function clampSemester(year: number, half: Semester): { year: number; half: Semester } {
  const beforeFloor = year < FIRST_YEAR || (year === FIRST_YEAR && half < FIRST_SEMESTER);
  return beforeFloor ? { year: FIRST_YEAR, half: FIRST_SEMESTER } : { year, half };
}

/** Whether this is the earliest semester a user can navigate to. */
export function isFirstSemester(year: number, half: Semester): boolean {
  return year === FIRST_YEAR && half === FIRST_SEMESTER;
}

/** Months (YYYY-MM) of a semester, without those before the floor. */
export function semesterMonths(year: number, half: Semester): string[] {
  const months = half === "H1" ? [1, 2, 3, 4, 5, 6] : [7, 8, 9, 10, 11, 12];
  return months
    .map((m) => `${year}-${String(m).padStart(2, "0")}`)
    .filter((p) => p >= COLLECTIONS_FIRST_PERIOD);
}

/** Start of the default range: the 12 months ending `currentPeriod`, clamped to the floor. */
export function defaultFromPeriod(currentPeriod: string = limaToday().slice(0, 7)): string {
  const [year, month] = currentPeriod.split("-").map(Number);
  const index = year * 12 + (month - 1) - 11;
  const start = `${Math.floor(index / 12)}-${String((index % 12) + 1).padStart(2, "0")}`;
  return earliestPeriod(start);
}
