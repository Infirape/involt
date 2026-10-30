import { create } from "@bufbuild/protobuf";
import { Loader2, Search } from "lucide-react";
import { useEffect, useState } from "react";
import { GetCustomersRequestSchema } from "@/app/gen/involt/v1/admin_pb";
import type { Customer } from "@/app/gen/involt/v1/models_pb";
import { adminClient } from "@/lib/rpc";

interface CustomerSearchProps {
  selectedId: string | null;
  onSelect: (customer: Customer) => void;
}

/** Debounced lookup by name or supply code (respects the user's assigned sectors). */
export function CustomerSearch({ selectedId, onSelect }: CustomerSearchProps) {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<Customer[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const q = query.trim();
    if (q.length < 2) {
      setResults([]);
      return;
    }
    let cancelled = false;
    const timer = setTimeout(async () => {
      setLoading(true);
      try {
        const resp = await adminClient.getCustomers(
          create(GetCustomersRequestSchema, { searchQuery: q, pageNumber: 1, pageSize: 12 }),
        );
        if (!cancelled) setResults(resp.customers);
      } catch {
        if (!cancelled) setResults([]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    }, 300);
    return () => {
      cancelled = true;
      clearTimeout(timer);
    };
  }, [query]);

  return (
    <div className="flex flex-col min-h-0 h-full">
      <div className="relative p-3 border-b border-zinc-800">
        <Search className="w-4 h-4 text-zinc-500 absolute left-6 top-1/2 -translate-y-1/2" />
        <input
          // biome-ignore lint/a11y/noAutofocus: the cash desk starts by searching a customer
          autoFocus
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Nombre o código de suministro"
          aria-label="Buscar cliente"
          className="w-full bg-zinc-950 border border-zinc-800 rounded-xl pl-9 pr-9 py-2.5 text-sm text-white focus:outline-none focus:border-cyan-500/50"
        />
        {loading && (
          <Loader2 className="w-4 h-4 text-zinc-500 animate-spin absolute right-6 top-1/2 -translate-y-1/2" />
        )}
      </div>
      <ul className="flex-1 overflow-y-auto p-2 space-y-1">
        {query.trim().length < 2 && (
          <li className="text-xs text-zinc-500 text-center py-8">
            Escribí al menos 2 letras para buscar.
          </li>
        )}
        {query.trim().length >= 2 && !loading && results.length === 0 && (
          <li className="text-xs text-zinc-500 text-center py-8">Sin resultados.</li>
        )}
        {results.map((c) => (
          <li key={c.id}>
            <button
              type="button"
              onClick={() => onSelect(c)}
              className={`w-full text-left px-3 py-2 rounded-xl transition-colors ${
                selectedId === c.id
                  ? "bg-cyan-500/10 border border-cyan-500/30"
                  : "border border-transparent hover:bg-zinc-800/60"
              }`}
            >
              <div className="text-sm text-zinc-200 font-medium truncate">{c.name}</div>
              <div className="text-[11px] font-mono text-zinc-500">
                {c.code}
                {c.address && <span className="font-sans"> · {c.address}</span>}
              </div>
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}
