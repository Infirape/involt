"use client";

import { Loader2, X } from "lucide-react";
import { type FormEvent, useEffect, useState } from "react";
import { createPortal } from "react-dom";
import type { Customer, ServiceStatus } from "@/app/gen/involt/v1/models_pb";
import { useServiceStatus } from "@/lib/hooks/useServiceStatus";
import { SERVICE_STATUS_OPTIONS, serviceStatusOption } from "@/lib/serviceStatus";
import { cn } from "@/lib/utils";
import { ServiceStatusBadge } from "./ServiceStatusBadge";

interface ServiceStatusDialogProps {
  customerId: string;
  customerName: string;
  customerCode: string;
  currentStatus: ServiceStatus;
  /** Preselected target status (e.g. "Registrar corte" from the debtors list). */
  initialStatus?: ServiceStatus;
  onClose: () => void;
  onChanged: (customer: Customer) => void;
}

const formatDateTime = (iso: string) =>
  new Intl.DateTimeFormat("es-PE", {
    timeZone: "America/Lima",
    dateStyle: "short",
    timeStyle: "short",
  }).format(new Date(iso));

/** Change a supply's service status with a mandatory reason; shows the change history. */
export function ServiceStatusDialog(props: ServiceStatusDialogProps) {
  const current = serviceStatusOption(props.currentStatus).value;
  const firstOther = SERVICE_STATUS_OPTIONS.find((o) => o.value !== current)?.value ?? current;
  const [status, setStatus] = useState<ServiceStatus>(
    props.initialStatus && props.initialStatus !== current ? props.initialStatus : firstOther,
  );
  const [reason, setReason] = useState("");
  const { history, loading, saving, changeStatus } = useServiceStatus(props.customerId);
  const { onClose } = props;

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && onClose();
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    if (!reason.trim() || status === current) return;
    const customer = await changeStatus(status, reason.trim());
    if (customer) props.onChanged(customer);
  };

  return createPortal(
    <div className="fixed inset-0 z-[90] flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div
        role="dialog"
        aria-modal="true"
        aria-label="Estado del suministro"
        className="w-full max-w-lg max-h-[90vh] overflow-y-auto bg-zinc-900 border border-zinc-800 rounded-2xl shadow-2xl"
      >
        <div className="p-4 border-b border-zinc-800 flex items-start justify-between gap-3">
          <div>
            <h3 className="text-sm font-semibold text-white">Estado del suministro</h3>
            <p className="text-[11px] text-zinc-400 mt-0.5">
              {props.customerCode} · {props.customerName}
            </p>
          </div>
          <div className="flex items-center gap-2">
            <ServiceStatusBadge status={props.currentStatus} />
            <button
              type="button"
              onClick={onClose}
              aria-label="Cerrar"
              className="p-1 rounded-lg text-zinc-400 hover:text-white hover:bg-zinc-800"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>

        <form onSubmit={submit} className="p-4 space-y-4">
          <fieldset className="space-y-2">
            <legend className="text-[11px] font-semibold text-zinc-400 uppercase tracking-wider mb-1">
              Nuevo estado
            </legend>
            {SERVICE_STATUS_OPTIONS.map((o) => (
              <label
                key={o.value}
                className={cn(
                  "flex items-start gap-3 p-2.5 rounded-xl border cursor-pointer text-xs transition-colors",
                  status === o.value
                    ? "border-cyan-500/50 bg-cyan-500/5"
                    : "border-zinc-800 hover:border-zinc-700",
                  o.value === current && "opacity-40 cursor-not-allowed",
                )}
              >
                <input
                  type="radio"
                  name="service-status"
                  className="mt-0.5 accent-cyan-400"
                  checked={status === o.value}
                  disabled={o.value === current}
                  onChange={() => setStatus(o.value)}
                />
                <span>
                  <span className="font-semibold text-zinc-100">{o.label}</span>
                  {o.value === current && <span className="text-zinc-500"> (actual)</span>}
                  <span className="block text-zinc-500">{o.description}</span>
                </span>
              </label>
            ))}
          </fieldset>
          <label className="block text-[11px] font-semibold text-zinc-400 uppercase tracking-wider">
            Motivo (obligatorio)
            <textarea
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              required
              placeholder="Ej. Deuda de 3 meses, medidor averiado, reconexión por pago…"
              className="mt-1 w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3 py-2 text-sm text-white normal-case tracking-normal font-normal resize-none h-20 focus:outline-none focus:border-cyan-500/50"
            />
          </label>
          <div className="flex justify-end gap-2">
            <button
              type="button"
              onClick={onClose}
              disabled={saving}
              className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-zinc-800 text-zinc-300 hover:bg-zinc-700"
            >
              Cancelar
            </button>
            <button
              type="submit"
              disabled={saving || !reason.trim() || status === current}
              className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-cyan-400 hover:bg-cyan-300 text-black flex items-center gap-1.5 disabled:opacity-40"
            >
              {saving && <Loader2 className="w-3 h-3 animate-spin" />}
              Guardar estado
            </button>
          </div>
        </form>

        <section className="px-4 pb-4 space-y-2">
          <h4 className="text-[11px] font-semibold text-zinc-400 uppercase tracking-wider">
            Historial
          </h4>
          {loading ? (
            <Loader2 className="w-4 h-4 text-zinc-600 animate-spin" />
          ) : history.length === 0 ? (
            <p className="text-xs text-zinc-500">Sin cambios registrados.</p>
          ) : (
            <ul className="space-y-1.5">
              {history.map((h) => (
                <li
                  key={h.changedAt + h.status}
                  className="p-2 rounded-lg border border-zinc-800 text-xs"
                >
                  <div className="flex items-center gap-1.5">
                    <ServiceStatusBadge status={h.previousStatus} />
                    <span className="text-zinc-500">→</span>
                    <ServiceStatusBadge status={h.status} />
                    <span className="ml-auto text-[10px] text-zinc-500">
                      {formatDateTime(h.changedAt)}
                    </span>
                  </div>
                  <p className="mt-1 text-zinc-300">{h.reason}</p>
                  <p className="text-[10px] text-zinc-600">{h.changedByEmail}</p>
                </li>
              ))}
            </ul>
          )}
        </section>
      </div>
    </div>,
    document.body,
  );
}
