import { FileText } from "lucide-react";
import { useState } from "react";
import type { ReceiptBalance } from "@/app/gen/involt/v1/payments_pb";
import { openReceiptPdf } from "../../lib/api";
import { formatPeriod } from "../../lib/labels";
import { formatSoles } from "../../lib/money";
import { StatusPill } from "../StatusPill";

interface ReceiptListProps {
  receipts: ReceiptBalance[];
  selectedIds: Set<string>;
  onToggle: (readingId: string) => void;
  onToggleAll: (select: boolean) => void;
}

export function ReceiptList({ receipts, selectedIds, onToggle, onToggleAll }: ReceiptListProps) {
  const [showSettled, setShowSettled] = useState(false);
  const outstanding = receipts.filter((r) => r.balance > 0);
  const visible = showSettled ? receipts : outstanding;
  const allSelected = outstanding.length > 0 && outstanding.every((r) => selectedIds.has(rid(r)));

  return (
    <section className="space-y-2">
      <div className="flex items-center justify-between">
        <h4 className="text-[11px] font-semibold text-zinc-400 uppercase tracking-wider">
          Recibos {showSettled ? "" : "pendientes"} ({visible.length})
        </h4>
        <div className="flex items-center gap-3 text-[11px]">
          {outstanding.length > 0 && (
            <button
              type="button"
              onClick={() => onToggleAll(!allSelected)}
              className="text-cyan-400 hover:text-cyan-300"
            >
              {allSelected ? "Quitar todos" : "Seleccionar todos"}
            </button>
          )}
          <button
            type="button"
            onClick={() => setShowSettled((v) => !v)}
            className="text-zinc-500 hover:text-zinc-300"
          >
            {showSettled ? "Ocultar pagados" : "Ver pagados"}
          </button>
        </div>
      </div>

      {visible.length === 0 ? (
        <p className="text-xs text-zinc-500 py-4 text-center border border-dashed border-zinc-800 rounded-xl">
          Sin deuda pendiente 🎉
        </p>
      ) : (
        <ul className="divide-y divide-zinc-800/70 border border-zinc-800 rounded-xl overflow-hidden">
          {visible.map((receipt) => (
            <ReceiptRow
              key={rid(receipt)}
              receipt={receipt}
              selected={selectedIds.has(rid(receipt))}
              onToggle={onToggle}
            />
          ))}
        </ul>
      )}
    </section>
  );
}

const rid = (r: ReceiptBalance) => r.reading?.id ?? "";

function ReceiptRow({
  receipt,
  selected,
  onToggle,
}: {
  receipt: ReceiptBalance;
  selected: boolean;
  onToggle: (readingId: string) => void;
}) {
  const reading = receipt.reading;
  if (!reading) return null;
  const payable = receipt.balance > 0;

  return (
    <li
      className={`flex items-center gap-3 px-3 py-2 text-xs ${selected ? "bg-cyan-500/5" : "bg-zinc-950/40"}`}
    >
      <input
        type="checkbox"
        aria-label={`Seleccionar ${formatPeriod(reading.period)}`}
        checked={selected}
        disabled={!payable}
        onChange={() => onToggle(reading.id)}
        className="accent-cyan-400 w-3.5 h-3.5 disabled:opacity-30"
      />
      <div className="w-20 font-medium text-zinc-200">{formatPeriod(reading.period)}</div>
      <StatusPill status={receipt.status} />
      <div className="ml-auto text-right tabular-nums">
        <div className="text-zinc-200 font-semibold">{formatSoles(receipt.balance)}</div>
        <div className="text-[10px] text-zinc-500">
          de {formatSoles(reading.totalToPay)}
          {receipt.paidAmount > 0 && ` · pagó ${formatSoles(receipt.paidAmount)}`}
        </div>
      </div>
      <button
        type="button"
        onClick={() => openReceiptPdf(reading.id)}
        title="Ver recibo PDF"
        className="p-1.5 rounded-lg text-zinc-500 hover:text-fuchsia-400 hover:bg-zinc-800"
      >
        <FileText className="w-3.5 h-3.5" />
      </button>
    </li>
  );
}
