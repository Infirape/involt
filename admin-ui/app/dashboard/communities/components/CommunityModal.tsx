"use client";

import { create } from "@bufbuild/protobuf";
import { Plus, Trash2, X } from "lucide-react";
import { useEffect, useRef } from "react";
import { type Community, CommunitySchema, type Sector } from "@/app/gen/involt/v1/models_pb";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

interface CommunityModalProps {
  isOpen: boolean;
  onClose: () => void;
  editingCommunity: Community | null;
  setEditingCommunity: React.Dispatch<React.SetStateAction<Community | null>>;
  editingSectors: Sector[];
  addEditingSector: () => void;
  updateEditingSectorName: (index: number, name: string) => void;
  removeEditingSector: (index: number) => void;
  onSave: (e: React.FormEvent) => void;
  saving: boolean;
}

export function CommunityModal({
  isOpen,
  onClose,
  editingCommunity,
  setEditingCommunity,
  editingSectors,
  addEditingSector,
  updateEditingSectorName,
  removeEditingSector,
  onSave,
  saving,
}: CommunityModalProps) {
  const sectorsEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (isOpen) {
      sectorsEndRef.current?.scrollIntoView({ behavior: "smooth", block: "nearest" });
    }
  }, [isOpen]);

  if (!isOpen || !editingCommunity) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-md animate-in fade-in duration-300">
      <Card className="w-full max-w-lg border-white/10 bg-card shadow-2xl shadow-primary/10 animate-in zoom-in-95 duration-300">
        <CardHeader className="flex flex-row items-center justify-between border-b border-white/5 pb-4">
          <div>
            <CardHeader className="p-0">
              <h2 className="text-2xl font-black uppercase tracking-tighter">
                {editingCommunity.id ? "Editar Comunidad" : "Nueva Comunidad"}
              </h2>
              <p className="text-xs text-muted-foreground font-medium uppercase tracking-widest">
                Definí el nombre de la comunidad y sus sectores o caseríos
              </p>
            </CardHeader>
          </div>
          <Button
            variant="ghost"
            size="icon"
            onClick={onClose}
            className="rounded-full hover:bg-white/10"
          >
            <X className="w-4 h-4" />
          </Button>
        </CardHeader>
        <form onSubmit={onSave}>
          <CardContent className="p-6 space-y-6">
            <div className="space-y-2">
              <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                Nombre de la Comunidad
              </Label>
              <Input
                required
                value={editingCommunity.name}
                onChange={(e) =>
                  setEditingCommunity((prev) =>
                    prev ? create(CommunitySchema, { ...prev, name: e.target.value }) : null,
                  )
                }
                className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                placeholder="Ej: Chetilla Centro"
              />
            </div>

            <div className="border-t border-white/5 pt-4 space-y-4">
              <div className="flex items-center justify-between">
                <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                  Sectores / Caseríos
                </Label>
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  onClick={addEditingSector}
                  className="h-8 text-[10px] font-bold uppercase tracking-widest text-primary hover:bg-primary/10 rounded-lg"
                >
                  <Plus className="w-3.5 h-3.5 mr-1" />
                  Agregar Sector
                </Button>
              </div>

              <div className="space-y-2 max-h-60 overflow-y-auto pr-1">
                {editingSectors.length === 0 ? (
                  <p className="text-xs text-muted-foreground italic text-center py-4">
                    No hay sectores/caseríos agregados
                  </p>
                ) : (
                  editingSectors.map((s, index) => (
                    <div key={s.id || `sector-${index}`} className="flex items-center gap-2">
                      <Input
                        required
                        value={s.name}
                        onChange={(e) => updateEditingSectorName(index, e.target.value)}
                        className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-10 text-sm"
                        placeholder="Nombre del sector (ej: La Libertad)"
                      />
                      <Button
                        type="button"
                        variant="ghost"
                        size="icon"
                        onClick={() => removeEditingSector(index)}
                        className="w-10 h-10 rounded-xl hover:bg-red-500/10 text-red-500/60 hover:text-red-500 transition-colors"
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                  ))
                )}
                <div ref={sectorsEndRef} />
              </div>
            </div>
          </CardContent>
          <div className="p-6 border-t border-white/5 flex justify-end gap-3">
            <Button
              type="button"
              variant="ghost"
              onClick={onClose}
              className="h-12 px-6 font-bold uppercase tracking-widest rounded-xl hover:bg-white/10"
            >
              Cancelar
            </Button>
            <Button
              type="submit"
              disabled={saving}
              className="h-12 px-8 font-black uppercase tracking-tighter rounded-xl bg-primary text-primary-foreground hover:scale-[1.02] active:scale-[0.98] transition-all shadow-xl shadow-primary/20"
            >
              {saving ? "Guardando..." : "Guardar"}
            </Button>
          </div>
        </form>
      </Card>
    </div>
  );
}
