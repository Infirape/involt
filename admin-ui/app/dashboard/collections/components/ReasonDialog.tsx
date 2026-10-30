import { Loader2 } from "lucide-react";
import { type FormEvent, type ReactNode, useState } from "react";
import { Modal, modalCancelClass, modalFieldClass, modalLabelClass } from "./Modal";

interface ReasonDialogProps {
  title: string;
  subtitle?: string;
  description: ReactNode;
  confirmLabel: string;
  placeholder?: string;
  danger?: boolean;
  submitting: boolean;
  onCancel: () => void;
  onConfirm: (reason: string) => void;
}

/** Confirmation dialog that requires a written reason (audit trail). */
export function ReasonDialog({
  title,
  subtitle,
  description,
  confirmLabel,
  placeholder,
  danger = false,
  submitting,
  onCancel,
  onConfirm,
}: ReasonDialogProps) {
  const [reason, setReason] = useState("");
  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (reason.trim()) onConfirm(reason.trim());
  };

  return (
    <Modal title={title} subtitle={subtitle} onClose={onCancel}>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="text-xs text-zinc-400">{description}</div>
        <div>
          <label htmlFor="reason-text" className={modalLabelClass}>
            Motivo (obligatorio)
          </label>
          <textarea
            id="reason-text"
            value={reason}
            onChange={(e) => setReason(e.target.value)}
            className={`${modalFieldClass} resize-none h-20`}
            placeholder={placeholder}
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
            className={`px-3 py-1.5 rounded-xl text-xs font-semibold flex items-center gap-1.5 disabled:opacity-50 transition-colors ${
              danger
                ? "bg-red-500 hover:bg-red-400 text-white"
                : "bg-cyan-400 hover:bg-cyan-300 text-black"
            }`}
          >
            {submitting && <Loader2 className="w-3 h-3 animate-spin" />}
            {confirmLabel}
          </button>
        </div>
      </form>
    </Modal>
  );
}
