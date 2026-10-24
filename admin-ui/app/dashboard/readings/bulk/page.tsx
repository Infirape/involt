"use client";

import { useEffect, useState } from "react";
import {
  Search,
  Save,
  ChevronLeft,
  Database,
  CheckCircle2,
  AlertCircle,
} from "lucide-react";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { useRouter } from "next/navigation";
import { useBulkReadings } from "../hooks/useBulkReadings";
import { type Customer } from "@/app/gen/involt/v1/models_pb";
import { useConfigStore } from "@/lib/store/useConfigStore";
import { SectorOptions } from "@/components/ui/sector-options";

export default function BulkReadingsPage() {
  const router = useRouter();
  const {
    loading,
    data,
    filters,
    setFilters,
    bulkReadings,
    syncedReadings,
    filteredCustomers,
    handleInputChange,
    handlePreviousInputChange,
    bulkPreviousReadings,
    handleObservationChange,
    bulkObservations,
    handleSave,
    saveSingleReading,
  } = useBulkReadings();

  const { selectedPeriod, periods: globalPeriods } = useConfigStore();

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  }, [filters.page]);

  const isOldestPeriod =
    globalPeriods.length > 0 &&
    [...globalPeriods].sort((a, b) => a.id.localeCompare(b.id))[0].id ===
      selectedPeriod;

  return (
    <div className="p-4 space-y-3 animate-in fade-in duration-1000">
      {/* Header Section Compact */}
      <div className="flex items-center justify-between border-b border-white/5 pb-2">
        <div className="flex items-center gap-4">
          <button
            onClick={() => router.back()}
            className="p-2 rounded-xl bg-white/5 hover:bg-white/10 transition-colors"
          >
            <ChevronLeft className="w-4 h-4" />
          </button>
          <div>
            <h1 className="text-xl font-black tracking-tighter flex items-center gap-2">
              Carga Masiva <span className="text-primary italic">Lecturas</span>
            </h1>
            <p className="text-muted-foreground/40 font-bold uppercase text-[8px] tracking-[0.2em]">
              {selectedPeriod} • {filteredCustomers.length} Suministros
            </p>
          </div>
        </div>

        <div className="flex items-center gap-6">
          <div className="flex flex-col items-end">
            <span className="text-[10px] font-black text-white leading-none">
              {data.totalReadings} / {data.totalCount}
            </span>
            <div className="w-32 h-1 bg-white/5 rounded-full mt-1 overflow-hidden">
              <div 
                className="h-full bg-primary transition-all duration-1000" 
                style={{ width: `${(data.totalReadings / data.totalCount) * 100}%` }}
              />
            </div>
          </div>
          <Button
            onClick={handleSave}
            disabled={loading}
            className="bg-primary hover:bg-primary/80 text-black font-black px-6 rounded-2xl h-10 shadow-lg shadow-primary/20 flex gap-2 group transition-all active:scale-95"
          >
            <Save className="w-4 h-4 group-hover:scale-110 transition-transform" />
            GUARDAR TODOS
          </Button>
        </div>
      </div>

      {/* Filters & Search Compact */}
      <div className="grid grid-cols-12 gap-3">
        <div className="col-span-3">
          <Label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 mb-1 block ml-1">
            Sector
          </Label>
          <select
            value={filters.sectorId}
            onChange={(e) =>
              setFilters((prev) => ({ ...prev, sectorId: e.target.value, page: 1 }))
            }
            className="w-full bg-black/40 border-2 border-white/5 rounded-2xl px-4 py-2 text-xs font-bold text-white outline-none focus:border-primary/40 transition-all appearance-none"
          >
            <option value="">TODOS LOS SECTORES</option>
            <SectorOptions sectors={data.sectors} optionClassName="bg-zinc-900 text-white" />
          </select>
        </div>

        <div className="col-span-3">
          <Label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 mb-1 block ml-1">
            Periodo Activo
          </Label>
          <div className="w-full bg-primary/10 border-2 border-primary/20 rounded-2xl px-4 py-2 text-xs font-black text-primary flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-primary animate-pulse" />
            {selectedPeriod}
          </div>
        </div>

        <div className="col-span-6 relative flex flex-col justify-end">
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground/30" />
            <input
              type="text"
              placeholder="BUSCAR SUMINISTRO O NOMBRE..."
              value={filters.searchQuery}
              onChange={(e) =>
                setFilters((prev) => ({ ...prev, searchQuery: e.target.value, page: 1 }))
              }
              className="w-full bg-black/40 border-2 border-white/5 rounded-2xl pl-12 pr-4 py-2 text-xs font-black placeholder:text-white/10 text-white outline-none focus:border-primary/40 transition-all"
            />
          </div>
        </div>
      </div>

      {/* Main Table Content */}
      <Card className="bg-black/40 border-white/5 overflow-hidden rounded-3xl shadow-2xl backdrop-blur-xl">
        <div className="overflow-x-auto max-h-[60vh] scrollbar-thin scrollbar-thumb-white/10">
          <table className="w-full">
            <thead>
              <tr className="border-b border-white/5 bg-white/2">
                <th className="px-4 py-2 text-left text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  #
                </th>
                <th className="px-4 py-2 text-left text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Cód
                </th>
                <th className="px-4 py-2 text-left text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Suministro
                </th>
                {!isOldestPeriod && (
                  <th className="px-4 py-2 text-center text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                    ANT
                  </th>
                )}
                <th className="px-4 py-2 text-center text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  ACT
                </th>
                <th className="px-4 py-2 text-center text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Consumo
                </th>
                <th className="px-4 py-2 text-left text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Observación
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-white/5">
              {loading ? (
                [1, 2, 3, 4, 5, 6, 7, 8].map((i) => (
                  <tr key={i} className="animate-pulse">
                    <td colSpan={7} className="px-8 py-6">
                      <div className="h-8 bg-white/5 rounded-2xl w-full" />
                    </td>
                  </tr>
                ))
              ) : filteredCustomers.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-8 py-20 text-center">
                    <div className="flex flex-col items-center gap-4 opacity-20">
                      <Database className="w-16 h-16" />
                      <p className="text-[10px] font-black uppercase tracking-[0.4em]">
                        No se encontraron suministros
                      </p>
                    </div>
                  </td>
                </tr>
              ) : (
                filteredCustomers.map((customer, index) => (
                  <ReadingRow
                    key={customer.id}
                    index={index}
                    customer={customer}
                    filters={filters}
                    isSynced={syncedReadings.has(customer.id)}
                    bulkReadings={bulkReadings}
                    bulkPreviousReadings={bulkPreviousReadings}
                    bulkObservations={bulkObservations}
                    isOldestPeriod={isOldestPeriod}
                    handleInputChange={handleInputChange}
                    handlePreviousInputChange={handlePreviousInputChange}
                    handleObservationChange={handleObservationChange}
                    saveSingleReading={saveSingleReading}
                    filteredCustomers={filteredCustomers}
                  />
                ))
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination Controls */}
        <div className="flex items-center justify-between px-6 py-4 bg-white/2 border-t border-white/5">
          <div className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">
            Página {filters.page} de {Math.ceil(data.totalCount / 500) || 1} •
            Total: {data.totalCount}
          </div>
          <div className="flex items-center gap-2">
            <Button
              variant="outline"
              size="sm"
              className="h-8 rounded-lg border-white/5 bg-white/2 hover:bg-white/5 text-[10px] font-black uppercase tracking-widest disabled:opacity-20"
              onClick={() =>
                setFilters((prev) => ({
                  ...prev,
                  page: Math.max(1, prev.page - 1),
                }))
              }
              disabled={filters.page === 1 || loading}
            >
              Anterior
            </Button>
            <Button
              variant="outline"
              size="sm"
              className="h-8 rounded-lg border-white/5 bg-white/2 hover:bg-white/5 text-[10px] font-black uppercase tracking-widest disabled:opacity-20"
              onClick={() =>
                setFilters((prev) => ({ ...prev, page: prev.page + 1 }))
              }
              disabled={
                filters.page >= Math.ceil(data.totalCount / 500) || loading
              }
            >
              Siguiente
            </Button>
          </div>
        </div>
</Card>
    </div>
  );
}

interface ReadingRowProps {
  index: number;
  customer: Customer;
  filters: {
    sectorId: string;
    searchQuery: string;
    page: number;
    showMissing: boolean;
  };
  isSynced: boolean;
  bulkReadings: Record<string, string>;
  bulkPreviousReadings: Record<string, string>;
  bulkObservations: Record<string, string>;
  isOldestPeriod: boolean;
  handleInputChange: (customerId: string, value: string, isPrevious?: boolean) => void;
  handlePreviousInputChange: (customerId: string, value: string) => void;
  handleObservationChange: (customerId: string, value: string) => void;
  saveSingleReading: (customerId: string, value: string) => Promise<void>;
  filteredCustomers: Customer[];
}

// Sub-component for individual rows to handle local UI state (like 'Other' toggle)
function ReadingRow({ 
  index, 
  customer, 
  filters, 
  isSynced, 
  bulkReadings, 
  bulkPreviousReadings, 
  bulkObservations,
  isOldestPeriod,
  handleInputChange,
  handlePreviousInputChange,
  handleObservationChange,
  saveSingleReading,
  filteredCustomers,
}: ReadingRowProps) {
  const { selectedPeriod, periods: globalPeriods } = useConfigStore();
  const PRESETS = ["NO SE PUDO ACCEDER", "MEDIDOR MALOGRADO", "VIVIENDA DESHABITADA", "PERRO AGRESIVO"];
  
  const currentObs = bulkObservations[customer.id] || "";
  const isPreset = PRESETS.includes(currentObs);
  const [showCustomInput, setShowCustomInput] = useState(currentObs !== "" && !isPreset);

  const prevVal = (customer.lastReadingValue === 0 || isSynced) && 
                   bulkPreviousReadings[customer.id] !== undefined && 
                   bulkPreviousReadings[customer.id] !== "" 
                   ? parseFloat(bulkPreviousReadings[customer.id]) 
                   : customer.lastReadingValue;

  const rawCurrent = bulkReadings[customer.id] || "";
  const currentVal = rawCurrent !== "" ? parseFloat(rawCurrent) : null;
  const consumption = currentVal !== null ? currentVal - prevVal : 0;
  const isNegative = currentVal !== null && consumption < 0;

  const currentPeriod = globalPeriods.find((p) => p.id === selectedPeriod);
  const isPeriodOpen = currentPeriod?.status === "OPEN";
  const canEdit = isPeriodOpen;

  return (
    <tr className="hover:bg-white/3 transition-all duration-300 group">
      <td className="px-4 py-1.5">
        <div className="text-[10px] font-black font-mono text-muted-foreground/40">
          {(filters.page - 1) * 500 + index + 1}
        </div>
      </td>
      <td className="px-4 py-1.5">
        <div className="text-[10px] font-black font-mono text-primary">
          {customer.code}
        </div>
      </td>
      <td className="px-4 py-1.5">
        <div className="flex flex-col">
          <div className="text-[10px] font-black tracking-tight text-white leading-none">
            {customer.name}
          </div>
          <div className="text-[8px] font-bold text-muted-foreground/40 mt-1 uppercase">
            {customer.meterNumber}
          </div>
        </div>
      </td>
      {!isOldestPeriod && (
        <td className="px-4 py-1.5">
          <div className="flex justify-center">
            {customer.lastReadingValue === 0 ? (
              <input
                type="text"
                value={bulkPreviousReadings[customer.id] !== undefined ? bulkPreviousReadings[customer.id] : ""}
                onChange={(e) => handlePreviousInputChange(customer.id, e.target.value)}
                disabled={isSynced}
                className={`w-20 bg-transparent border-b border-transparent text-center text-[10px] font-mono font-bold outline-none transition-all
                  ${isSynced ? "text-muted-foreground/20" : "text-yellow-500/50 focus:border-yellow-500/30 focus:text-yellow-500"}`}
              />
            ) : (
              <span className="text-[10px] font-black font-mono text-muted-foreground/30">
                {prevVal.toLocaleString()}
              </span>
            )}
          </div>
        </td>
      )}
      <td className="px-4 py-1.5 flex justify-center">
        <div className="relative w-32 group/input">
          <input
            id={`input-${customer.id}`}
            type="text"
            value={bulkReadings[customer.id] || ""}
            onChange={(e) => handleInputChange(customer.id, e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                saveSingleReading(customer.id, bulkReadings[customer.id]);
                const nextInput = document.getElementById(
                  `input-${filteredCustomers[filteredCustomers.indexOf(customer) + 1]?.id}`,
                ) as HTMLInputElement;
                if (nextInput) nextInput.focus();
              }
            }}
            disabled={!canEdit || currentObs !== ""}
            placeholder="0.00"
            className={`w-full bg-black/40 border-2 rounded-2xl px-4 py-2 text-sm font-black font-mono transition-all outline-none text-center
              ${isSynced 
                ? currentObs !== "" 
                  ? "border-amber-500/50 text-amber-400 cursor-not-allowed" 
                  : "border-green-500/50 text-green-400 cursor-not-allowed" 
                : "border-white/10 text-white focus:border-primary focus:bg-black/60 shadow-2xl focus:shadow-primary/20"}`}
          />
        </div>
        <div className="ml-2 flex items-center">
          {isSynced ? (
            currentObs !== "" ? (
              <CheckCircle2 className="w-4 h-4 text-amber-500 animate-in zoom-in duration-300" />
            ) : (
              <CheckCircle2 className="w-4 h-4 text-green-500 animate-in zoom-in duration-300" />
            )
          ) : bulkReadings[customer.id] ? (
            <div className="w-2 h-2 rounded-full bg-yellow-500 animate-pulse shadow-[0_0_10px_rgba(234,179,8,0.5)]" />
          ) : null}
        </div>
      </td>
      <td className="px-4 py-1.5">
        <div className={`text-center text-[10px] font-black font-mono transition-colors
          ${isNegative ? "text-red-500" : "text-cyan-400/60"}`}>
          {isNegative ? (
            <span className="flex items-center justify-center gap-1 text-red-500 font-bold animate-pulse">
              <AlertCircle className="w-3 h-3" />
              {consumption.toFixed(2)}
            </span>
          ) : (
            <span>
              {(() => {
                if (currentVal === null || consumption === 0) return "-";
                return consumption > 0 ? `+${consumption.toFixed(2)}` : consumption.toFixed(2);
              })()}
            </span>
          )}
        </div>
      </td>
      <td className="px-4 py-1.5">
        <div className="flex gap-2 items-center">
          <select
            value={showCustomInput ? "OTRO" : currentObs}
            onChange={(e) => {
              const val = e.target.value;
              if (val === "OTRO") {
                setShowCustomInput(true);
                handleObservationChange(customer.id, "");
              } else {
                setShowCustomInput(false);
                handleObservationChange(customer.id, val);
              }
            }}
            disabled={!canEdit}
            className={`bg-black/40 border-2 rounded-xl px-2 py-1 text-[10px] font-black uppercase tracking-tight outline-none transition-all w-32
              ${isSynced ? "border-green-500/10 text-green-400/20" : "border-white/5 focus:border-primary text-muted-foreground"}`}
          >
            <option value="">Ninguna</option>
            <option value="NO SE PUDO ACCEDER">Acceso Denegado</option>
            <option value="MEDIDOR MALOGRADO">Malogrado</option>
            <option value="VIVIENDA DESHABITADA">Deshabitada</option>
            <option value="PERRO AGRESIVO">Perro Agresivo</option>
            <option value="OTRO">Otro...</option>
          </select>

          {showCustomInput && (
            <input
              type="text"
              placeholder="Escriba el motivo..."
              value={currentObs}
              onChange={(e) => handleObservationChange(customer.id, e.target.value.toUpperCase())}
              disabled={!canEdit}
              className={`flex-1 min-w-[120px] bg-black/60 border-2 rounded-xl px-3 py-1 text-[10px] font-bold outline-none transition-all
                ${isSynced ? "border-green-500/10 text-green-400/20" : "border-primary/30 focus:border-primary text-white"}`}
              autoFocus
            />
          )}
        </div>
      </td>
    </tr>
  );
}
