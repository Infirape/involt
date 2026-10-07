"use client";

import {
  ArrowUpRight,
  ChevronLeft,
  ChevronRight,
  Filter,
  Plus,
  Search,
  Trash2,
} from "lucide-react";
import { forwardRef, useEffect, useImperativeHandle } from "react";
import { useCustomers } from "@/app/dashboard/customers/hooks/useCustomers";
import { ConnectionType } from "@/app/gen/involt/v1/models_pb";
import { CustomerModal } from "@/components/dashboard/CustomerModal";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export interface CustomerTableHandle {
  openNewModal: () => void;
}

interface CustomerTableProps {
  communityId?: string;
  sectorId?: string;
  showActions?: boolean;
  hideHeaderButtons?: boolean;
}

export const CustomerTable = forwardRef<CustomerTableHandle, CustomerTableProps>(
  ({ communityId, sectorId, showActions = true, hideHeaderButtons = false }, ref) => {
    const {
      data,
      pagination,
      setPagination,
      filters,
      setFilters,
      isModalOpen,
      setIsModalOpen,
      isEditing,
      editingCustomer,
      setEditingCustomer,
      saving,
      handleOpenModal,
      handleSave,
      handleDeleteCustomer,
      totalPages,
    } = useCustomers(sectorId);

    // Expose openNewModal to parent
    useImperativeHandle(
      ref,
      () => ({
        openNewModal: () => {
          if (sectorId) {
            handleOpenModal({ sectorId });
          } else {
            const defaultSector = data.sectors.find((s) => s.communityId === communityId);
            handleOpenModal(defaultSector ? { sectorId: defaultSector.id } : null);
          }
        },
      }),
      [data.sectors, communityId, sectorId, handleOpenModal],
    );

    useEffect(() => {
      if (communityId && filters.communityId !== communityId) {
        setFilters((prev) => ({ ...prev, communityId }));
      }
    }, [communityId, filters.communityId, setFilters]);

    useEffect(() => {
      if (sectorId && filters.sectorId !== sectorId) {
        setFilters((prev) => ({ ...prev, sectorId }));
      }
    }, [sectorId, filters.sectorId, setFilters]);

    return (
      <div className="space-y-4">
        <div className="flex flex-col gap-4 md:flex-row md:items-center justify-between">
          {/* Search bar - ALWAYS VISIBLE */}
          <div className="relative group max-w-md w-full">
            <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
            <Input
              placeholder="Buscar por código o nombre..."
              value={filters.searchQuery}
              onChange={(e) =>
                setFilters((prev) => ({
                  ...prev,
                  searchQuery: e.target.value,
                }))
              }
              className="pl-10 h-10 bg-white/5 border-white/5 focus:border-primary/30 rounded-xl transition-all text-sm"
            />
          </div>

          <div className="flex items-center gap-3">
            {/* Header buttons - HIDDEN IF hideHeaderButtons is true */}
            {!hideHeaderButtons && !communityId && (
              <Button
                onClick={() => handleOpenModal()}
                size="sm"
                className="h-10 font-black uppercase tracking-tighter rounded-xl bg-primary text-primary-foreground hover:scale-[1.02] active:scale-[0.98] transition-all"
              >
                <Plus className="w-4 h-4 mr-2" />
                Nuevo Suministro
              </Button>
            )}
            {!hideHeaderButtons && !communityId && (
              <div className="flex items-center gap-2">
                <Filter className="w-4 h-4 text-muted-foreground" />
                <select
                  value={filters.sectorId}
                  onChange={(e) => setFilters((prev) => ({ ...prev, sectorId: e.target.value }))}
                  className="h-10 px-4 bg-white/5 border border-white/5 rounded-xl text-[10px] font-bold uppercase tracking-widest focus:border-primary/30 outline-none transition-all cursor-pointer"
                >
                  <option value="">Todos los Sectores</option>
                  {data.sectors.map((s) => (
                    <option key={s.id} value={s.id}>
                      {s.name}
                    </option>
                  ))}
                </select>
              </div>
            )}
          </div>
        </div>

        <div className="overflow-x-auto rounded-xl border border-white/5">
          <table className="w-full text-left">
            <thead className="bg-white/5">
              <tr className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/60 border-b border-white/5">
                <th className="px-6 py-4">Código</th>
                <th className="px-6 py-4">Cliente</th>
                <th className="px-6 py-4">{communityId ? "Sector" : "Comunidad"}</th>
                <th className="px-6 py-4">Conexión</th>
                {showActions && <th className="px-6 py-4 text-right">Acciones</th>}
              </tr>
            </thead>
            <tbody className="divide-y divide-white/5">
              {data.loading && data.customers.length === 0
                ? [1, 2, 3].map((i) => (
                    <tr key={i} className="animate-pulse">
                      <td colSpan={showActions ? 5 : 4} className="px-6 py-6">
                        <div className="h-4 bg-white/5 rounded w-full" />
                      </td>
                    </tr>
                  ))
                : data.customers.map((c) => (
                    <tr key={c.id} className="group hover:bg-white/2 transition-colors">
                      <td className="px-6 py-4">
                        <span className="font-mono text-[10px] font-bold text-primary/80 bg-primary/5 px-2 py-1 rounded">
                          {c.code}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex flex-col">
                          <span className="font-bold text-sm tracking-tight">{c.name}</span>
                          <span className="text-[9px] opacity-40 uppercase font-medium">
                            {c.address}
                          </span>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className="text-[10px] font-bold uppercase tracking-widest opacity-60">
                          {data.sectors.find((s) => s.id === c.sectorId)?.name || "S/S"}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <span className="text-[9px] font-black uppercase bg-white/5 border border-white/10 px-2 py-1 rounded-md">
                          {ConnectionType[c.connectionType]}
                        </span>
                      </td>
                      {showActions && (
                        <td className="px-6 py-4 text-right">
                          <div className="flex justify-end gap-2">
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleOpenModal(c)}
                              className="w-8 h-8 rounded-lg hover:bg-white/10 transition-colors"
                            >
                              <ArrowUpRight className="w-4 h-4 text-primary" />
                            </Button>
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleDeleteCustomer(c.id)}
                              className="w-8 h-8 rounded-lg hover:bg-red-500/10 text-red-500/40 hover:text-red-500 transition-all"
                            >
                              <Trash2 className="w-4 h-4" />
                            </Button>
                          </div>
                        </td>
                      )}
                    </tr>
                  ))}
            </tbody>
          </table>
        </div>

        {/* Paginator - ALWAYS VISIBLE */}
        <div className="flex items-center justify-between py-2">
          <p className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">
            Total: {data.totalCount} suministros
          </p>
          <div className="flex items-center gap-2">
            <Button
              variant="outline"
              size="icon"
              disabled={pagination.pageNumber === 1}
              onClick={() => setPagination((p) => ({ ...p, pageNumber: p.pageNumber - 1 }))}
              className="w-8 h-8 rounded-lg border-white/10 hover:bg-white/10"
            >
              <ChevronLeft className="w-4 h-4" />
            </Button>
            <span className="text-[10px] font-black uppercase tracking-widest">
              {pagination.pageNumber} / {totalPages || 1}
            </span>
            <Button
              variant="outline"
              size="icon"
              disabled={pagination.pageNumber === totalPages || totalPages === 0}
              onClick={() => setPagination((p) => ({ ...p, pageNumber: p.pageNumber + 1 }))}
              className="w-8 h-8 rounded-lg border-white/10 hover:bg-white/10"
            >
              <ChevronRight className="w-4 h-4" />
            </Button>
          </div>
        </div>

        {/* Reusable Edit/New Customer Modal */}
        <CustomerModal
          isOpen={isModalOpen}
          isEditing={isEditing}
          customer={editingCustomer}
          sectors={data.sectors}
          communityId={communityId}
          saving={saving}
          onClose={() => setIsModalOpen(false)}
          onChange={(cust) => setEditingCustomer(cust)}
          onSave={handleSave}
        />
      </div>
    );
  },
);

CustomerTable.displayName = "CustomerTable";
