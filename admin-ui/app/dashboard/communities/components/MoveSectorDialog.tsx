"use client";

import { ArrowRightLeft, Loader2, X } from "lucide-react";
import { useState } from "react";
import type { Community } from "@/app/gen/involt/v1/models_pb";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import type { SectorWithCount } from "../hooks/useCommunities";

interface MoveSectorDialogProps {
  sector: SectorWithCount;
  communities: Community[];
  onMove: (communityId: string) => Promise<boolean>;
  onClose: () => void;
}

/** Picks the community a caserío (and its supplies) moves to. */
export function MoveSectorDialog({ sector, communities, onMove, onClose }: MoveSectorDialogProps) {
  const current = communities.find((c) => c.id === sector.communityId);
  const targets = communities.filter((c) => c.id !== sector.communityId);
  const [target, setTarget] = useState("");
  const [moving, setMoving] = useState(false);
  const supplies = sector.customerCount ?? 0;
  const targetName = targets.find((c) => c.id === target)?.name;

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!target) return;
    setMoving(true);
    const ok = await onMove(target);
    setMoving(false);
    if (ok) onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-md animate-in fade-in duration-300">
      <Card className="w-full max-w-md border-white/10 bg-card shadow-2xl shadow-primary/10 animate-in zoom-in-95 duration-300">
        <form onSubmit={submit} className="p-6 space-y-5">
          <div className="flex items-start justify-between gap-3">
            <div className="space-y-1">
              <h2 className="text-xl font-black uppercase tracking-tighter flex items-center gap-2">
                <ArrowRightLeft className="w-5 h-5 text-amber-400" /> Mover caserío
              </h2>
              <p className="text-xs text-muted-foreground">
                <span className="font-bold text-white/90">{sector.name}</span> está en{" "}
                <span className="font-bold text-white/90">{current?.name ?? "sin comunidad"}</span>
              </p>
            </div>
            <Button
              type="button"
              variant="ghost"
              size="icon"
              onClick={onClose}
              className="rounded-full hover:bg-white/10"
              aria-label="Cerrar"
            >
              <X className="w-5 h-5" />
            </Button>
          </div>

          <label className="block space-y-2">
            <span className="text-xs uppercase font-bold tracking-wider opacity-60">
              Nueva comunidad
            </span>
            <select
              value={target}
              onChange={(e) => setTarget(e.target.value)}
              className="w-full h-11 rounded-xl bg-white/5 border border-white/10 px-3 text-sm focus:outline-none focus:border-primary/40 [color-scheme:dark]"
              required
            >
              <option value="">Elegí una comunidad…</option>
              {targets.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </label>
          {targets.length === 0 && (
            <p className="text-xs text-muted-foreground italic">
              No hay otra comunidad a la cual moverlo. Creala primero.
            </p>
          )}

          <p className="text-xs rounded-xl border border-amber-500/20 bg-amber-500/10 text-amber-200 p-3">
            {supplies > 0
              ? `Sus ${supplies} ${supplies === 1 ? "suministro pasa" : "suministros pasan"}`
              : "Sus suministros pasan"}{" "}
            también a {targetName ?? "la nueva comunidad"}: los reportes y filtros por comunidad los
            mostrarán ahí desde ahora.
          </p>

          <div className="flex justify-end gap-2">
            <Button type="button" variant="ghost" onClick={onClose} disabled={moving}>
              Cancelar
            </Button>
            <Button type="submit" disabled={!target || moving} className="font-black uppercase">
              {moving && <Loader2 className="w-4 h-4 mr-2 animate-spin" />}
              Mover
            </Button>
          </div>
        </form>
      </Card>
    </div>
  );
}
