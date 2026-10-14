import { create } from "@bufbuild/protobuf";
import { useCallback, useEffect, useState } from "react";
import { toast } from "sonner";
import {
  type CollectionPolicy,
  GetCollectionPolicyRequestSchema,
  UpdateCollectionPolicyRequestSchema,
} from "@/app/gen/involt/v1/agreements_pb";
import { adminClient } from "@/lib/rpc";
import { rpcErrorMessage } from "../lib/api";

/** Loads and saves the collection policy (mora + convenios). */
export function useCollectionPolicy() {
  const [policy, setPolicy] = useState<CollectionPolicy | null>(null);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    adminClient
      .getCollectionPolicy(create(GetCollectionPolicyRequestSchema, {}))
      .then((resp) => setPolicy(resp.policy ?? null))
      .catch((err: unknown) => toast.error(rpcErrorMessage(err, "Error al cargar las políticas")));
  }, []);

  const save = useCallback(async (next: CollectionPolicy) => {
    setSaving(true);
    try {
      const resp = await adminClient.updateCollectionPolicy(
        create(UpdateCollectionPolicyRequestSchema, { policy: next }),
      );
      setPolicy(resp.policy ?? null);
      toast.success("Políticas de cobranza guardadas");
      return true;
    } catch (err) {
      toast.error(rpcErrorMessage(err, "Revisá los valores: la política no es válida"));
      return false;
    } finally {
      setSaving(false);
    }
  }, []);

  return { policy, saving, save };
}
