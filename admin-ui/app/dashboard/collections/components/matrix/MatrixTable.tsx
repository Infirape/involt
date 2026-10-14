import { FileText, Plus } from "lucide-react";
import { ReceiptStatus } from "@/app/gen/involt/v1/payments_pb";
import { openReceiptPdf } from "../../lib/api";
import { formatPeriod, RECEIPT_STATUS_STYLES } from "../../lib/labels";
import { formatSoles } from "../../lib/money";
import type { CustomerRow, MatrixCell } from "../../types";

interface MatrixTableProps {
  rows: CustomerRow[];
  periods: string[];
  /** Opens the customer account, preselecting a receipt when a cell was clicked. */
  onOpenCustomer: (customerId: string, readingId?: string) => void;
  /** Cell without receipt: offer to bill the period with the fixed fee. */
  onEmptyCell: (cell: MatrixCell) => void;
}

export function MatrixTable({ rows, periods, onOpenCustomer, onEmptyCell }: MatrixTableProps) {
  return (
    <table className="w-full text-xs border-collapse">
      <thead className="sticky top-0 z-10">
        <tr className="bg-zinc-900 border-b border-zinc-800">
          <th className="text-left px-4 py-3 text-zinc-400 font-semibold w-52 min-w-[200px]">
            Suministro
          </th>
          {periods.map((period) => (
            <th
              key={period}
              className="text-center px-3 py-3 text-zinc-400 font-semibold min-w-[96px]"
            >
              {formatPeriod(period)}
            </th>
          ))}
          <th className="text-right px-4 py-3 text-zinc-400 font-semibold min-w-[100px]">
            Deuda total
          </th>
        </tr>
      </thead>
      <tbody>
        {rows.map((row, idx) => (
          <tr
            key={row.customerId}
            className={`border-b border-zinc-800/50 hover:bg-zinc-800/20 ${idx % 2 ? "bg-zinc-900/30" : ""}`}
          >
            <td className="px-4 py-2 max-w-[200px]">
              <button
                type="button"
                onClick={() => onOpenCustomer(row.customerId)}
                className="text-left w-full group"
                title="Abrir cuenta del cliente"
              >
                <div className="text-zinc-200 font-medium truncate group-hover:text-cyan-300">
                  {row.customerName}
                </div>
                <div className="text-[10px] font-mono text-zinc-600">{row.customerCode}</div>
              </button>
            </td>
            {periods.map((period) => (
              <MatrixCellView
                key={period}
                cell={row.cells[period]}
                onOpen={(c) => onOpenCustomer(c.customerId, c.readingId)}
                onEmpty={onEmptyCell}
              />
            ))}
            <td
              className={`px-4 py-2 text-right font-semibold tabular-nums ${
                row.totalDebt > 0 ? "text-red-400" : "text-zinc-600"
              }`}
            >
              {row.totalDebt > 0 ? formatSoles(row.totalDebt) : "—"}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

function MatrixCellView({
  cell,
  onOpen,
  onEmpty,
}: {
  cell: MatrixCell;
  onOpen: (cell: MatrixCell) => void;
  onEmpty: (cell: MatrixCell) => void;
}) {
  if (!cell.readingId) {
    return (
      <td className="px-2 py-2 text-center">
        <button
          type="button"
          onClick={() => onEmpty(cell)}
          title="Sin recibo · generar cargo fijo"
          className="inline-flex items-center justify-center w-7 h-6 rounded-lg text-zinc-700 hover:text-cyan-400 hover:bg-zinc-800 transition-colors"
        >
          <Plus className="w-3 h-3" />
        </button>
      </td>
    );
  }

  const style = RECEIPT_STATUS_STYLES[cell.status];
  const detail =
    cell.status === ReceiptStatus.PAID
      ? formatSoles(cell.total)
      : `debe ${formatSoles(cell.balance)}`;

  return (
    <td className="px-2 py-2 text-center">
      <div className="relative group inline-flex flex-col items-center gap-0.5">
        <button
          type="button"
          onClick={() => onOpen(cell)}
          title={`${style.label} · Total ${formatSoles(cell.total)} · Pagado ${formatSoles(cell.paid)}`}
          className={`px-2.5 py-1 rounded-lg font-semibold text-[10px] uppercase border transition-all hover:scale-105 active:scale-95 ${style.className}`}
        >
          {style.label}
        </button>
        <span className="text-[9px] text-zinc-500 tabular-nums">{detail}</span>
        <button
          type="button"
          onClick={() => openReceiptPdf(cell.readingId)}
          title="Ver recibo PDF"
          className="absolute -top-1 -right-2 w-5 h-5 flex items-center justify-center rounded-full bg-zinc-700 hover:bg-fuchsia-600 border border-zinc-600 text-zinc-300 hover:text-white opacity-0 group-hover:opacity-100 transition-all scale-75 group-hover:scale-100 shadow-lg"
        >
          <FileText className="w-2.5 h-2.5" />
        </button>
      </div>
    </td>
  );
}
