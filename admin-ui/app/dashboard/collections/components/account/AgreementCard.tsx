import { AlertTriangle, Ban, CheckCircle2, Printer, Wallet } from "lucide-react";
import { useState } from "react";
import { AgreementStatus, type PaymentAgreement } from "@/app/gen/involt/v1/agreements_pb";
import { openBackendPdf } from "../../lib/api";
import { AGREEMENT_STATUS_STYLES, formatDay } from "../../lib/labels";
import { collectionRate, formatSoles } from "../../lib/money";

interface AgreementCardProps {
  agreement: PaymentAgreement;
  canCancel: boolean;
  onCollect: (agreement: PaymentAgreement) => void;
  onCancel: (agreement: PaymentAgreement) => void;
}

const isOpen = (a: PaymentAgreement) =>
  a.status === AgreementStatus.ACTIVE || a.status === AgreementStatus.IN_DEFAULT;

export function AgreementCard({
  agreement: a,
  canCancel,
  onCollect,
  onCancel,
}: AgreementCardProps) {
  const [showSchedule, setShowSchedule] = useState(false);
  const style = AGREEMENT_STATUS_STYLES[a.status];
  const progress = Math.min(collectionRate(a.total, a.paid), 100);
  const open = isOpen(a);

  return (
    <div
      className={`p-3 rounded-xl border text-xs ${open ? "border-cyan-500/25 bg-cyan-500/5" : "border-zinc-800 bg-zinc-950/40"}`}
    >
      <div className="flex items-center gap-2">
        <span className="font-semibold text-white">
          Convenio N° {String(a.number).padStart(6, "0")}
        </span>
        <span
          className={`px-1.5 py-0.5 rounded-md border text-[10px] font-semibold uppercase ${style.className}`}
        >
          {style.label}
        </span>
        <span className="ml-auto text-zinc-400 tabular-nums">
          {formatSoles(a.paid)} / {formatSoles(a.total)}
        </span>
      </div>
      <div className="mt-2 h-1.5 rounded-full bg-zinc-800 overflow-hidden">
        <div className="h-full bg-cyan-400" style={{ width: `${progress}%` }} />
      </div>

      {a.status === AgreementStatus.IN_DEFAULT && (
        <p className="mt-2 flex items-center gap-1.5 text-red-400">
          <AlertTriangle className="w-3.5 h-3.5" /> Cuotas atrasadas por{" "}
          {formatSoles(a.overdueAmount)}: los recibos vuelven a contar como vencidos.
        </p>
      )}
      {open && a.nextInstallment > 0 && (
        <p className="mt-2 text-zinc-300">
          Próxima: cuota {a.nextInstallment} de {a.installments.length} ·{" "}
          <span className="tabular-nums font-semibold">{formatSoles(a.nextAmount)}</span> · vence{" "}
          {formatDay(a.nextDueDate)}
        </p>
      )}
      {a.status === AgreementStatus.CANCELLED && a.cancelReason && (
        <p className="mt-2 text-zinc-500">Motivo de anulación: {a.cancelReason}</p>
      )}
      {a.lateFeesWaived && (
        <p className="mt-1 text-[10px] text-zinc-500">Mora condonada al firmar</p>
      )}

      {showSchedule && (
        <ul className="mt-2 divide-y divide-zinc-800/70 border border-zinc-800 rounded-lg">
          {a.initialAmount > 0 && (
            <li className="flex justify-between px-2 py-1 text-zinc-400">
              <span>Inicial (a la firma)</span>
              <span className="tabular-nums">{formatSoles(a.initialAmount)}</span>
            </li>
          )}
          {a.installments.map((i) => (
            <li key={i.number} className="flex items-center gap-2 px-2 py-1 text-zinc-300">
              <span className="w-12">Cuota {i.number}</span>
              <span className="text-zinc-500">{formatDay(i.dueDate)}</span>
              {i.paid && <CheckCircle2 className="w-3 h-3 text-emerald-400" />}
              <span className="ml-auto tabular-nums">{formatSoles(i.amount)}</span>
            </li>
          ))}
        </ul>
      )}

      <div className="mt-2 flex flex-wrap items-center gap-2">
        {open && (
          <button
            type="button"
            onClick={() => onCollect(a)}
            className="px-2.5 py-1 rounded-lg bg-cyan-400 text-black font-semibold flex items-center gap-1 hover:bg-cyan-300"
          >
            <Wallet className="w-3 h-3" /> Cobrar cuota
          </button>
        )}
        <button
          type="button"
          onClick={() => setShowSchedule((v) => !v)}
          className="px-2 py-1 rounded-lg text-zinc-300 hover:bg-zinc-800"
        >
          {showSchedule ? "Ocultar cronograma" : "Ver cronograma"}
        </button>
        <button
          type="button"
          onClick={() => openBackendPdf(`/admin/agreements/pdf/${a.id}`)}
          className="px-2 py-1 rounded-lg text-zinc-300 hover:bg-zinc-800 flex items-center gap-1"
        >
          <Printer className="w-3 h-3" /> Imprimir
        </button>
        {open && canCancel && (
          <button
            type="button"
            onClick={() => onCancel(a)}
            className="ml-auto px-2 py-1 rounded-lg text-zinc-500 hover:text-red-400 hover:bg-zinc-800 flex items-center gap-1"
          >
            <Ban className="w-3 h-3" /> Anular
          </button>
        )}
      </div>
    </div>
  );
}

export { isOpen as isAgreementOpen };
