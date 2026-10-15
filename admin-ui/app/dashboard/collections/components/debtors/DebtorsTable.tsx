import { Scissors } from "lucide-react";
import { ServiceStatus } from "@/app/gen/involt/v1/models_pb";
import type { DebtorRow } from "@/app/gen/involt/v1/reports_pb";
import { ServiceStatusBadge } from "@/components/dashboard/service-status/ServiceStatusBadge";
import { formatPeriod } from "../../lib/labels";
import { formatLimaDateTime, formatSoles } from "../../lib/money";

interface DebtorsTableProps {
  debtors: DebtorRow[];
  onOpen: (customerId: string) => void;
  /** Admins only: register a service cut for a debtor. */
  onRegisterCut?: (debtor: DebtorRow) => void;
}

export function DebtorsTable({ debtors, onOpen, onRegisterCut }: DebtorsTableProps) {
  if (debtors.length === 0) {
    return (
      <p className="text-sm text-zinc-500 text-center py-16">
        Ningún cliente coincide con los filtros.
      </p>
    );
  }
  return (
    <table className="w-full text-xs border-collapse">
      <thead className="sticky top-0 bg-zinc-900 z-10">
        <tr className="border-b border-zinc-800 text-zinc-400">
          <th className="text-left px-3 py-2.5 font-semibold">Cliente</th>
          <th className="text-left px-3 py-2.5 font-semibold">Caserío</th>
          <th className="text-right px-3 py-2.5 font-semibold">Deuda total</th>
          <th className="text-right px-3 py-2.5 font-semibold">Vencido</th>
          <th className="text-center px-3 py-2.5 font-semibold">Recibos venc.</th>
          <th className="text-left px-3 py-2.5 font-semibold">Atraso</th>
          <th className="text-left px-3 py-2.5 font-semibold">Último pago</th>
          <th className="px-3 py-2.5" />
        </tr>
      </thead>
      <tbody className="tabular-nums">
        {debtors.map((d) => (
          <tr key={d.customerId} className="border-b border-zinc-800/50 hover:bg-zinc-800/20">
            <td className="px-3 py-2">
              <div className="flex items-center gap-1.5 text-zinc-200 font-medium">
                {d.cutCandidate && (
                  <span
                    className="inline-flex items-center gap-1 px-1.5 py-0.5 rounded-md bg-red-500/10 border border-red-500/20 text-red-400 text-[10px] font-bold"
                    title="Candidato a corte"
                  >
                    <Scissors className="w-3 h-3" /> CORTE
                  </span>
                )}
                {d.inAgreement && (
                  <span className="px-1.5 py-0.5 rounded-md bg-cyan-500/10 border border-cyan-500/25 text-cyan-300 text-[10px] font-bold">
                    CONVENIO
                  </span>
                )}
                {d.agreementInDefault && (
                  <span className="px-1.5 py-0.5 rounded-md bg-red-500/10 border border-red-500/25 text-red-400 text-[10px] font-bold">
                    CONVENIO EN MORA
                  </span>
                )}
                <span className="truncate max-w-[240px]">{d.customerName}</span>
              </div>
              <div className="flex items-center gap-1.5 text-[10px] font-mono text-zinc-600">
                {d.customerCode}
                <ServiceStatusBadge status={d.serviceStatus} hideWhenActive />
              </div>
            </td>
            <td className="px-3 py-2 text-zinc-400">
              {d.sectorName}
              <div className="text-[10px] text-zinc-600">{d.communityName}</div>
            </td>
            <td className="px-3 py-2 text-right font-semibold text-red-400">
              {formatSoles(d.totalDebt)}
            </td>
            <td className="px-3 py-2 text-right text-zinc-300">{formatSoles(d.overdueDebt)}</td>
            <td className="px-3 py-2 text-center text-zinc-300">
              {d.overdueReceipts}
              <span className="text-zinc-600">/{d.pendingReceipts}</span>
            </td>
            <td className="px-3 py-2 text-zinc-400">
              {d.daysOverdue > 0 ? (
                <>
                  {d.daysOverdue} días
                  <div className="text-[10px] text-zinc-600">
                    desde {formatPeriod(d.oldestOverduePeriod)}
                  </div>
                </>
              ) : (
                <span className="text-zinc-600">Por vencer</span>
              )}
            </td>
            <td className="px-3 py-2 text-zinc-500 whitespace-nowrap">
              {d.lastPaymentAt ? formatLimaDateTime(d.lastPaymentAt).split(",")[0] : "Nunca"}
            </td>
            <td className="px-3 py-2 text-right whitespace-nowrap">
              {onRegisterCut && d.cutCandidate && d.serviceStatus === ServiceStatus.ACTIVE && (
                <button
                  type="button"
                  onClick={() => onRegisterCut(d)}
                  className="mr-1.5 px-2.5 py-1 rounded-lg text-[11px] font-semibold bg-red-500/10 text-red-400 border border-red-500/25 hover:bg-red-500/20"
                >
                  Registrar corte
                </button>
              )}
              <button
                type="button"
                onClick={() => onOpen(d.customerId)}
                className="px-2.5 py-1 rounded-lg text-[11px] font-semibold bg-zinc-800 text-zinc-200 hover:bg-cyan-400 hover:text-black transition-colors"
              >
                Cobrar
              </button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
