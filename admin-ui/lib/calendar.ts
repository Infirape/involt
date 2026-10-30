// Pure calendar helpers for the Spanish date/month pickers (no React).

export const MONTHS_ES = [
  "Enero",
  "Febrero",
  "Marzo",
  "Abril",
  "Mayo",
  "Junio",
  "Julio",
  "Agosto",
  "Septiembre",
  "Octubre",
  "Noviembre",
  "Diciembre",
];

export const MONTHS_SHORT_ES = MONTHS_ES.map((m) => m.slice(0, 3));

/** Monday-first, as used in Peru. */
export const WEEKDAYS_ES = ["Lu", "Ma", "Mi", "Ju", "Vi", "Sá", "Do"];

export interface DateParts {
  year: number;
  month: number; // 1-12
  day: number;
}

const pad = (n: number) => String(n).padStart(2, "0");

export const daysInMonth = (year: number, month: number) =>
  new Date(Date.UTC(year, month, 0)).getUTCDate();

export function toIsoDate(year: number, month: number, day: number): string {
  return `${year}-${pad(month)}-${pad(day)}`;
}

export function toIsoMonth(year: number, month: number): string {
  return `${year}-${pad(month)}`;
}

export function parseIsoDate(value: string): DateParts | null {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value);
  if (!match) return null;
  const [year, month, day] = match.slice(1).map(Number);
  if (month < 1 || month > 12 || day < 1 || day > daysInMonth(year, month)) return null;
  return { year, month, day };
}

/** Weeks (Monday-first) of a month; days outside the month are null. */
export function monthGrid(year: number, month: number): (number | null)[][] {
  const firstWeekday = (new Date(Date.UTC(year, month - 1, 1)).getUTCDay() + 6) % 7; // Monday = 0
  const cells: (number | null)[] = Array.from({ length: firstWeekday }, () => null);
  for (let d = 1; d <= daysInMonth(year, month); d++) cells.push(d);
  while (cells.length % 7 !== 0) cells.push(null);
  const weeks: (number | null)[][] = [];
  for (let i = 0; i < cells.length; i += 7) weeks.push(cells.slice(i, i + 7));
  return weeks;
}

export function shiftMonth(
  year: number,
  month: number,
  delta: number,
): { year: number; month: number } {
  const index = year * 12 + (month - 1) + delta;
  return { year: Math.floor(index / 12), month: (index % 12) + 1 };
}

/** "2026-10-03" → "03/10/2026"; empty for invalid input. */
export function formatDateEs(value: string): string {
  const p = parseIsoDate(value);
  return p ? `${pad(p.day)}/${pad(p.month)}/${p.year}` : "";
}

/** "2026-09" → "Septiembre 2026"; empty for invalid input. */
export function formatMonthEs(value: string): string {
  const match = /^(\d{4})-(\d{2})$/.exec(value);
  if (!match) return "";
  const month = Number(match[2]);
  return MONTHS_ES[month - 1] ? `${MONTHS_ES[month - 1]} ${match[1]}` : "";
}

/** ISO strings (dates or months) compare lexicographically. */
export function isWithin(value: string, min?: string, max?: string): boolean {
  return (!min || value >= min) && (!max || value <= max);
}
