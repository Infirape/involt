import { useState } from "react";
import type { PeriodCollectionSummary } from "@/app/gen/involt/v1/reports_pb";
import { formatSolesCompact, niceTicks, SERIES_COLORS } from "../../lib/chart";
import { formatPeriod } from "../../lib/labels";
import { collectionRate, formatSoles } from "../../lib/money";

const W = 720;
const H = 240;
const PAD = { top: 12, right: 8, bottom: 28, left: 56 };
const plotW = W - PAD.left - PAD.right;
const plotH = H - PAD.top - PAD.bottom;

/** Bar with 4px rounded top corners anchored flat on the baseline. */
function barPath(x: number, y: number, w: number, h: number): string {
  if (h <= 0) return "";
  const r = Math.min(4, w / 2, h);
  return `M${x},${y + h}V${y + r}Q${x},${y} ${x + r},${y}H${x + w - r}Q${x + w},${y} ${x + w},${y + r}V${y + h}Z`;
}

export function MonthlyChart({ periods }: { periods: PeriodCollectionSummary[] }) {
  const [hover, setHover] = useState<number | null>(null);
  const [showTable, setShowTable] = useState(false);

  const ticks = niceTicks(Math.max(0, ...periods.map((p) => Math.max(p.billed, p.collected))));
  const top = ticks[ticks.length - 1];
  const y = (v: number) => PAD.top + plotH - (v / top) * plotH;
  const band = plotW / Math.max(periods.length, 1);
  const barW = Math.max(2, Math.min(18, (band - 8) / 2 - 1));
  const hovered = hover === null ? null : periods[hover];

  return (
    <section className="p-4 rounded-2xl border border-zinc-800 bg-zinc-900/60">
      <div className="flex flex-wrap items-center justify-between gap-2 mb-3">
        <h3 className="text-sm font-semibold text-white">Facturado vs cobrado por mes</h3>
        <div className="flex items-center gap-4 text-[11px] text-zinc-400">
          <LegendItem color={SERIES_COLORS.billed} label="Facturado" />
          <LegendItem color={SERIES_COLORS.collected} label="Cobrado (de ese mes)" />
          <button
            type="button"
            onClick={() => setShowTable((v) => !v)}
            className="text-cyan-400 hover:text-cyan-300"
          >
            {showTable ? "Ver gráfico" : "Ver tabla"}
          </button>
        </div>
      </div>

      {showTable ? (
        <MonthlyTable periods={periods} />
      ) : (
        <div className="relative">
          <svg
            viewBox={`0 0 ${W} ${H}`}
            className="w-full h-auto"
            role="img"
            aria-label="Facturado y cobrado por mes"
            onMouseLeave={() => setHover(null)}
          >
            {ticks.map((t) => (
              <g key={t}>
                <line
                  x1={PAD.left}
                  x2={W - PAD.right}
                  y1={y(t)}
                  y2={y(t)}
                  stroke="#27272a"
                  strokeWidth={1}
                />
                <text
                  x={PAD.left - 8}
                  y={y(t) + 3}
                  textAnchor="end"
                  className="fill-zinc-500 text-[10px]"
                >
                  {formatSolesCompact(t)}
                </text>
              </g>
            ))}
            {periods.map((p, i) => {
              const cx = PAD.left + band * i + band / 2;
              const showLabel = periods.length <= 12 || i % Math.ceil(periods.length / 12) === 0;
              return (
                <g key={p.period}>
                  {hover === i && (
                    <rect
                      x={cx - band / 2}
                      y={PAD.top}
                      width={band}
                      height={plotH}
                      fill="#ffffff"
                      opacity={0.04}
                    />
                  )}
                  <path
                    d={barPath(cx - barW - 1, y(p.billed), barW, y(0) - y(p.billed))}
                    fill={SERIES_COLORS.billed}
                  />
                  <path
                    d={barPath(cx + 1, y(p.collected), barW, y(0) - y(p.collected))}
                    fill={SERIES_COLORS.collected}
                  />
                  {showLabel && (
                    <text
                      x={cx}
                      y={H - 10}
                      textAnchor="middle"
                      className="fill-zinc-500 text-[10px]"
                    >
                      {formatPeriod(p.period)}
                    </text>
                  )}
                  {/* Hit target spans the whole month column, bigger than the bars. */}
                  {/* biome-ignore lint/a11y/noStaticElementInteractions: hover-only tooltip; the table view is the accessible equivalent */}
                  <rect
                    x={cx - band / 2}
                    y={PAD.top}
                    width={band}
                    height={plotH}
                    fill="transparent"
                    onMouseEnter={() => setHover(i)}
                  />
                </g>
              );
            })}
            <line
              x1={PAD.left}
              x2={W - PAD.right}
              y1={y(0)}
              y2={y(0)}
              stroke="#3f3f46"
              strokeWidth={1}
            />
          </svg>

          {hovered && hover !== null && (
            <div
              className="pointer-events-none absolute top-2 z-10 min-w-[180px] rounded-xl border border-zinc-700 bg-zinc-950/95 p-3 text-[11px] shadow-xl"
              style={{
                left: `${((PAD.left + band * hover + band / 2) / W) * 100}%`,
                transform:
                  hover > periods.length / 2
                    ? "translateX(calc(-100% - 12px))"
                    : "translateX(12px)",
              }}
            >
              <p className="font-semibold text-white mb-1.5">{formatPeriod(hovered.period)}</p>
              <TooltipRow
                color={SERIES_COLORS.billed}
                label="Facturado"
                value={formatSoles(hovered.billed)}
              />
              <TooltipRow
                color={SERIES_COLORS.collected}
                label="Cobrado"
                value={formatSoles(hovered.collected)}
              />
              <div className="mt-1.5 pt-1.5 border-t border-zinc-800 space-y-0.5 text-zinc-400">
                <div className="flex justify-between gap-4">
                  <span>% cobranza</span>
                  <span className="text-zinc-200 tabular-nums">
                    {collectionRate(hovered.billed, hovered.collected)}%
                  </span>
                </div>
                <div className="flex justify-between gap-4">
                  <span>Ingresó a caja</span>
                  <span className="text-zinc-200 tabular-nums">{formatSoles(hovered.cashIn)}</span>
                </div>
              </div>
            </div>
          )}
        </div>
      )}
    </section>
  );
}

function LegendItem({ color, label }: { color: string; label: string }) {
  return (
    <span className="flex items-center gap-1.5">
      <span className="w-2.5 h-2.5 rounded-sm" style={{ background: color }} />
      {label}
    </span>
  );
}

function TooltipRow({ color, label, value }: { color: string; label: string; value: string }) {
  return (
    <div className="flex items-center justify-between gap-4">
      <span className="flex items-center gap-1.5 text-zinc-400">
        <span className="w-2 h-2 rounded-sm" style={{ background: color }} />
        {label}
      </span>
      <span className="text-zinc-100 font-semibold tabular-nums">{value}</span>
    </div>
  );
}

function MonthlyTable({ periods }: { periods: PeriodCollectionSummary[] }) {
  return (
    <div className="max-h-64 overflow-auto">
      <table className="w-full text-xs">
        <thead className="sticky top-0 bg-zinc-900 text-zinc-400">
          <tr>
            <th className="text-left py-1.5 font-semibold">Mes</th>
            <th className="text-right py-1.5 font-semibold">Facturado</th>
            <th className="text-right py-1.5 font-semibold">Cobrado</th>
            <th className="text-right py-1.5 font-semibold">% cobranza</th>
            <th className="text-right py-1.5 font-semibold">Ingresó a caja</th>
          </tr>
        </thead>
        <tbody className="tabular-nums">
          {periods.map((p) => (
            <tr key={p.period} className="border-t border-zinc-800/60 text-zinc-300">
              <td className="py-1.5">{formatPeriod(p.period)}</td>
              <td className="text-right">{formatSoles(p.billed)}</td>
              <td className="text-right">{formatSoles(p.collected)}</td>
              <td className="text-right">{collectionRate(p.billed, p.collected)}%</td>
              <td className="text-right">{formatSoles(p.cashIn)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
