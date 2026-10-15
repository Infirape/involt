import { ReceiptCopies } from "@/app/gen/involt/v1/models_pb";
import { Label } from "@/components/ui/label";

const OPTIONS = [
  {
    value: ReceiptCopies.DUPLICATE,
    label: "Duplicado",
    description: "Copia del usuario y copia administrativa",
  },
  {
    value: ReceiptCopies.SINGLE,
    label: "Individual",
    description: "Solo la copia del suministro (usuario)",
  },
];

interface ReceiptCopiesFieldProps {
  value: ReceiptCopies;
  onChange: (value: ReceiptCopies) => void;
}

/** Global setting: whether consumption receipts print one copy or two. */
export function ReceiptCopiesField({ value, onChange }: ReceiptCopiesFieldProps) {
  // Unspecified (older settings) behaves as duplicate, like the backend.
  const current = value === ReceiptCopies.SINGLE ? ReceiptCopies.SINGLE : ReceiptCopies.DUPLICATE;
  return (
    <div className="p-4 rounded-xl bg-white/5 border border-white/5 space-y-3">
      <div className="space-y-0.5">
        <Label className="text-sm font-bold uppercase tracking-tight">Recibo de consumo</Label>
        <p className="text-xs text-muted-foreground">
          Cuántas copias imprime el recibo (individual y masivo)
        </p>
      </div>
      <div className="grid grid-cols-2 gap-2">
        {OPTIONS.map((option) => (
          <button
            key={option.value}
            type="button"
            aria-pressed={current === option.value}
            onClick={() => onChange(option.value)}
            className={`text-left p-3 rounded-xl border transition-colors ${
              current === option.value
                ? "border-primary/50 bg-primary/10"
                : "border-white/10 hover:border-white/20"
            }`}
          >
            <span className="block text-sm font-bold">{option.label}</span>
            <span className="block text-xs text-muted-foreground">{option.description}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
