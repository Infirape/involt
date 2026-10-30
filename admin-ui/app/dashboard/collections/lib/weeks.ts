// Treasury weeks run Monday to Sunday; dates are YYYY-MM-DD (Lima calendar days).

export interface DateRange {
  from: string;
  to: string;
}

const toIso = (d: Date) => d.toISOString().slice(0, 10);

function addDays(iso: string, days: number): string {
  const d = new Date(`${iso}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + days);
  return toIso(d);
}

function mondayOf(iso: string): string {
  const weekday = new Date(`${iso}T00:00:00Z`).getUTCDay(); // Sunday = 0
  return addDays(iso, -((weekday + 6) % 7));
}

/** This week so far: Monday to today. */
export function currentWeek(today: string): DateRange {
  return { from: mondayOf(today), to: today };
}

/** Last complete week: the Monday-to-Sunday before this one. */
export function previousWeek(today: string): DateRange {
  const from = addDays(mondayOf(today), -7);
  return { from, to: addDays(from, 6) };
}
