import { Loader2 } from "lucide-react";
import { useCallback, useEffect, useMemo, useState } from "react";
import type { PaymentAgreement } from "@/app/gen/involt/v1/agreements_pb";
import type { Payment, ReceiptBalance } from "@/app/gen/involt/v1/payments_pb";
import { ServiceStatusDialog } from "@/components/dashboard/service-status/ServiceStatusDialog";
import { useAuth } from "@/lib/hooks/useAuth";
import { type PaymentInput, useCustomerAccount } from "../../hooks/useCustomerAccount";
import { formatPeriod } from "../../lib/labels";
import { formatSoles, sumAmounts } from "../../lib/money";
import { ReasonDialog } from "../ReasonDialog";
import { AccountSummary, LastPaymentBanner } from "./AccountHeader";
import { AgreementDialog } from "./AgreementDialog";
import { AgreementSection } from "./AgreementSection";
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

const rid = (r: ReceiptBalance) => r.reading?.id ?? "";

/** Customer's receipts, cash desk form, agreements and payment history. */
export function CustomerAccount({
  customerId,
  preselectedReadingId,
  onChanged,
}: CustomerAccountProps) {
  const { isAdmin, isSupervisor } = useAuth();
  const canManage = isAdmin || isSupervisor;
  const acct = useCustomerAccount(customerId, onChanged);
  const { account, submitting } = acct;
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [preset, setPreset] = useState<{ amount: number; key: number } | null>(null);
  const [lastPayment, setLastPayment] = useState<Payment | null>(null);
  const [voiding, setVoiding] = useState<Payment | null>(null);
  const [waiving, setWaiving] = useState<ReceiptBalance | null>(null);
  const [cancelling, setCancelling] = useState<PaymentAgreement | null>(null);
  const [planning, setPlanning] = useState(false);
  const [changingStatus, setChangingStatus] = useState(false);

  const outstanding = useMemo(
    () => (account?.receipts ?? []).filter((r) => r.balance > 0 && r.reading),
    [account],
  );

  // Reset the selection whenever the account (re)loads.
  useEffect(() => {
    const ids = outstanding.map(rid);
    const preselected = preselectedReadingId && ids.includes(preselectedReadingId);
    setSelectedIds(new Set(preselected ? [preselectedReadingId] : ids));
  }, [outstanding, preselectedReadingId]);

  const selected = outstanding.filter((r) => selectedIds.has(rid(r)));
  const selectedBalance = sumAmounts(selected.map((r) => r.balance + r.lateFee));
  const orderedSelection = selected.map(rid); // backend order: oldest first
  const agreementCandidates = selected.filter((r) => !r.agreementId).map(rid);

  const toggle = useCallback((id: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }, []);

  const collectInstallment = (a: PaymentAgreement) => {
    const ids = new Set(a.receipts.map((r) => r.readingId));
    setSelectedIds(new Set(outstanding.map(rid).filter((id) => ids.has(id))));
    setPreset({ amount: a.overdueAmount > 0 ? a.overdueAmount : a.nextAmount, key: Date.now() });
  };

  const handlePay = async (input: PaymentInput) => {
    const payment = await acct.registerPayment(input);
    if (payment) setLastPayment(payment);
    return payment !== null;
  };

  if (acct.loading && !account) {
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
        totalLateFees={account.totalLateFees}
        overdueCount={account.overdueCount}
        serviceStatus={account.customer.serviceStatus}
        onChangeStatus={isAdmin ? () => setChangingStatus(true) : undefined}
      />
      {lastPayment && (
        <LastPaymentBanner payment={lastPayment} onDismiss={() => setLastPayment(null)} />
      )}

      <AgreementSection
        agreements={account.agreements}
        canCreate={account.agreementsEnabled && agreementCandidates.length > 0}
        canCancel={canManage}
        onCreate={() => setPlanning(true)}
        onCollect={collectInstallment}
        onCancel={setCancelling}
      />

      <ReceiptList
        receipts={account.receipts}
        selectedIds={selectedIds}
        onToggle={toggle}
        onToggleAll={(all) => setSelectedIds(new Set(all ? outstanding.map(rid) : []))}
        onWaive={canManage ? setWaiving : undefined}
      />

      {outstanding.length > 0 && (
        <PaymentForm
          selectedBalance={selectedBalance}
          preset={preset}
          selectedIds={orderedSelection}
          submitting={submitting}
          onSubmit={handlePay}
        />
      )}

      <PaymentHistory payments={account.payments} canVoid={canManage} onVoid={setVoiding} />

      {voiding && (
        <VoidPaymentDialog
          payment={voiding}
          submitting={submitting}
          onCancel={() => setVoiding(null)}
          onConfirm={async (reason) => {
            if (await acct.voidPayment(voiding.id, reason)) {
              if (lastPayment?.id === voiding.id) setLastPayment(null);
              setVoiding(null);
            }
          }}
        />
      )}
      {waiving && (
        <ReasonDialog
          title="Condonar mora"
          subtitle={`${formatPeriod(waiving.reading?.period ?? "")} · mora ${formatSoles(waiving.lateFee)}`}
          description="La mora de este recibo dejará de cobrarse (también la que se genere en adelante). El recibo sigue pendiente."
          confirmLabel="Condonar"
          placeholder="Ej. Adulto mayor, error de lectura…"
          submitting={submitting}
          onCancel={() => setWaiving(null)}
          onConfirm={async (reason) => {
            if (await acct.waiveLateFee([rid(waiving)], reason)) setWaiving(null);
          }}
        />
      )}
      {cancelling && (
        <ReasonDialog
          title={`Anular convenio N° ${String(cancelling.number).padStart(6, "0")}`}
          description="Los recibos vuelven a la cobranza normal: cuentan como vencidos y generan mora. Los pagos ya hechos se mantienen."
          confirmLabel="Anular convenio"
          danger
          submitting={submitting}
          onCancel={() => setCancelling(null)}
          onConfirm={async (reason) => {
            if (await acct.cancelAgreement(cancelling.id, reason)) setCancelling(null);
          }}
        />
      )}
      {changingStatus && (
        <ServiceStatusDialog
          customerId={customerId}
          customerName={account.customer.name}
          customerCode={account.customer.code}
          currentStatus={account.customer.serviceStatus}
          onClose={() => setChangingStatus(false)}
          onChanged={() => {
            setChangingStatus(false);
            acct.refresh();
          }}
        />
      )}
      {planning && (
        <AgreementDialog
          customerId={customerId}
          customerName={account.customer.name}
          readingIds={agreementCandidates}
          onCancel={() => setPlanning(false)}
          onCreated={() => {
            setPlanning(false);
            acct.refresh();
          }}
        />
      )}
    </div>
  );
}
