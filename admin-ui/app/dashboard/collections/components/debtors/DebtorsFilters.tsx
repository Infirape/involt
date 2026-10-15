import { Search } from "lucide-react";
import { ServiceStatus } from "@/app/gen/involt/v1/models_pb";
import { SERVICE_STATUS_OPTIONS } from "@/lib/serviceStatus";
import type { DebtorFilters } from "../../hooks/useDebtors";
import type { SectorTab } from "../../types";

const inputClass =
  "bg-zinc-950 border border-zinc-800 text-zinc-200 text-xs rounded-xl px-2.5 py-1.5 focus:outline-none focus:border-cyan-500/50";

interface DebtorsFiltersProps {
  filters: DebtorFilters;
  onChange: (patch: Partial<DebtorFilters>) => void;
  communities: { id: string; name: string; sectors: SectorTab[] }[];
}

export function DebtorsFilters({ filters, onChange, communities }: DebtorsFiltersProps) {
  const sectors = filters.communityId
    ? (communities.find((c) => c.id === filters.communityId)?.sectors ?? [])
    : communities.flatMap((c) => c.sectors);

  return (
    <div className="flex flex-wrap items-end gap-3">
      <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
        Buscar
        <span className="relative">
          <Search className="w-3.5 h-3.5 text-zinc-500 absolute left-2.5 top-1/2 -translate-y-1/2" />
          <input
            value={filters.search}
            onChange={(e) => onChange({ search: e.target.value })}
            placeholder="Nombre o código"
            className={`${inputClass} pl-8 w-48`}
          />
        </span>
      </label>
      <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
        Comunidad
        <select
          value={filters.communityId}
          onChange={(e) => onChange({ communityId: e.target.value, sectorId: "" })}
          className={inputClass}
        >
          <option value="">Todas</option>
          {communities.map((c) => (
            <option key={c.id} value={c.id}>
              {c.name}
            </option>
          ))}
        </select>
      </label>
      <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
        Caserío
        <select
          value={filters.sectorId}
          onChange={(e) => onChange({ sectorId: e.target.value })}
          className={inputClass}
        >
          <option value="">Todos</option>
          {sectors.map((s) => (
            <option key={s.id} value={s.id}>
              {s.name}
            </option>
          ))}
        </select>
      </label>
      <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
        Recibos vencidos
        <select
          value={filters.minOverdueReceipts}
          onChange={(e) => onChange({ minOverdueReceipts: Number(e.target.value) })}
          className={inputClass}
        >
          <option value={0}>Cualquiera</option>
          {[1, 2, 3, 6, 12].map((n) => (
            <option key={n} value={n}>
              {n} o más
            </option>
          ))}
        </select>
      </label>
      <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
        Deuda mínima
        <select
          value={filters.minDebt}
          onChange={(e) => onChange({ minDebt: Number(e.target.value) })}
          className={inputClass}
        >
          <option value={0}>Cualquiera</option>
          {[10, 20, 50, 100].map((n) => (
            <option key={n} value={n}>
              S/ {n} o más
            </option>
          ))}
        </select>
      </label>
      <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
        Corte desde
        <select
          value={filters.cutThreshold}
          onChange={(e) => onChange({ cutThreshold: Number(e.target.value) })}
          className={inputClass}
          title="Recibos vencidos para considerar al cliente candidato a corte"
        >
          {[1, 2, 3, 4, 6].map((n) => (
            <option key={n} value={n}>
              {n} {n === 1 ? "recibo vencido" : "recibos vencidos"}
            </option>
          ))}
        </select>
      </label>
      <label className="text-[11px] text-zinc-500 flex flex-col gap-1">
        Servicio
        <select
          value={filters.serviceStatus}
          onChange={(e) => onChange({ serviceStatus: Number(e.target.value) as ServiceStatus })}
          className={inputClass}
        >
          <option value={ServiceStatus.UNSPECIFIED}>Todos</option>
          {SERVICE_STATUS_OPTIONS.map((o) => (
            <option key={o.value} value={o.value}>
              {o.label}
            </option>
          ))}
        </select>
      </label>
      <label className="flex items-center gap-1.5 text-xs text-zinc-300 select-none cursor-pointer pb-1.5">
        <input
          type="checkbox"
          checked={filters.onlyCutCandidates}
          onChange={(e) => onChange({ onlyCutCandidates: e.target.checked })}
          className="accent-red-400"
        />
        Solo candidatos a corte
      </label>
    </div>
  );
}
