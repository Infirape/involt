import { UserSearch } from "lucide-react";
import { useState } from "react";
import { CustomerAccount } from "../account/CustomerAccount";
import { CustomerSearch } from "./CustomerSearch";

/** Caja: find a customer and collect any of their outstanding receipts. */
export function CashDesk() {
  const [customerId, setCustomerId] = useState<string | null>(null);

  return (
    <div className="flex gap-4 flex-1 min-h-[calc(100vh-9rem)]">
      <aside className="w-80 shrink-0 bg-zinc-900/60 border border-zinc-800 rounded-2xl overflow-hidden flex flex-col">
        <CustomerSearch selectedId={customerId} onSelect={(c) => setCustomerId(c.id)} />
      </aside>
      <section className="flex-1 min-w-0 bg-zinc-900/60 border border-zinc-800 rounded-2xl overflow-y-auto">
        {customerId ? (
          <div className="p-5 max-w-2xl">
            <CustomerAccount key={customerId} customerId={customerId} />
          </div>
        ) : (
          <div className="h-full flex flex-col items-center justify-center gap-3 text-zinc-600 py-16">
            <UserSearch className="w-12 h-12 opacity-30" />
            <p className="text-sm">Buscá un cliente para ver su deuda y registrar un pago</p>
          </div>
        )}
      </section>
    </div>
  );
}
