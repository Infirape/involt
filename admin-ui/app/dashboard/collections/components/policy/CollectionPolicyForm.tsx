import { create } from "@bufbuild/protobuf";
import { Loader2, Save } from "lucide-react";
import { type FormEvent, useEffect, useState } from "react";
import { CollectionPolicySchema, LateFeeMode } from "@/app/gen/involt/v1/agreements_pb";
import { DatePicker } from "@/components/ui/date-picker";
import { useCollectionPolicy } from "../../hooks/useCollectionPolicy";
import { formatLimaDateTime } from "../../lib/money";

const field =
  "w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3 py-2 text-sm text-white focus:outline-none focus:border-cyan-500/50 [color-scheme:dark]";
const label = "text-[11px] font-semibold text-zinc-400 uppercase tracking-wider block mb-1";

const MODES: { value: LateFeeMode; label: string; help: string; unit: string }[] = [
  {
    value: LateFeeMode.NONE,
    label: "Sin mora",
    help: "No se cobra mora por recibos vencidos.",
    unit: "",
  },
  {
    value: LateFeeMode.FIXED,
    label: "Monto fijo por recibo",
    help: "Se cobra una vez por cada recibo vencido.",
    unit: "S/",
  },
  {
    value: LateFeeMode.PERCENT,
    label: "% del saldo (una vez)",
    help: "Porcentaje del saldo del recibo, una sola vez al vencer.",
    unit: "%",
  },
  {
    value: LateFeeMode.MONTHLY_INTEREST,
    label: "Interés mensual",
    help: "Porcentaje del saldo por cada mes (o fracción) de atraso.",
    unit: "% / mes",
  },
];

interface FormState {
  mode: LateFeeMode;
  value: string;
  startDate: string;
  maxInstallments: string;
  minInitial: string;
  grace: string;
  waive: boolean;
}

/** Políticas de cobranza: mora y convenios (admin only). */
export function CollectionPolicyForm() {
  const { policy, saving, save } = useCollectionPolicy();
  const [form, setForm] = useState<FormState | null>(null);

  useEffect(() => {
    if (!policy) return;
    setForm({
      mode: policy.lateFeeMode === LateFeeMode.UNSPECIFIED ? LateFeeMode.NONE : policy.lateFeeMode,
      value: String(policy.lateFeeValue || ""),
      startDate: policy.lateFeeStartDate,
      maxInstallments: String(policy.agreementMaxInstallments),
      minInitial: String(policy.agreementMinInitialPercent),
      grace: String(policy.agreementGraceDays),
      waive: policy.agreementWaiveLateFees,
    });
  }, [policy]);

  if (!form) {
    return (
      <div className="flex justify-center py-16">
        <Loader2 className="w-6 h-6 text-zinc-600 animate-spin" />
      </div>
    );
  }
  const set = (patch: Partial<FormState>) => setForm({ ...form, ...patch });
  const mode = MODES.find((m) => m.value === form.mode) ?? MODES[0];

  const submit = (e: FormEvent) => {
    e.preventDefault();
    void save(
      create(CollectionPolicySchema, {
        lateFeeMode: form.mode,
        lateFeeValue: form.mode === LateFeeMode.NONE ? 0 : Number(form.value) || 0,
        lateFeeStartDate: form.startDate,
        agreementMaxInstallments: Number(form.maxInstallments) || 0,
        agreementMinInitialPercent: Number(form.minInitial) || 0,
        agreementGraceDays: Number(form.grace) || 0,
        agreementWaiveLateFees: form.waive,
      }),
    );
  };

  return (
    <form onSubmit={submit} className="grid grid-cols-1 xl:grid-cols-2 gap-4 max-w-5xl">
      <section className="p-5 rounded-2xl border border-zinc-800 bg-zinc-900/60 space-y-4">
        <h3 className="text-sm font-semibold text-white">Mora por recibos vencidos</h3>
        <div>
          <span className={label}>Tipo de mora</span>
          <div className="grid grid-cols-2 gap-2">
            {MODES.map((m) => (
              <button
                key={m.value}
                type="button"
                onClick={() => set({ mode: m.value })}
                className={`text-left px-3 py-2 rounded-xl border text-xs ${form.mode === m.value ? "border-cyan-500/50 bg-cyan-500/10 text-white" : "border-zinc-800 text-zinc-400 hover:border-zinc-700"}`}
              >
                {m.label}
              </button>
            ))}
          </div>
          <p className="text-[11px] text-zinc-500 mt-2">{mode.help}</p>
        </div>
        {form.mode !== LateFeeMode.NONE && (
          <div className="grid grid-cols-2 gap-3">
            <label className={label}>
              Valor ({mode.unit})
              <input
                inputMode="decimal"
                value={form.value}
                onChange={(e) => set({ value: e.target.value })}
                className={`${field} mt-1`}
              />
            </label>
            <div className={label}>
              Aplicar desde
              <DatePicker
                aria-label="Aplicar desde"
                value={form.startDate}
                onChange={(v) => set({ startDate: v })}
                clearable
                placeholder="Sin límite"
                className="mt-1 text-sm normal-case tracking-normal font-normal"
              />
            </div>
          </div>
        )}
        {form.mode !== LateFeeMode.NONE && (
          <p className="text-[11px] text-zinc-500">
            Los días de atraso anteriores a “Aplicar desde” no generan mora, así la deuda antigua no
            se recarga de golpe. Cada pago cubre primero la mora y luego el recibo.
          </p>
        )}
      </section>

      <section className="p-5 rounded-2xl border border-zinc-800 bg-zinc-900/60 space-y-4">
        <h3 className="text-sm font-semibold text-white">Convenios de pago</h3>
        <div className="grid grid-cols-3 gap-3">
          <label className={label}>
            Máx. cuotas
            <input
              inputMode="numeric"
              value={form.maxInstallments}
              onChange={(e) => set({ maxInstallments: e.target.value })}
              className={`${field} mt-1`}
            />
          </label>
          <label className={label}>
            Inicial mín. (%)
            <input
              inputMode="decimal"
              value={form.minInitial}
              onChange={(e) => set({ minInitial: e.target.value })}
              className={`${field} mt-1`}
            />
          </label>
          <label className={label}>
            Días de gracia
            <input
              inputMode="numeric"
              value={form.grace}
              onChange={(e) => set({ grace: e.target.value })}
              className={`${field} mt-1`}
            />
          </label>
        </div>
        <p className="text-[11px] text-zinc-500">
          Con 0 cuotas los convenios quedan deshabilitados. Si una cuota se atrasa más que los días
          de gracia, el convenio pasa a “en mora” y sus recibos vuelven a contar como vencidos.
        </p>
        <label className="flex items-center gap-2 text-sm text-zinc-300 cursor-pointer select-none">
          <input
            type="checkbox"
            checked={form.waive}
            onChange={(e) => set({ waive: e.target.checked })}
            className="accent-cyan-400"
          />
          Condonar la mora de los recibos al firmar el convenio
        </label>
      </section>

      <div className="xl:col-span-2 flex items-center gap-3">
        <button
          type="submit"
          disabled={saving}
          className="px-4 py-2 rounded-xl text-sm font-semibold bg-cyan-400 hover:bg-cyan-300 text-black flex items-center gap-2 disabled:opacity-50"
        >
          {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
          Guardar políticas
        </button>
        {policy?.updatedBy && (
          <span className="text-[11px] text-zinc-500">
            Última modificación: {policy.updatedBy} · {formatLimaDateTime(policy.updatedAt)}
          </span>
        )}
      </div>
    </form>
  );
}
