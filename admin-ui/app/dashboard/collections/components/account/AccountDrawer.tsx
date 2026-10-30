import { X } from "lucide-react";
import { useEffect } from "react";
import { createPortal } from "react-dom";
import { CustomerAccount } from "./CustomerAccount";

interface AccountDrawerProps {
  customerId: string;
  preselectedReadingId?: string;
  onClose: () => void;
  onChanged: () => void;
}

/** Right-side panel with the customer account, opened from the matrix. */
export function AccountDrawer({
  customerId,
  preselectedReadingId,
  onClose,
  onChanged,
}: AccountDrawerProps) {
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && onClose();
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  // Portal to <body> so the overlay escapes the dashboard layout's stacking context.
  return createPortal(
    <div className="fixed inset-0 z-[80] flex justify-end">
      <button
        type="button"
        aria-label="Cerrar panel"
        onClick={onClose}
        className="absolute inset-0 bg-black/50 backdrop-blur-[2px] cursor-default"
      />
      <aside
        aria-label="Cuenta del cliente"
        className="relative w-full max-w-lg h-full bg-zinc-900 border-l border-zinc-800 shadow-2xl flex flex-col animate-in slide-in-from-right duration-200"
      >
        <div className="flex items-center justify-between p-4 border-b border-zinc-800">
          <p className="text-xs font-semibold text-zinc-400 uppercase tracking-wider">
            Cuenta del cliente
          </p>
          <button
            type="button"
            onClick={onClose}
            aria-label="Cerrar"
            className="p-1 rounded-lg text-zinc-400 hover:text-white hover:bg-zinc-800"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
        <div className="flex-1 overflow-y-auto p-4">
          <CustomerAccount
            customerId={customerId}
            preselectedReadingId={preselectedReadingId}
            onChanged={onChanged}
          />
        </div>
      </aside>
    </div>,
    document.body,
  );
}
