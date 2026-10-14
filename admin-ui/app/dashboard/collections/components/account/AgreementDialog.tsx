import { Loader2 } from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import { createPortal } from "react-dom";
import type { CreateAgreementResponse } from "@/app/gen/involt/v1/agreements_pb";
import { PaymentMethod } from "@/app/gen/involt/v1/payments_pb";
import { type AgreementDraft, useAgreementPlanner } from "../../hooks/useAgreementPlanner";
import {
  formatDay,
  formatPeriod,
  methodNeedsReference,
  PAYMENT_METHOD_OPTIONS,
} from "../../lib/labels";
import { formatSoles, limaToday, parseAmount } from "../../lib/money";
import { modalCancelClass, modalFieldClass, modalLabelClass } from "../Modal";

interface AgreementDialogProps {
  customerId: string;
  customerName: string;
  readingIds: string[];
  onCancel: () => void;
  onCreated: (resp: CreateAgreementResponse) => void;
}

function nextMonth(isoDay: string): string {
  const [y, m, d] = isoDay.split("-").map(Number);
  const date = new Date(Date.UTC(y, m, Math.min(d, 28)));
  return date.toISOString().slice(0, 10);
}

/** Builds a payment agreement with a live server preview of totals and schedule. */
export function AgreementDialog({
  customerId,
  customerName,
  readingIds,
  onCancel,
  onCreated,
}: AgreementDialogProps) {
  const [installments, setInstallments] = useState(3);
  const [initial, setInitial] = useState("");
  const [firstDueDate, setFirstDueDate] = useState(() => nextMonth(limaToday()));
  const [method, setMethod] = useState<PaymentMethod>(PaymentMethod.CASH);
  const [reference, setReference] = useState("");
  const [notes, setNotes] = useState("");
  const initialAmount = initial.trim() === "" ? 0 : parseAmount(initial);

  const draft = useMemo<AgreementDraft>(
    () => ({
      customerId,
      readingIds,
      installments,
      initialAmount: initialAmount ?? 0,
      firstDueDate,
      notes,
      initialPaymentMethod: method,
      initialPaymentReference: reference,
    }),
    [customerId, readingIds, installments, initialAmount, firstDueDate, notes, method, reference],
  );
  const { preview, previewing, creating, createAgreement } = useAgreementPlanner(draft);

  // Start from the minimum initial payment once the policy is known.
  useEffect(() => {
    if (preview && initial === "" && preview.minInitialAmount > 0)
      setInitial(preview.minInitialAmount.toFixed(2));
  }, [preview, initial]);

  const maxInstallments = Math.max(preview?.maxInstallments ?? 12, 1);
  const error = initialAmount === null ? "Cuota inicial inválida" : preview?.validationError;
  const canCreate = !!preview && !error && !creating && !previewing;

  const submit = async () => {
    const resp = await createAgreement();
    if (resp) onCreated(resp);
  };

  return createPortal(
    <div className="fixed inset-0 z-[90] flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div
        role="dialog"
        aria-modal="true"
        aria-label="Nuevo convenio de pago"
        className="w-full max-w-2xl max-h-[90vh] overflow-y-auto bg-zinc-900 border border-zinc-800 rounded-2xl shadow-2xl"
      >
        <div className="p-4 border-b border-zinc-800">
          <h3 className="text-sm font-semibold text-white">Nuevo convenio de pago</h3>
          <p className="text-[11px] text-zinc-400 mt-0.5">{customerName}</p>
        </div>

        <div className="p-4 grid grid-cols-1 md:grid-cols-2 gap-5">
          <div className="space-y-3">
            <div className="grid grid-cols-2 gap-3">
              <label className={modalLabelClass}>
                Cuotas
                <select
                  value={installments}
                  onChange={(e) => setInstallments(Number(e.target.value))}
                  className={`${modalFieldClass} mt-1`}
                >
                  {Array.from({ length: maxInstallments }, (_, i) => i + 1).map((n) => (
                    <option key={n} value={n}>
                      {n} {n === 1 ? "cuota" : "cuotas"}
                    </option>
                  ))}
                </select>
              </label>
              <label className={modalLabelClass}>
                Primera cuota
                <input
                  type="date"
                  value={firstDueDate}
                  onChange={(e) => setFirstDueDate(e.target.value)}
                  className={`${modalFieldClass} mt-1 [color-scheme:dark]`}
                />
              </label>
            </div>
            <label className={modalLabelClass}>
              Cuota inicial (S/)
              {preview &&
                preview.minInitialAmount > 0 &&
                ` — mínimo ${formatSoles(preview.minInitialAmount)}`}
              <input
                inputMode="decimal"
                value={initial}
                onChange={(e) => setInitial(e.target.value)}
                placeholder="0.00"
                className={`${modalFieldClass} mt-1 tabular-nums`}
              />
            </label>
            {(initialAmount ?? 0) > 0 && (
              <div className="grid grid-cols-2 gap-3">
                <label className={modalLabelClass}>
                  Medio de pago inicial
                  <select
                    value={method}
                    onChange={(e) => setMethod(Number(e.target.value) as PaymentMethod)}
                    className={`${modalFieldClass} mt-1`}
                  >
                    {PAYMENT_METHOD_OPTIONS.map((o) => (
                      <option key={o.value} value={o.value}>
                        {o.label}
                      </option>
                    ))}
                  </select>
                </label>
                {methodNeedsReference(method) && (
                  <label className={modalLabelClass}>
                    N° de operación
                    <input
                      value={reference}
                      onChange={(e) => setReference(e.target.value)}
                      className={`${modalFieldClass} mt-1`}
                    />
                  </label>
                )}
              </div>
            )}
            <label className={modalLabelClass}>
              Observaciones (opcional)
              <textarea
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                className={`${modalFieldClass} mt-1 resize-none h-16`}
              />
            </label>
          </div>

          <AgreementPreview preview={preview} previewing={previewing} />
        </div>

        <div className="p-4 border-t border-zinc-800 flex items-center gap-3">
          {error && <p className="text-[11px] text-red-400 flex-1">{error}</p>}
          <div className="flex gap-2 ml-auto">
            <button
              type="button"
              onClick={onCancel}
              disabled={creating}
              className={modalCancelClass}
            >
              Cancelar
            </button>
            <button
              type="button"
              onClick={submit}
              disabled={!canCreate}
              className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-cyan-400 hover:bg-cyan-300 text-black flex items-center gap-1.5 disabled:opacity-40"
            >
              {creating && <Loader2 className="w-3 h-3 animate-spin" />}
              Firmar convenio
              {(initialAmount ?? 0) > 0 ? ` y cobrar ${formatSoles(initialAmount ?? 0)}` : ""}
            </button>
          </div>
        </div>
      </div>
    </div>,
    document.body,
  );
}

function AgreementPreview({
  preview,
  previewing,
}: {
  preview: ReturnType<typeof useAgreementPlanner>["preview"];
  previewing: boolean;
}) {
  if (!preview) {
    return (
      <div className="flex justify-center items-center">
        <Loader2 className="w-5 h-5 text-zinc-600 animate-spin" />
      </div>
    );
  }
  return (
    <div className={`space-y-3 text-xs ${previewing ? "opacity-60" : ""}`}>
      <div className="rounded-xl border border-zinc-800 divide-y divide-zinc-800/70">
        {preview.receipts.map((r) => (
          <div key={r.readingId} className="flex justify-between px-3 py-1.5 text-zinc-300">
            <span>{formatPeriod(r.period)}</span>
            <span className="tabular-nums">
              {formatSoles(r.principal)}
              {r.lateFee > 0 && <span className="text-amber-300"> + {formatSoles(r.lateFee)}</span>}
            </span>
          </div>
        ))}
        <div className="flex justify-between px-3 py-2 font-semibold text-white">
          <span>Total del convenio</span>
          <span className="tabular-nums">{formatSoles(preview.total)}</span>
        </div>
      </div>
      {preview.lateFeesWaived && (
        <p className="text-[11px] text-zinc-500">La mora de estos recibos se condona al firmar.</p>
      )}
      {preview.installments.length > 0 && (
        <div className="rounded-xl border border-zinc-800 divide-y divide-zinc-800/70">
          {preview.installments.map((i) => (
            <div key={i.number} className="flex justify-between px-3 py-1.5 text-zinc-300">
              <span>
                Cuota {i.number} · {formatDay(i.dueDate)}
              </span>
              <span className="tabular-nums">{formatSoles(i.amount)}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
