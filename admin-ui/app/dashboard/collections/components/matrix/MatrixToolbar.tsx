import { ChevronLeft, ChevronRight, Loader2, Search } from "lucide-react";
import type { Dispatch, SetStateAction } from "react";
import type { Half, SectorTab } from "../../types";

interface MatrixToolbarProps {
  selectedSector?: SectorTab;
  visibleCount: number;
  totalCount: number;
  loading: boolean;
  selectedYear: number;
  setSelectedYear: Dispatch<SetStateAction<number>>;
  selectedHalf: Half;
  setSelectedHalf: Dispatch<SetStateAction<Half>>;
  query: string;
  setQuery: (q: string) => void;
  onlyDebtors: boolean;
  setOnlyDebtors: (v: boolean) => void;
}

export function MatrixToolbar(props: MatrixToolbarProps) {
  const { selectedHalf, setSelectedHalf, setSelectedYear } = props;
  const currentYear = new Date().getFullYear();
  const years = Array.from({ length: 5 }, (_, i) => currentYear - 2 + i);

  const previous = () => {
    if (selectedHalf === "H2") setSelectedHalf("H1");
    else {
      setSelectedYear((y) => y - 1);
      setSelectedHalf("H2");
    }
  };
  const next = () => {
    if (selectedHalf === "H1") setSelectedHalf("H2");
    else {
      setSelectedYear((y) => y + 1);
      setSelectedHalf("H1");
    }
  };

  return (
    <div className="p-4 border-b border-zinc-800 flex flex-wrap items-center gap-3 justify-between">
      <div>
        <h2 className="text-sm font-semibold text-white">
          {props.selectedSector ? props.selectedSector.name : "Seleccioná un caserío"}
        </h2>
        <p className="text-xs text-zinc-500 mt-0.5">
          {props.visibleCount === props.totalCount
            ? `${props.totalCount} suministros`
            : `${props.visibleCount} de ${props.totalCount} suministros`}{" "}
          · {selectedHalf === "H1" ? "Ene - Jun" : "Jul - Dic"} {props.selectedYear}
        </p>
      </div>

      <div className="flex flex-wrap items-center gap-2">
        {props.loading && <Loader2 className="w-4 h-4 text-zinc-500 animate-spin" />}
        <div className="relative">
          <Search className="w-3.5 h-3.5 text-zinc-500 absolute left-2.5 top-1/2 -translate-y-1/2" />
          <input
            value={props.query}
            onChange={(e) => props.setQuery(e.target.value)}
            placeholder="Buscar nombre o código"
            aria-label="Buscar suministro"
            className="bg-zinc-950 border border-zinc-800 text-zinc-200 text-xs rounded-xl pl-8 pr-2.5 py-1.5 w-48 focus:outline-none focus:border-cyan-500/50"
          />
        </div>
        <label className="flex items-center gap-1.5 text-xs text-zinc-400 select-none cursor-pointer">
          <input
            type="checkbox"
            checked={props.onlyDebtors}
            onChange={(e) => props.setOnlyDebtors(e.target.checked)}
            className="accent-cyan-400"
          />
          Solo con deuda
        </label>
        <select
          value={props.selectedYear}
          onChange={(e) => setSelectedYear(Number.parseInt(e.target.value, 10))}
          aria-label="Año"
          className="bg-zinc-950 border border-zinc-800 text-zinc-300 text-xs rounded-xl px-2.5 py-1.5 focus:outline-none focus:border-cyan-500/50"
        >
          {years.map((y) => (
            <option key={y} value={y}>
              {y}
            </option>
          ))}
        </select>
        <div className="flex items-center bg-zinc-950 border border-zinc-800 rounded-xl p-0.5">
          <button
            type="button"
            onClick={previous}
            title="Semestre anterior"
            className="p-1 text-zinc-400 hover:text-white rounded-lg hover:bg-zinc-800"
          >
            <ChevronLeft className="w-3.5 h-3.5" />
          </button>
          <span className="text-[10px] font-black text-zinc-400 px-2 uppercase select-none min-w-[24px] text-center">
            {selectedHalf}
          </span>
          <button
            type="button"
            onClick={next}
            title="Semestre siguiente"
            className="p-1 text-zinc-400 hover:text-white rounded-lg hover:bg-zinc-800"
          >
            <ChevronRight className="w-3.5 h-3.5" />
          </button>
        </div>
      </div>
    </div>
  );
}
