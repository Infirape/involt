// Pure chart helpers (axis scale, labels) and the validated chart palette.

/** Validated for the dark surface #18181b (dataviz validator, categorical, 2 slots). */
export const SERIES_COLORS = {
  billed: "#3987e5",
  collected: "#d95926",
} as const;

/** Ordinal blue ramp for aging buckets, least to most overdue (validated --ordinal, dark). */
export const AGING_COLORS = ["#1c5cab", "#2a78d6", "#5598e7", "#86b6ef", "#b7d3f6"] as const;

/** Evenly spaced ticks from 0 to a "nice" max (1/2/5 × 10^n step) covering `max`. */
export function niceTicks(max: number, targetCount = 5): number[] {
  if (max <= 0) return [0, 1];
  const rawStep = max / targetCount;
  const magnitude = 10 ** Math.floor(Math.log10(rawStep));
  const step = [1, 2, 5, 10].map((m) => m * magnitude).find((s) => s >= rawStep) ?? 10 * magnitude;
  const top = Math.ceil(max / step) * step;
  const ticks: number[] = [];
  for (let v = 0; v <= top + step / 2; v += step) ticks.push(Math.round(v * 100) / 100);
  return ticks;
}

export function formatSolesCompact(value: number): string {
  if (Math.abs(value) < 1000) return `S/ ${Math.round(value)}`;
  const k = value / 1000;
  return `S/ ${Number.isInteger(k) ? k : k.toFixed(1)}k`;
}
