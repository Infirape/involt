"use client";

import { CalendarDays, ChevronLeft, ChevronRight, X } from "lucide-react";
import { type ReactNode, useEffect, useLayoutEffect, useRef, useState } from "react";
import { createPortal } from "react-dom";
import { parseIsoDate } from "@/lib/calendar";
import { cn } from "@/lib/utils";

// Shared building blocks of the Spanish date/month pickers.

const triggerClass =
  "w-full flex items-center gap-2 bg-zinc-950 border border-zinc-800 rounded-xl px-2.5 py-1.5 text-left text-zinc-200 focus:outline-none focus:border-cyan-500/50 hover:border-zinc-700 transition-colors";

export function todayParts() {
  const iso = new Intl.DateTimeFormat("en-CA", { timeZone: "America/Lima" }).format(new Date());
  return parseIsoDate(iso) ?? { year: 2026, month: 1, day: 1 };
}

/** Popover anchored to its trigger, portaled to <body> so dialogs can't clip it. */
export function usePopover() {
  const [open, setOpen] = useState(false);
  const [pos, setPos] = useState({ top: 0, left: 0 });
  const triggerRef = useRef<HTMLButtonElement>(null);
  const panelRef = useRef<HTMLDivElement>(null);

  useLayoutEffect(() => {
    if (!open || !triggerRef.current) return;
    const r = triggerRef.current.getBoundingClientRect();
    const panelHeight = 320;
    const below = r.bottom + panelHeight + 8 < window.innerHeight;
    setPos({
      top: below ? r.bottom + 6 : Math.max(8, r.top - panelHeight - 6),
      left: Math.min(r.left, window.innerWidth - 288),
    });
  }, [open]);

  useEffect(() => {
    if (!open) return;
    const close = (e: Event) => {
      const target = e.target as Node;
      if (panelRef.current?.contains(target) || triggerRef.current?.contains(target)) return;
      setOpen(false);
    };
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && setOpen(false);
    const onResize = () => setOpen(false);
    document.addEventListener("mousedown", close);
    window.addEventListener("resize", onResize);
    window.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("mousedown", close);
      window.removeEventListener("resize", onResize);
      window.removeEventListener("keydown", onKey);
    };
  }, [open]);

  return { open, setOpen, pos, triggerRef, panelRef };
}

export function Trigger(props: {
  popover: ReturnType<typeof usePopover>;
  label: string;
  placeholder: string;
  clearable?: boolean;
  onClear: () => void;
  className?: string;
  ariaLabel?: string;
}) {
  const { popover } = props;
  return (
    <div className={cn("relative", props.className)}>
      <button
        ref={popover.triggerRef}
        type="button"
        aria-label={props.ariaLabel}
        aria-haspopup="dialog"
        aria-expanded={popover.open}
        onClick={() => popover.setOpen(!popover.open)}
        className={triggerClass}
      >
        <CalendarDays className="w-3.5 h-3.5 text-zinc-500 shrink-0" />
        <span className={cn("flex-1 truncate", !props.label && "text-zinc-600")}>
          {props.label || props.placeholder}
        </span>
      </button>
      {props.clearable && props.label && (
        <button
          type="button"
          aria-label="Borrar fecha"
          onClick={props.onClear}
          className="absolute right-1.5 top-1/2 -translate-y-1/2 p-1 rounded-md text-zinc-500 hover:text-zinc-200"
        >
          <X className="w-3 h-3" />
        </button>
      )}
    </div>
  );
}

export function Panel({
  popover,
  children,
}: {
  popover: ReturnType<typeof usePopover>;
  children: ReactNode;
}) {
  if (!popover.open) return null;
  return createPortal(
    <div
      ref={popover.panelRef}
      role="dialog"
      style={{ top: popover.pos.top, left: popover.pos.left }}
      className="fixed z-[100] w-[280px] rounded-2xl border border-zinc-700 bg-zinc-900 p-3 shadow-2xl text-xs text-zinc-200"
    >
      {children}
    </div>,
    document.body,
  );
}

export function NavHeader(props: { label: string; onPrev: () => void; onNext: () => void }) {
  return (
    <div className="flex items-center justify-between mb-2">
      <button
        type="button"
        onClick={props.onPrev}
        aria-label="Anterior"
        className="p-1 rounded-lg hover:bg-zinc-800"
      >
        <ChevronLeft className="w-4 h-4" />
      </button>
      <span className="font-semibold text-white">{props.label}</span>
      <button
        type="button"
        onClick={props.onNext}
        aria-label="Siguiente"
        className="p-1 rounded-lg hover:bg-zinc-800"
      >
        <ChevronRight className="w-4 h-4" />
      </button>
    </div>
  );
}

export const cellClass = (selected: boolean, today: boolean, disabled: boolean) =>
  cn(
    "h-8 rounded-lg tabular-nums transition-colors",
    selected ? "bg-cyan-400 text-black font-bold" : "hover:bg-zinc-800",
    today && !selected && "ring-1 ring-cyan-500/50 text-cyan-300",
    disabled && "opacity-25 pointer-events-none",
  );
