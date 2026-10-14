import type { ReceiptStatus } from "@/app/gen/involt/v1/payments_pb";
import { RECEIPT_STATUS_STYLES } from "../lib/labels";

export function StatusPill({ status }: { status: ReceiptStatus }) {
  const style = RECEIPT_STATUS_STYLES[status];
  return (
    <span
      className={`inline-flex items-center px-1.5 py-0.5 rounded-md border text-[10px] font-semibold uppercase ${style.className}`}
    >
      {style.label}
    </span>
  );
}
