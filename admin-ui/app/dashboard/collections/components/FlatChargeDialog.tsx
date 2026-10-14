import { Loader2 } from "lucide-react";
import { type FormEvent, useState } from "react";
import { formatPeriod } from "../lib/labels";
import { parseAmount } from "../lib/money";
import { Modal, modalCancelClass, modalFieldClass, modalLabelClass } from "./Modal";

interface FlatChargeDialogProps {
  customerName: string;
  period: string;
  submitting: boolean;
  onCancel: () => void;
  onConfirm: (amount: number, observation: string) => void;
}

/** Bills a month that has no meter reading. Empty amount = fixed fee from settings. */
export function FlatChargeDialog({
  customerName,
  period,
  submitting,
  onCancel,
  onConfirm,
}: FlatChargeDialogProps) {
  const [amount, setAmount] = useState("");
  const [observation, setObservation] = useState("");
  const parsed = amount.trim() === "" ? 0 : parseAmount(amount);

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (parsed !== null) onConfirm(parsed, observation);
  };

  return (
    <Modal
      title="Generar cargo sin lectura"
      subtitle={`${customerName} · ${formatPeriod(period)}`}
      onClose={onCancel}
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        <p className="text-xs text-zinc-400">
          Este mes no tiene lectura registrada. Se generará un recibo con el cargo fijo para poder
          cobrarlo; luego podrás registrar el pago.
        </p>
        <div>
          <label htmlFor="flat-amount" className={modalLabelClass}>
            Monto (S/) — vacío usa el cargo fijo configurado
          </label>
          <input
            id="flat-amount"
            inputMode="decimal"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            className={modalFieldClass}
            placeholder="Cargo fijo + alumbrado + mantenimiento"
          />
          {parsed === null && <p className="text-[11px] text-red-400 mt-1">Monto inválido</p>}
        </div>
        <div>
          <label htmlFor="flat-observation" className={modalLabelClass}>
            Observación (opcional)
          </label>
          <input
            id="flat-observation"
            value={observation}
            onChange={(e) => setObservation(e.target.value)}
            className={modalFieldClass}
            placeholder="Ej. Medidor inaccesible"
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
            disabled={submitting || parsed === null}
            className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-cyan-400 hover:bg-cyan-300 text-black flex items-center gap-1.5 disabled:opacity-50 transition-colors"
          >
            {submitting && <Loader2 className="w-3 h-3 animate-spin" />}
            Generar cargo
          </button>
        </div>
      </form>
    </Modal>
  );
}
