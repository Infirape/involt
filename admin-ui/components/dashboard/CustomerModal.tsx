"use client";

import { X } from "lucide-react";
import dynamic from "next/dynamic";
import { createPortal } from "react-dom";
import { ConnectionType, type Customer, type Sector } from "@/app/gen/involt/v1/models_pb";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

const LocationPicker = dynamic(() => import("@/components/dashboard/LocationPicker"), {
  ssr: false,
  loading: () => (
    <div className="h-64 w-full rounded-2xl bg-white/5 animate-pulse flex items-center justify-center border border-white/10">
      <span className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">
        Cargando Mapa...
      </span>
    </div>
  ),
});

interface CustomerModalProps {
  isOpen: boolean;
  isEditing: boolean;
  customer: Partial<Customer> | null;
  sectors: Sector[];
  communityId?: string;
  saving: boolean;
  onClose: () => void;
  onChange: (customer: Partial<Customer>) => void;
  onSave: (e: React.FormEvent) => void;
}

export function CustomerModal({
  isOpen,
  isEditing,
  customer,
  sectors,
  communityId,
  saving,
  onClose,
  onChange,
  onSave,
}: CustomerModalProps) {
  if (!isOpen || !customer || typeof document === "undefined") return null;

  const filteredSectors = sectors.filter((s) => !communityId || s.communityId === communityId);

  return createPortal(
    <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-background/80 backdrop-blur-md animate-in fade-in duration-300">
      <Card className="w-full max-w-4xl border-white/10 bg-card shadow-2xl shadow-primary/10 animate-in zoom-in-95 duration-300 overflow-hidden">
        <div className="grid grid-cols-1 md:grid-cols-2 h-full">
          <div className="p-8 space-y-6 border-r border-white/5">
            <div className="space-y-1">
              <h2 className="text-2xl font-black uppercase tracking-tighter">
                {isEditing ? "Editar Suministro" : "Nuevo Suministro"}
              </h2>
              <p className="text-[10px] text-muted-foreground font-medium uppercase tracking-widest">
                Información técnica del cliente
              </p>
            </div>

            <form onSubmit={onSave} className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                    Código Suministro
                  </Label>
                  <Input
                    required
                    value={customer.code || ""}
                    onChange={(e) => onChange({ ...customer, code: e.target.value })}
                    className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11 font-mono font-bold text-primary"
                    placeholder="SUM-000"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                    {communityId ? "Sector de la Comunidad" : "Sector"}
                  </Label>
                  <select
                    value={customer.sectorId || filteredSectors[0]?.id || ""}
                    onChange={(e) => onChange({ ...customer, sectorId: e.target.value })}
                    className="w-full h-11 px-4 bg-white/5 border border-white/5 rounded-xl text-sm font-bold focus:border-primary/30 outline-none transition-all cursor-pointer"
                  >
                    {filteredSectors.map((s) => (
                      <option key={s.id} value={s.id}>
                        {s.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="space-y-2">
                <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                  Nombre Completo
                </Label>
                <Input
                  required
                  value={customer.name || ""}
                  onChange={(e) => onChange({ ...customer, name: e.target.value })}
                  className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                  placeholder="Nombre del titular"
                />
              </div>

              <div className="space-y-2">
                <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                  Dirección
                </Label>
                <Input
                  required
                  value={customer.address || ""}
                  onChange={(e) => onChange({ ...customer, address: e.target.value })}
                  className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                  placeholder="Ubicación física"
                />
              </div>

              <div className="grid grid-cols-1 gap-4">
                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                    Tipo de Conexión
                  </Label>
                  <select
                    value={customer.connectionType ?? ConnectionType.MONOFASICA}
                    onChange={(e) =>
                      onChange({
                        ...customer,
                        connectionType: parseInt(e.target.value, 10) as ConnectionType,
                      })
                    }
                    className="w-full h-11 px-4 bg-white/5 border border-white/5 rounded-xl text-sm font-bold focus:border-primary/30 outline-none transition-all cursor-pointer"
                  >
                    <option value={ConnectionType.MONOFASICA}>Monofásica</option>
                    <option value={ConnectionType.TRIFASICA}>Trifásica</option>
                  </select>
                </div>
              </div>

              <div className="pt-6 border-t border-white/5 flex gap-3">
                <Button
                  type="button"
                  variant="ghost"
                  onClick={onClose}
                  className="h-12 flex-1 font-bold uppercase tracking-widest rounded-xl hover:bg-white/10"
                >
                  Cancelar
                </Button>
                <Button
                  type="submit"
                  disabled={saving}
                  className="h-12 flex-1 font-black uppercase tracking-tighter rounded-xl bg-primary text-primary-foreground hover:scale-[1.02] active:scale-[0.98] transition-all shadow-xl shadow-primary/20"
                >
                  {saving ? "Guardando..." : "Guardar"}
                </Button>
              </div>
            </form>
          </div>

          <div className="bg-white/2 p-8 space-y-6">
            <div className="flex items-center justify-between">
              <div className="space-y-1">
                <h3 className="text-sm font-black uppercase tracking-widest">Georeferencia</h3>
                <p className="text-[10px] text-muted-foreground uppercase">
                  Ubica el medidor en el mapa
                </p>
              </div>
              <Button
                variant="ghost"
                size="icon"
                onClick={onClose}
                className="rounded-full hover:bg-white/10 hidden md:flex"
              >
                <X className="w-4 h-4" />
              </Button>
            </div>

            <LocationPicker
              lat={customer.latitude || 0}
              lng={customer.longitude || 0}
              onChange={(lat, lng) => onChange({ ...customer, latitude: lat, longitude: lng })}
            />

            <div className="grid grid-cols-2 gap-4">
              <div className="p-4 rounded-2xl bg-white/5 border border-white/5">
                <p className="text-[10px] font-black uppercase opacity-40 mb-1">Latitud</p>
                <p className="text-xs font-mono font-bold">
                  {customer.latitude?.toFixed(6) || "0.000000"}
                </p>
              </div>
              <div className="p-4 rounded-2xl bg-white/5 border border-white/5">
                <p className="text-[10px] font-black uppercase opacity-40 mb-1">Longitud</p>
                <p className="text-xs font-mono font-bold">
                  {customer.longitude?.toFixed(6) || "0.000000"}
                </p>
              </div>
            </div>
          </div>
        </div>
      </Card>
    </div>,
    document.body,
  );
}
