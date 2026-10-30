import { ServiceStatus } from "@/app/gen/involt/v1/models_pb";

export interface ServiceStatusOption {
  value: ServiceStatus;
  label: string;
  description: string;
  className: string;
}

/** Service statuses a supply can be in; only admins change them. */
export const SERVICE_STATUS_OPTIONS: ServiceStatusOption[] = [
  {
    value: ServiceStatus.ACTIVE,
    label: "Con servicio",
    description: "El suministro tiene energía.",
    className: "text-emerald-400 bg-emerald-500/10 border-emerald-500/25",
  },
  {
    value: ServiceStatus.TEMPORARY_CUT,
    label: "Corte temporal",
    description: "Cortado temporalmente (p. ej. por deuda); se puede reconectar.",
    className: "text-amber-300 bg-amber-500/10 border-amber-500/25",
  },
  {
    value: ServiceStatus.NO_POWER,
    label: "Sin energía",
    description: "Sin suministro por avería, retiro u otra causa.",
    className: "text-red-400 bg-red-500/10 border-red-500/25",
  },
];

/** Unspecified (older data) is treated as "Con servicio". */
export function serviceStatusOption(status: ServiceStatus): ServiceStatusOption {
  return SERVICE_STATUS_OPTIONS.find((o) => o.value === status) ?? SERVICE_STATUS_OPTIONS[0];
}
