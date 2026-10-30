import { FileSignature } from "lucide-react";
import { useState } from "react";
import type { PaymentAgreement } from "@/app/gen/involt/v1/agreements_pb";
import { AgreementCard, isAgreementOpen } from "./AgreementCard";

interface AgreementSectionProps {
  agreements: PaymentAgreement[];
  canCreate: boolean;
  canCancel: boolean;
  onCreate: () => void;
  onCollect: (agreement: PaymentAgreement) => void;
  onCancel: (agreement: PaymentAgreement) => void;
}

/** Open agreements up front, past ones collapsed, and the "nuevo convenio" action. */
export function AgreementSection({
  agreements,
  canCreate,
  canCancel,
  onCreate,
  onCollect,
  onCancel,
}: AgreementSectionProps) {
  const [showPast, setShowPast] = useState(false);
  const open = agreements.filter(isAgreementOpen);
  const past = agreements.filter((a) => !isAgreementOpen(a));
  if (agreements.length === 0 && !canCreate) return null;

  return (
    <section className="space-y-2">
      <div className="flex items-center justify-between">
        <h4 className="text-[11px] font-semibold text-zinc-400 uppercase tracking-wider">
          Convenios de pago
        </h4>
        <div className="flex items-center gap-3 text-[11px]">
          {past.length > 0 && (
            <button
              type="button"
              onClick={() => setShowPast((v) => !v)}
              className="text-zinc-500 hover:text-zinc-300"
            >
              {showPast ? "Ocultar anteriores" : `Ver anteriores (${past.length})`}
            </button>
          )}
          {canCreate && (
            <button
              type="button"
              onClick={onCreate}
              className="flex items-center gap-1 text-cyan-400 hover:text-cyan-300 font-semibold"
            >
              <FileSignature className="w-3.5 h-3.5" /> Nuevo convenio
            </button>
          )}
        </div>
      </div>
      {[...open, ...(showPast ? past : [])].map((a) => (
        <AgreementCard
          key={a.id}
          agreement={a}
          canCancel={canCancel}
          onCollect={onCollect}
          onCancel={onCancel}
        />
      ))}
    </section>
  );
}
