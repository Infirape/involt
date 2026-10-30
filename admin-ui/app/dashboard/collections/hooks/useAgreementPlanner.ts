import { create } from "@bufbuild/protobuf";
import { Code } from "@connectrpc/connect";
import { useCallback, useEffect, useState } from "react";
import { toast } from "sonner";
import {
  AgreementRequestSchema,
  type CreateAgreementResponse,
  type PreviewAgreementResponse,
} from "@/app/gen/involt/v1/agreements_pb";
import type { PaymentMethod } from "@/app/gen/involt/v1/payments_pb";
import { adminClient } from "@/lib/rpc";
import { rpcErrorMessage } from "../lib/api";

export interface AgreementDraft {
  customerId: string;
  readingIds: string[];
  installments: number;
  initialAmount: number;
  firstDueDate: string;
  notes: string;
  initialPaymentMethod: PaymentMethod;
  initialPaymentReference: string;
}

/** Live server-side preview of an agreement draft and its creation. */
export function useAgreementPlanner(draft: AgreementDraft) {
  const [preview, setPreview] = useState<PreviewAgreementResponse | null>(null);
  const [previewing, setPreviewing] = useState(false);
  const [creating, setCreating] = useState(false);

  useEffect(() => {
    let cancelled = false;
    const timer = setTimeout(() => {
      setPreviewing(true);
      adminClient
        .previewAgreement(create(AgreementRequestSchema, draft))
        .then((resp) => {
          if (!cancelled) setPreview(resp);
        })
        .catch((err: unknown) => {
          if (!cancelled) toast.error(rpcErrorMessage(err, "Error al calcular el convenio"));
        })
        .finally(() => {
          if (!cancelled) setPreviewing(false);
        });
    }, 300);
    return () => {
      cancelled = true;
      clearTimeout(timer);
    };
  }, [draft]);

  const createAgreement = useCallback(async (): Promise<CreateAgreementResponse | null> => {
    setCreating(true);
    try {
      const resp = await adminClient.createAgreement(create(AgreementRequestSchema, draft));
      toast.success(`Convenio N° ${resp.agreement?.number ?? ""} registrado`);
      return resp;
    } catch (err) {
      toast.error(
        rpcErrorMessage(err, "Error al registrar el convenio", {
          [Code.FailedPrecondition]:
            "Algún recibo ya está en otro convenio, o los convenios están deshabilitados",
          [Code.InvalidArgument]: "Revisá las cuotas y la cuota inicial",
        }),
      );
      return null;
    } finally {
      setCreating(false);
    }
  }, [draft]);

  return { preview, previewing, creating, createAgreement };
}
