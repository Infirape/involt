import { ChevronLeft, ChevronRight } from "lucide-react";
import { Button } from "@/components/ui/button";

interface CustomerPaginatorProps {
  totalCount: number;
  pageNumber: number;
  totalPages: number;
  onPage: (pageNumber: number) => void;
}

/** Pager for the customers table; always visible. */
export function CustomerPaginator({
  totalCount,
  pageNumber,
  totalPages,
  onPage,
}: CustomerPaginatorProps) {
  return (
    <div className="flex items-center justify-between py-2">
      <p className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">
        Total: {totalCount} suministros
      </p>
      <div className="flex items-center gap-2">
        <Button
          variant="outline"
          size="icon"
          disabled={pageNumber === 1}
          onClick={() => onPage(pageNumber - 1)}
          className="w-8 h-8 rounded-lg border-white/10 hover:bg-white/10"
        >
          <ChevronLeft className="w-4 h-4" />
        </Button>
        <span className="text-[10px] font-black uppercase tracking-widest">
          {pageNumber} / {totalPages || 1}
        </span>
        <Button
          variant="outline"
          size="icon"
          disabled={pageNumber === totalPages || totalPages === 0}
          onClick={() => onPage(pageNumber + 1)}
          className="w-8 h-8 rounded-lg border-white/10 hover:bg-white/10"
        >
          <ChevronRight className="w-4 h-4" />
        </Button>
      </div>
    </div>
  );
}
