"use client";

import { useEffect, useState } from "react";
import {
  formatDateEs,
  formatMonthEs,
  isWithin,
  MONTHS_ES,
  MONTHS_SHORT_ES,
  monthGrid,
  parseIsoDate,
  shiftMonth,
  toIsoDate,
  toIsoMonth,
  WEEKDAYS_ES,
} from "@/lib/calendar";
import {
  cellClass,
  NavHeader,
  Panel,
  Trigger,
  todayParts,
  usePopover,
} from "./date-picker-popover";

interface PickerBaseProps {
  value: string;
  onChange: (value: string) => void;
  min?: string;
  max?: string;
  placeholder?: string;
  /** Shows a clear button; onChange("") is emitted. */
  clearable?: boolean;
  className?: string;
  "aria-label"?: string;
}

/** Spanish calendar date picker; value is YYYY-MM-DD ("" when empty). */
export function DatePicker({
  value,
  onChange,
  min,
  max,
  placeholder = "dd/mm/aaaa",
  clearable,
  className,
  ...rest
}: PickerBaseProps) {
  const popover = usePopover();
  const today = todayParts();
  const selected = parseIsoDate(value);
  const [view, setView] = useState({
    year: selected?.year ?? today.year,
    month: selected?.month ?? today.month,
  });

  // Re-center on the selected date every time the calendar opens.
  useEffect(() => {
    if (popover.open)
      setView({ year: selected?.year ?? today.year, month: selected?.month ?? today.month });
  }, [popover.open, selected?.year, selected?.month, today.year, today.month]);

  const pick = (iso: string) => {
    onChange(iso);
    popover.setOpen(false);
  };
  const todayIso = toIsoDate(today.year, today.month, today.day);

  return (
    <>
      <Trigger
        popover={popover}
        label={formatDateEs(value)}
        placeholder={placeholder}
        clearable={clearable}
        onClear={() => onChange("")}
        className={className}
        ariaLabel={rest["aria-label"]}
      />
      <Panel popover={popover}>
        <NavHeader
          label={`${MONTHS_ES[view.month - 1]} ${view.year}`}
          onPrev={() => setView(shiftMonth(view.year, view.month, -1))}
          onNext={() => setView(shiftMonth(view.year, view.month, 1))}
        />
        <div className="grid grid-cols-7 gap-0.5 text-center">
          {WEEKDAYS_ES.map((d) => (
            <span key={d} className="h-6 leading-6 text-[10px] text-zinc-500 font-semibold">
              {d}
            </span>
          ))}
          {monthGrid(view.year, view.month)
            .flat()
            .map((day, i) => {
              // biome-ignore lint/suspicious/noArrayIndexKey: padding cells are purely positional
              if (day === null) return <span key={`pad-${i}`} />;
              const iso = toIsoDate(view.year, view.month, day);
              return (
                <button
                  key={iso}
                  type="button"
                  onClick={() => pick(iso)}
                  className={cellClass(iso === value, iso === todayIso, !isWithin(iso, min, max))}
                >
                  {day}
                </button>
              );
            })}
        </div>
        <div className="mt-2 flex justify-between border-t border-zinc-800 pt-2">
          <button
            type="button"
            disabled={!isWithin(todayIso, min, max)}
            onClick={() => pick(todayIso)}
            className="text-cyan-400 hover:text-cyan-300 disabled:opacity-30"
          >
            Hoy
          </button>
          {clearable && (
            <button
              type="button"
              onClick={() => pick("")}
              className="text-zinc-400 hover:text-zinc-200"
            >
              Borrar
            </button>
          )}
        </div>
      </Panel>
    </>
  );
}

/** Spanish month picker; value is YYYY-MM ("" when empty). */
export function MonthPicker({
  value,
  onChange,
  min,
  max,
  placeholder = "Mes",
  clearable,
  className,
  ...rest
}: PickerBaseProps) {
  const popover = usePopover();
  const today = todayParts();
  const selectedYear = Number(value.slice(0, 4)) || today.year;
  const [year, setYear] = useState(selectedYear);

  useEffect(() => {
    if (popover.open) setYear(selectedYear);
  }, [popover.open, selectedYear]);

  const pick = (iso: string) => {
    onChange(iso);
    popover.setOpen(false);
  };
  const currentMonth = toIsoMonth(today.year, today.month);

  return (
    <>
      <Trigger
        popover={popover}
        label={formatMonthEs(value)}
        placeholder={placeholder}
        clearable={clearable}
        onClear={() => onChange("")}
        className={className}
        ariaLabel={rest["aria-label"]}
      />
      <Panel popover={popover}>
        <NavHeader
          label={String(year)}
          onPrev={() => setYear(year - 1)}
          onNext={() => setYear(year + 1)}
        />
        <div className="grid grid-cols-3 gap-1">
          {MONTHS_SHORT_ES.map((name, i) => {
            const iso = toIsoMonth(year, i + 1);
            return (
              <button
                key={iso}
                type="button"
                onClick={() => pick(iso)}
                className={cellClass(iso === value, iso === currentMonth, !isWithin(iso, min, max))}
              >
                {name}
              </button>
            );
          })}
        </div>
      </Panel>
    </>
  );
}
