import { create } from "@bufbuild/protobuf";
import { Code } from "@connectrpc/connect";
import { useCallback, useEffect, useState } from "react";
import { toast } from "sonner";
import {
  CreateFlatChargeRequestSchema,
  GetCustomerAccountRequestSchema,
  type GetCustomerAccountResponse,
  type Payment,
  type PaymentMethod,
  RegisterPaymentRequestSchema,
  VoidPaymentRequestSchema,
} from "@/app/gen/involt/v1/payments_pb";
import { adminClient } from "@/lib/rpc";
import { rpcErrorMessage } from "../lib/api";

export interface PaymentInput {
  readingIds: string[];
  amount: number;
  method: PaymentMethod;
  reference: string;
  observation: string;
}

/** A customer's receipts, balances and payment history, plus the cash desk actions on it. */
export function useCustomerAccount(customerId: string | null, onChanged?: () => void) {
  const [account, setAccount] = useState<GetCustomerAccountResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [reloadToken, setReloadToken] = useState(0);

  // biome-ignore lint/correctness/useExhaustiveDependencies: reloadToken forces a refetch
  useEffect(() => {
    if (!customerId) {
      setAccount(null);
      return;
    }
    let cancelled = false;
    setLoading(true);
    adminClient
      .getCustomerAccount(create(GetCustomerAccountRequestSchema, { customerId }))
      .then((resp) => {
        if (!cancelled) setAccount(resp);
      })
      .catch((err: unknown) => {
        if (!cancelled) toast.error(rpcErrorMessage(err, "Error al cargar la cuenta del cliente"));
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [customerId, reloadToken]);

  const refresh = useCallback(() => {
    setReloadToken((t) => t + 1);
    onChanged?.();
  }, [onChanged]);

  const registerPayment = useCallback(
    async (input: PaymentInput): Promise<Payment | null> => {
      if (!customerId) return null;
      setSubmitting(true);
      try {
        const resp = await adminClient.registerPayment(
          create(RegisterPaymentRequestSchema, { customerId, ...input }),
        );
        toast.success(`Pago registrado · Comprobante N° ${resp.payment?.receiptNumber ?? ""}`);
        refresh();
        return resp.payment ?? null;
      } catch (err) {
        toast.error(
          rpcErrorMessage(err, "Error al registrar el pago", {
            [Code.FailedPrecondition]: "El monto supera la deuda de los recibos seleccionados",
            [Code.InvalidArgument]: "Revisá el monto y los recibos seleccionados",
          }),
        );
        return null;
      } finally {
        setSubmitting(false);
      }
    },
    [customerId, refresh],
  );

  const voidPayment = useCallback(
    async (paymentId: string, reason: string): Promise<boolean> => {
      setSubmitting(true);
      try {
        await adminClient.voidPayment(create(VoidPaymentRequestSchema, { paymentId, reason }));
        toast.success("Pago anulado; la deuda fue restituida");
        refresh();
        return true;
      } catch (err) {
        toast.error(
          rpcErrorMessage(err, "Error al anular el pago", {
            [Code.FailedPrecondition]: "Este pago ya estaba anulado",
          }),
        );
        return false;
      } finally {
        setSubmitting(false);
      }
    },
    [refresh],
  );

  return { account, loading, submitting, registerPayment, voidPayment, refresh };
}

/** Bills a period without meter reading. Returns the new reading id, or null on failure. */
export async function createFlatCharge(
  customerId: string,
  period: string,
  amount: number,
  observation: string,
): Promise<string | null> {
  try {
    const resp = await adminClient.createFlatCharge(
      create(CreateFlatChargeRequestSchema, { customerId, period, amount, observation }),
    );
    toast.success("Cargo generado");
    return resp.reading?.id ?? null;
  } catch (err) {
    toast.error(
      rpcErrorMessage(err, "Error al generar el cargo", {
        [Code.AlreadyExists]: "Ese periodo ya tiene un recibo",
        [Code.FailedPrecondition]: "El cargo fijo está en cero; ingresá un monto",
      }),
    );
    return null;
  }
}
