import { Loader2 } from "lucide-react";
import { type FormEvent, useState } from "react";
import type { Payment } from "@/app/gen/involt/v1/payments_pb";
import { formatSoles } from "../../lib/money";
import { Modal, modalCancelClass, modalFieldClass, modalLabelClass } from "../Modal";

interface VoidPaymentDialogProps {
  payment: Payment;
  submitting: boolean;
  onCancel: () => void;
  onConfirm: (reason: string) => void;
}

export function VoidPaymentDialog({
  payment,
  submitting,
  onCancel,
  onConfirm,
}: VoidPaymentDialogProps) {
  const [reason, setReason] = useState("");

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (reason.trim()) onConfirm(reason.trim());
  };

  return (
    <Modal
      title={`Anular comprobante N° ${String(payment.receiptNumber).padStart(6, "0")}`}
      subtitle={`${payment.customerName} · ${formatSoles(payment.amount)}`}
      onClose={onCancel}
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        <p className="text-xs text-zinc-400">
          El pago quedará registrado como <strong className="text-red-400">ANULADO</strong> y la
          deuda de los recibos volverá a estar pendiente. Esta acción no se puede deshacer.
        </p>
        <div>
          <label htmlFor="void-reason" className={modalLabelClass}>
            Motivo (obligatorio)
          </label>
          <textarea
            id="void-reason"
            value={reason}
            onChange={(e) => setReason(e.target.value)}
            className={`${modalFieldClass} resize-none h-20`}
            placeholder="Ej. Cobro duplicado, monto equivocado…"
            required
          />
        </div>
        <div className="flex justify-end gap-2">
          <button
            type="button"
            onClick={onCancel}
            disabled={submitting}
            className={modalCancelClass}
          >
            Cancelar
          </button>
          <button
            type="submit"
            disabled={submitting || !reason.trim()}
            className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-red-500 hover:bg-red-400 text-white flex items-center gap-1.5 disabled:opacity-50 transition-colors"
          >
            {submitting && <Loader2 className="w-3 h-3 animate-spin" />}
            Anular pago
          </button>
        </div>
      </form>
    </Modal>
  );
}
