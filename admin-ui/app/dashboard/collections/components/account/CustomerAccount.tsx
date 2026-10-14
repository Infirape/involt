import { AlertTriangle, CheckCircle2, Loader2, Printer, X } from "lucide-react";
import { useCallback, useEffect, useMemo, useState } from "react";
import type { Payment } from "@/app/gen/involt/v1/payments_pb";
import { useAuth } from "@/lib/hooks/useAuth";
import { type PaymentInput, useCustomerAccount } from "../../hooks/useCustomerAccount";
import { openPaymentVoucher } from "../../lib/api";
import { formatSoles, sumAmounts } from "../../lib/money";
import { PaymentForm } from "./PaymentForm";
import { PaymentHistory } from "./PaymentHistory";
import { ReceiptList } from "./ReceiptList";
import { VoidPaymentDialog } from "./VoidPaymentDialog";

interface CustomerAccountProps {
  customerId: string;
  /** Receipt to preselect (e.g. the matrix cell that was clicked). Defaults to all pending. */
  preselectedReadingId?: string;
  onChanged?: () => void;
}

/** Customer's receipts, cash desk form and payment history. Used in the drawer and in Caja. */
export function CustomerAccount({
  customerId,
  preselectedReadingId,
  onChanged,
}: CustomerAccountProps) {
  const { isAdmin, isSupervisor } = useAuth();
  const { account, loading, submitting, registerPayment, voidPayment } = useCustomerAccount(
    customerId,
    onChanged,
  );
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [lastPayment, setLastPayment] = useState<Payment | null>(null);
  const [voiding, setVoiding] = useState<Payment | null>(null);

  const outstanding = useMemo(
    () => (account?.receipts ?? []).filter((r) => r.balance > 0 && r.reading),
    [account],
  );

  // Reset the selection whenever the account (re)loads.
  useEffect(() => {
    const ids = outstanding.map((r) => r.reading?.id ?? "");
    const preselected = preselectedReadingId && ids.includes(preselectedReadingId);
    setSelectedIds(new Set(preselected ? [preselectedReadingId] : ids));
  }, [outstanding, preselectedReadingId]);

  const selectedBalance = sumAmounts(
    outstanding.filter((r) => selectedIds.has(r.reading?.id ?? "")).map((r) => r.balance),
  );
  // Keep the backend's oldest-first order for the request.
  const orderedSelection = outstanding
    .map((r) => r.reading?.id ?? "")
    .filter((id) => selectedIds.has(id));

  const toggle = useCallback((id: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }, []);

  const toggleAll = (select: boolean) =>
    setSelectedIds(new Set(select ? outstanding.map((r) => r.reading?.id ?? "") : []));

  const handlePay = async (input: PaymentInput) => {
    const payment = await registerPayment(input);
    if (payment) setLastPayment(payment);
    return payment !== null;
  };

  if (loading && !account) {
    return (
      <div className="flex justify-center py-16">
        <Loader2 className="w-6 h-6 text-zinc-600 animate-spin" />
      </div>
    );
  }
  if (!account?.customer) return null;

  return (
    <div className="space-y-5">
      <AccountSummary
        name={account.customer.name}
        code={account.customer.code}
        totalDebt={account.totalDebt}
        overdueCount={account.overdueCount}
      />

      {lastPayment && (
        <LastPaymentBanner payment={lastPayment} onDismiss={() => setLastPayment(null)} />
      )}

      <ReceiptList
        receipts={account.receipts}
        selectedIds={selectedIds}
        onToggle={toggle}
        onToggleAll={toggleAll}
      />

      {outstanding.length > 0 && (
        <PaymentForm
          selectedBalance={selectedBalance}
          selectedIds={orderedSelection}
          submitting={submitting}
          onSubmit={handlePay}
        />
      )}

      <PaymentHistory
        payments={account.payments}
        canVoid={isAdmin || isSupervisor}
        onVoid={setVoiding}
      />

      {voiding && (
        <VoidPaymentDialog
          payment={voiding}
          submitting={submitting}
          onCancel={() => setVoiding(null)}
          onConfirm={async (reason) => {
            if (await voidPayment(voiding.id, reason)) {
              if (lastPayment?.id === voiding.id) setLastPayment(null);
              setVoiding(null);
            }
          }}
        />
      )}
    </div>
  );
}

function AccountSummary(props: {
  name: string;
  code: string;
  totalDebt: number;
  overdueCount: number;
}) {
  return (
    <div className="flex items-start justify-between gap-3">
      <div className="min-w-0">
        <p className="text-[11px] font-mono text-zinc-500">{props.code}</p>
        <h3 className="text-base font-bold text-white truncate">{props.name}</h3>
      </div>
      <div className="text-right shrink-0">
        <p className="text-[10px] uppercase tracking-wider text-zinc-500">Deuda total</p>
        <p
          className={`text-lg font-bold tabular-nums ${props.totalDebt > 0 ? "text-red-400" : "text-emerald-400"}`}
        >
          {formatSoles(props.totalDebt)}
        </p>
        {props.overdueCount > 0 && (
          <p className="text-[10px] text-red-400 flex items-center justify-end gap-1">
            <AlertTriangle className="w-3 h-3" />
            {props.overdueCount} {props.overdueCount === 1 ? "recibo vencido" : "recibos vencidos"}
          </p>
        )}
      </div>
    </div>
  );
}

function LastPaymentBanner({ payment, onDismiss }: { payment: Payment; onDismiss: () => void }) {
  return (
    <div className="flex items-center gap-3 p-3 rounded-xl border border-emerald-500/25 bg-emerald-500/10 text-xs">
      <CheckCircle2 className="w-4 h-4 text-emerald-400 shrink-0" />
      <div className="flex-1 text-emerald-200">
        Pago de <strong>{formatSoles(payment.amount)}</strong> registrado · Comprobante N°{" "}
        {String(payment.receiptNumber).padStart(6, "0")}
      </div>
      <button
        type="button"
        onClick={() => openPaymentVoucher(payment.id)}
        className="px-2.5 py-1 rounded-lg bg-emerald-400 text-black font-semibold flex items-center gap-1 hover:bg-emerald-300"
      >
        <Printer className="w-3 h-3" /> Imprimir
      </button>
      <button
        type="button"
        onClick={onDismiss}
        aria-label="Cerrar aviso"
        className="text-emerald-300/60 hover:text-emerald-200"
      >
        <X className="w-3.5 h-3.5" />
      </button>
    </div>
  );
}
