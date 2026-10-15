import { Code, ConnectError } from "@connectrpc/connect";
import { API_BASE_URL, getAdminToken } from "@/lib/utils";

/** Opens a token-authenticated backend PDF (receipt or voucher) in a new tab. */
export function openBackendPdf(path: string): void {
  const token = getAdminToken() ?? "";
  window.open(`${API_BASE_URL}${path}?token=${encodeURIComponent(token)}`, "_blank");
}

/** Downloads a token-authenticated Excel report; empty params are omitted. */
export function downloadReport(
  path: string,
  params: Record<string, string | number | boolean>,
): void {
  const query = new URLSearchParams({ token: getAdminToken() ?? "" });
  for (const [key, value] of Object.entries(params)) {
    if (value !== "" && value !== 0 && value !== false) query.set(key, String(value));
  }
  window.location.href = `${API_BASE_URL}${path}?${query.toString()}`;
}

export const openReceiptPdf = (readingId: string) =>
  openBackendPdf(`/admin/readings/pdf/${readingId}`);

export const openPaymentVoucher = (paymentId: string) =>
  openBackendPdf(`/admin/payments/pdf/${paymentId}`);

/** Maps RPC errors to Spanish messages, with per-code overrides. */
export function rpcErrorMessage(
  err: unknown,
  fallback: string,
  overrides: Partial<Record<Code, string>> = {},
): string {
  if (err instanceof ConnectError) {
    const override = overrides[err.code];
    if (override) return override;
    if (err.code === Code.PermissionDenied) return "No tenés permiso para esta operación";
  }
  return fallback;
}
