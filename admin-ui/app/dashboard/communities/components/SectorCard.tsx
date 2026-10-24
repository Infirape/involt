import { ArrowRightLeft, FileSpreadsheet, Trash2, Users } from "lucide-react";
import { Button } from "@/components/ui/button";
import type { SectorWithCount } from "../hooks/useCommunities";

interface SectorCardProps {
  sector: SectorWithCount;
  onDownload: () => void;
  onView: () => void;
  onMove: () => void;
  onDelete: () => void;
}

/** One caserío inside an expanded community, with its actions. */
export function SectorCard({ sector: s, onDownload, onView, onMove, onDelete }: SectorCardProps) {
  return (
    <div className="flex flex-col gap-2 p-3 rounded-xl bg-white/5 border border-white/5 hover:border-primary/20 transition-all duration-300 group/sector">
      <div className="flex flex-col gap-0.5">
        <span className="text-xs font-black uppercase tracking-wide text-white/90 break-words">
          {s.name}
        </span>
        <span className="text-[10px] font-bold text-muted-foreground/60 uppercase">
          {s.customerCount ?? 0} Suministros
        </span>
      </div>
      <div className="flex justify-end gap-0.5 -mb-1">
        <Button
          variant="ghost"
          size="icon"
          onClick={onDownload}
          className="w-7 h-7 rounded-lg hover:bg-emerald-500/10 text-emerald-400 opacity-60 hover:opacity-100 transition-all"
          title={`Descargar Excel de ${s.name}`}
        >
          <FileSpreadsheet className="w-4 h-4" />
        </Button>
        <Button
          variant="ghost"
          size="icon"
          onClick={onView}
          className="w-7 h-7 rounded-lg hover:bg-cyan-500/10 text-cyan-400 opacity-60 hover:opacity-100 transition-all"
          title={`Ver suministros de ${s.name}`}
        >
          <Users className="w-4 h-4" />
        </Button>
        <Button
          variant="ghost"
          size="icon"
          onClick={onMove}
          className="w-7 h-7 rounded-lg hover:bg-amber-500/10 text-amber-400 opacity-60 hover:opacity-100 transition-all"
          title={`Mover ${s.name} a otra comunidad`}
        >
          <ArrowRightLeft className="w-4 h-4" />
        </Button>
        <Button
          variant="ghost"
          size="icon"
          onClick={onDelete}
          className="w-7 h-7 rounded-lg hover:bg-red-500/10 text-red-500/60 hover:text-red-500 transition-all"
          title={`Eliminar sector ${s.name}`}
        >
          <Trash2 className="w-4 h-4" />
        </Button>
      </div>
    </div>
  );
}
