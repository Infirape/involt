"use client";

import { X, Download, FileText } from "lucide-react";
import { Card } from "@/components/ui/card";
import type { Sector } from "@/app/gen/involt/v1/models_pb";
import { useConfigStore } from "@/lib/store/useConfigStore";
import { SectorOptions } from "@/components/ui/sector-options";

interface ExportModalProps {
  isOpen: boolean;
  onClose: () => void;
  sectors: Sector[];
  filters: {
    period: string;
    sectorId: string;
  };
  onFilterChange: (filters: { period: string; sectorId: string }) => void;
  onExport: () => void;
}

export function ExportModal({
  isOpen,
  onClose,
  sectors,
  filters,
  onFilterChange,
  onExport,
}: ExportModalProps) {
  const { periods } = useConfigStore();
  
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-[1000] flex items-center justify-center p-4 bg-black/90 backdrop-blur-xl animate-in fade-in duration-300">
      <Card className="w-full max-w-lg bg-zinc-900 border-white/10 rounded-[2.5rem] overflow-hidden shadow-[0_0_50px_rgba(0,0,0,0.8)] border-t-primary/20">
        <div className="px-8 py-6 border-b border-white/5 flex items-center justify-between bg-white/2">
          <div className="space-y-1">
            <h2 className="text-2xl font-black tracking-tighter uppercase italic text-primary">
              Exportar Recibos
            </h2>
            <p className="text-[10px] font-bold text-muted-foreground/40 uppercase tracking-widest">
              Configuración de descarga masiva
            </p>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="p-2 hover:bg-white/5 rounded-full transition-colors"
          >
            <X className="w-6 h-6 text-muted-foreground/40" />
          </button>
        </div>

        <div className="p-8 space-y-6">
          <div className="grid grid-cols-1 gap-6">
            <div className="space-y-2">
              <label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 ml-1">
                Periodo de Facturación
              </label>
              <select
                value={filters.period}
                onChange={(e) => onFilterChange({ ...filters, period: e.target.value })}
                className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-4 text-sm font-bold focus:outline-none focus:border-primary/50 transition-all appearance-none text-white"
              >
                <option value="" className="bg-zinc-900 text-white">
                  Seleccionar periodo
                </option>
                {periods.map((p) => (
                  <option key={p.id} value={p.id} className="bg-zinc-900 text-white">
                    {p.id}
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-2">
              <label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 ml-1">
                Sector (Opcional)
              </label>
              <select
                value={filters.sectorId}
                onChange={(e) => onFilterChange({ ...filters, sectorId: e.target.value })}
                className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-4 text-sm font-bold focus:outline-none focus:border-primary/50 transition-all appearance-none text-white"
              >
                <option value="" className="bg-zinc-900 text-white">
                  Todos los sectores
                </option>
                <SectorOptions sectors={sectors} optionClassName="bg-zinc-900 text-white" />
              </select>
            </div>
          </div>

          <div className="pt-4 space-y-4">
            <div className="p-4 rounded-2xl bg-primary/5 border border-primary/10 flex items-start gap-4">
              <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center shrink-0">
                <FileText className="w-5 h-5 text-primary" />
              </div>
              <div className="space-y-1">
                <p className="text-[10px] font-black text-primary uppercase tracking-widest">
                  Formato de Impresión
                </p>
                <p className="text-[11px] text-muted-foreground/60 leading-relaxed font-bold">
                  Los recibos se generarán en formato A5, agrupados de a dos por cada hoja A4 para optimizar el papel.
                </p>
              </div>
            </div>

            <button
              onClick={onExport}
              className="w-full py-4 rounded-2xl bg-primary text-black text-[11px] font-black uppercase tracking-[0.2em] hover:bg-primary/90 transition-all shadow-xl shadow-primary/20 flex items-center justify-center gap-3"
            >
              <Download className="w-4 h-4" />
              Generar Documento PDF
            </button>
          </div>
        </div>
      </Card>
    </div>
  );
}

