import { PaymentMethod, ReceiptStatus } from "@/app/gen/involt/v1/payments_pb";

export const PAYMENT_METHOD_OPTIONS: { value: PaymentMethod; label: string }[] = [
  { value: PaymentMethod.CASH, label: "Efectivo" },
  { value: PaymentMethod.YAPE, label: "Yape" },
  { value: PaymentMethod.PLIN, label: "Plin" },
  { value: PaymentMethod.TRANSFER, label: "Transferencia" },
  { value: PaymentMethod.OTHER, label: "Otro" },
];

export function paymentMethodLabel(method: PaymentMethod): string {
  return PAYMENT_METHOD_OPTIONS.find((o) => o.value === method)?.label ?? "—";
}

/** Methods that carry an operation number worth asking for. */
export function methodNeedsReference(method: PaymentMethod): boolean {
  return method !== PaymentMethod.CASH;
}

interface StatusStyle {
  label: string;
  /** Classes for the pill/button background, text and border. */
  className: string;
  /** Classes for the small legend swatch. */
  swatch: string;
}

export const RECEIPT_STATUS_STYLES: Record<ReceiptStatus, StatusStyle> = {
  [ReceiptStatus.PAID]: {
    label: "Pagado",
    className: "bg-emerald-500/15 text-emerald-400 border-emerald-500/25 hover:bg-emerald-500/25",
    swatch: "bg-emerald-500/20 border-emerald-500/30",
  },
  [ReceiptStatus.PARTIAL]: {
    label: "Parcial",
    className: "bg-amber-500/15 text-amber-300 border-amber-500/25 hover:bg-amber-500/25",
    swatch: "bg-amber-500/20 border-amber-500/30",
  },
  [ReceiptStatus.PENDING]: {
    label: "Pendiente",
    className: "bg-zinc-500/10 text-zinc-300 border-zinc-500/25 hover:bg-zinc-500/20",
    swatch: "bg-zinc-500/20 border-zinc-500/30",
  },
  [ReceiptStatus.OVERDUE]: {
    label: "Vencido",
    className: "bg-red-500/10 text-red-400 border-red-500/20 hover:bg-red-500/20",
    swatch: "bg-red-500/10 border-red-500/20",
  },
  [ReceiptStatus.UNSPECIFIED]: {
    label: "—",
    className: "bg-zinc-800 text-zinc-500 border-zinc-700",
    swatch: "bg-zinc-800 border-zinc-700",
  },
};

const MONTHS = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];

export function formatPeriod(period: string): string {
  const [year, month] = period.split("-");
  const name = MONTHS[Number.parseInt(month, 10) - 1];
  return name ? `${name} ${year}` : period;
}
