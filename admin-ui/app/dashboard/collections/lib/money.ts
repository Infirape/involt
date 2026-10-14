// Pure money/date helpers for the collections module (no React, no generated code)
// so they can be unit-tested with `node --test`.

const toCents = (value: number): number => Math.round(value * 100);

export function sumAmounts(values: number[]): number {
  return values.reduce((acc, v) => acc + toCents(v), 0) / 100;
}

const solesFormatter = new Intl.NumberFormat("en-US", {
  minimumFractionDigits: 2,
  maximumFractionDigits: 2,
});

export function formatSoles(value: number): string {
  return `S/ ${solesFormatter.format(value)}`;
}

/** Parses a user-typed amount ("12.5", "12,50"); returns null if invalid or negative. */
export function parseAmount(raw: string): number | null {
  const normalized = raw.trim().replace(",", ".");
  if (!/^\d+(\.\d{1,2})?$/.test(normalized)) return null;
  return Number(normalized);
}

/** Percentage of billed that was collected, one decimal. */
export function collectionRate(billed: number, collected: number): number {
  if (billed <= 0) return 0;
  return Math.round((collected / billed) * 1000) / 10;
}

/** Today's date in Lima as YYYY-MM-DD (the cash desk calendar day). */
export function limaToday(now: Date = new Date()): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "America/Lima",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(now);
}

/** Formats an ISO timestamp as dd/mm/yyyy hh:mm in Lima time. */
export function formatLimaDateTime(iso: string): string {
  if (!iso) return "—";
  return new Intl.DateTimeFormat("es-PE", {
    timeZone: "America/Lima",
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  }).format(new Date(iso));
}

function csvField(value: string): string {
  return /[",\r\n]/.test(value) ? `"${value.replaceAll('"', '""')}"` : value;
}

export function buildCsv(header: string[], rows: string[][]): string {
  return [header, ...rows].map((row) => row.map(csvField).join(",")).join("\r\n");
}
