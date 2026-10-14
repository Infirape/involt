import { Loader2, Wallet } from "lucide-react";
import { type FormEvent, useEffect, useState } from "react";
import { PaymentMethod } from "@/app/gen/involt/v1/payments_pb";
import type { PaymentInput } from "../../hooks/useCustomerAccount";
import { methodNeedsReference, PAYMENT_METHOD_OPTIONS } from "../../lib/labels";
import { formatSoles, parseAmount } from "../../lib/money";

interface PaymentFormProps {
  /** Sum of the selected receipts' balances; the default and maximum amount. */
  selectedBalance: number;
  selectedIds: string[];
  submitting: boolean;
  onSubmit: (input: PaymentInput) => Promise<boolean>;
}

const fieldClass =
  "w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3 py-2 text-sm text-white focus:outline-none focus:border-cyan-500/50 transition-colors";
const labelClass = "text-[11px] font-semibold text-zinc-400 uppercase tracking-wider block mb-1";

export function PaymentForm({
  selectedBalance,
  selectedIds,
  submitting,
  onSubmit,
}: PaymentFormProps) {
  const [amount, setAmount] = useState(selectedBalance.toFixed(2));
  const [method, setMethod] = useState<PaymentMethod>(PaymentMethod.CASH);
  const [reference, setReference] = useState("");
  const [observation, setObservation] = useState("");

  // Changing the selection resets the amount to "pay everything selected".
  useEffect(() => setAmount(selectedBalance.toFixed(2)), [selectedBalance]);

  const parsed = parseAmount(amount);
  const exceeds = parsed !== null && parsed > selectedBalance;
  const isPartial = parsed !== null && parsed > 0 && parsed < selectedBalance;
  const canSubmit =
    !submitting && selectedIds.length > 0 && parsed !== null && parsed > 0 && !exceeds;

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!canSubmit || parsed === null) return;
    const ok = await onSubmit({
      readingIds: selectedIds,
      amount: parsed,
      method,
      reference,
      observation,
    });
    if (ok) {
      setReference("");
      setObservation("");
    }
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="space-y-3 p-3 rounded-xl border border-zinc-800 bg-zinc-950/40"
    >
      <div className="grid grid-cols-2 gap-3">
        <div>
          <label htmlFor="pay-amount" className={labelClass}>
            Monto recibido (S/)
          </label>
          <input
            id="pay-amount"
            inputMode="decimal"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            className={`${fieldClass} tabular-nums text-base font-semibold`}
          />
        </div>
        <div>
          <label htmlFor="pay-method" className={labelClass}>
            Medio de pago
          </label>
          <select
            id="pay-method"
            value={method}
            onChange={(e) => setMethod(Number(e.target.value) as PaymentMethod)}
            className={fieldClass}
          >
            {PAYMENT_METHOD_OPTIONS.map((o) => (
              <option key={o.value} value={o.value}>
                {o.label}
              </option>
            ))}
          </select>
        </div>
      </div>

      {methodNeedsReference(method) && (
        <div>
          <label htmlFor="pay-reference" className={labelClass}>
            N° de operación
          </label>
          <input
            id="pay-reference"
            value={reference}
            onChange={(e) => setReference(e.target.value)}
            className={fieldClass}
            placeholder="Ej. 01234567"
          />
        </div>
      )}

      <div>
        <label htmlFor="pay-observation" className={labelClass}>
          Observación (opcional)
        </label>
        <input
          id="pay-observation"
          value={observation}
          onChange={(e) => setObservation(e.target.value)}
          className={fieldClass}
        />
      </div>

      <FormHint
        noneSelected={selectedIds.length === 0}
        invalid={parsed === null}
        exceeds={exceeds}
        isPartial={isPartial}
        selectedBalance={selectedBalance}
      />

      <button
        type="submit"
        disabled={!canSubmit}
        className="w-full py-2.5 rounded-xl text-sm font-bold bg-cyan-400 hover:bg-cyan-300 text-black flex items-center justify-center gap-2 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
      >
        {submitting ? <Loader2 className="w-4 h-4 animate-spin" /> : <Wallet className="w-4 h-4" />}
        Cobrar {parsed !== null && parsed > 0 ? formatSoles(parsed) : ""}
      </button>
    </form>
  );
}

function FormHint({
  noneSelected,
  invalid,
  exceeds,
  isPartial,
  selectedBalance,
}: {
  noneSelected: boolean;
  invalid: boolean;
  exceeds: boolean;
  isPartial: boolean;
  selectedBalance: number;
}) {
  let text = "";
  let tone = "text-zinc-500";
  if (noneSelected) text = "Seleccioná al menos un recibo pendiente.";
  else if (invalid) [text, tone] = ["Ingresá un monto válido (máx. 2 decimales).", "text-red-400"];
  else if (exceeds)
    [text, tone] = [
      `El monto supera la deuda seleccionada (${formatSoles(selectedBalance)}).`,
      "text-red-400",
    ];
  else if (isPartial)
    [text, tone] = ["Pago parcial: se aplica primero al recibo más antiguo.", "text-amber-300"];
  if (!text) return null;
  return <p className={`text-[11px] ${tone}`}>{text}</p>;
}
