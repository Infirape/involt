"use client";

import {
  ChevronDown,
  ChevronRight,
  Edit2,
  FileSpreadsheet,
  MapPin,
  Plus,
  Search,
  Trash2,
  Users,
  X,
} from "lucide-react";
import { useRouter } from "next/navigation";
import { Fragment, useEffect, useRef, useState } from "react";
import { CustomerTable, type CustomerTableHandle } from "@/components/dashboard/CustomerTable";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { useAuth } from "@/lib/hooks/useAuth";
import { CommunityModal } from "./components/CommunityModal";
import { useCommunities } from "./hooks/useCommunities";

export default function CommunitiesPage() {
  const { isAdmin, loading: authLoading } = useAuth();
  const router = useRouter();
  const {
    data,
    isModalOpen,
    setIsModalOpen,
    editingCommunity,
    setEditingCommunity,
    editingSectors,
    addEditingSector,
    updateEditingSectorName,
    removeEditingSector,
    saving,
    searchQuery,
    setSearchQuery,
    handleOpenModal,
    handleSave,
    deleteSector,
    downloadSectorCSV,
  } = useCommunities({
    onSaveSuccess: (newSectors) => {
      if (newSectors.length > 0) {
        setViewingSector(newSectors[0]);
      }
    },
  });

  const [viewingSector, setViewingSector] = useState<{
    id: string;
    name: string;
  } | null>(null);
  const tableRef = useRef<CustomerTableHandle>(null);
  const [expandedCommunities, setExpandedCommunities] = useState<Record<string, boolean>>({});

  const toggleExpand = (communityId: string) => {
    setExpandedCommunities((prev) => ({
      ...prev,
      [communityId]: !prev[communityId],
    }));
  };

  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
      setIsMounted(true);
    }, 0);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    if (isMounted && !authLoading && !isAdmin) {
      router.push("/dashboard");
    }
  }, [isMounted, authLoading, isAdmin, router]);

  if (!isMounted || authLoading || !isAdmin) return null;

  return (
    <div className="p-8 space-y-8 animate-in fade-in duration-700">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="space-y-1">
          <h1 className="text-4xl font-black tracking-tighter uppercase bg-linear-to-br from-white to-white/40 bg-clip-text text-transparent">
            Gestión de Comunidades
          </h1>
          <p className="text-muted-foreground font-medium">
            Administrá los pueblos y caseríos del sistema
          </p>
        </div>
        <Button
          onClick={() => handleOpenModal()}
          className="h-11 font-black uppercase tracking-tighter rounded-xl group transition-all duration-500 hover:shadow-lg hover:shadow-primary/20"
        >
          <Plus className="w-4 h-4 mr-2 transition-transform group-hover:rotate-90" />
          Nueva Comunidad
        </Button>
      </div>

      <Card className="border-white/5 bg-card/20 backdrop-blur-sm shadow-2xl">
        <CardHeader className="pb-4">
          <div className="relative group max-w-md">
            <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
            <Input
              placeholder="Buscar comunidad..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 h-11 bg-white/5 border-white/5 focus:border-primary/30 rounded-xl transition-all"
            />
          </div>
        </CardHeader>
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead className="bg-white/5">
                <tr className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/60 border-b border-white/5">
                  <th className="w-16 px-6 py-4 text-center">Ver</th>
                  <th className="px-6 py-4">Comunidad</th>
                  <th className="px-6 py-4">Suministros</th>
                  <th className="px-6 py-4">ID</th>
                  <th className="px-6 py-4 text-right">Acciones</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {data.loading && data.communities.length === 0 ? (
                  [1, 2, 3].map((i) => (
                    <tr key={`skeleton-${i}`} className="animate-pulse">
                      <td colSpan={5} className="px-6 py-8">
                        <div className="h-4 bg-white/5 rounded w-full" />
                      </td>
                    </tr>
                  ))
                ) : data.communities.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="px-6 py-12 text-center text-muted-foreground italic">
                      No se encontraron comunidades
                    </td>
                  </tr>
                ) : (
                  data.communities.map((c) => (
                    <Fragment key={c.id}>
                      <tr className="group hover:bg-white/2 transition-colors">
                        <td className="px-6 py-4 text-center">
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => toggleExpand(c.id)}
                            className="w-8 h-8 rounded-lg hover:bg-white/10 text-muted-foreground hover:text-primary transition-all duration-300"
                          >
                            {expandedCommunities[c.id] ? (
                              <ChevronDown className="w-4 h-4 text-primary" />
                            ) : (
                              <ChevronRight className="w-4 h-4" />
                            )}
                          </Button>
                        </td>
                        <td className="px-6 py-4">
                          <div className="flex items-center gap-3">
                            <div className="w-10 h-10 rounded-full bg-linear-to-br from-primary/20 to-secondary/20 flex items-center justify-center border border-white/5">
                              <MapPin className="w-5 h-5 text-primary" />
                            </div>
                            <span className="font-bold text-sm tracking-tight">{c.name}</span>
                          </div>
                        </td>
                        <td className="px-6 py-4">
                          <span className="text-xs font-black text-white bg-primary/10 px-2 py-1 rounded border border-primary/20 shadow-[0_0_10px_rgba(255,0,255,0.1)]">
                            {(c.customerCount ?? 0).toLocaleString()}
                          </span>
                        </td>
                        <td className="px-6 py-4">
                          <span className="text-[10px] font-mono text-muted-foreground/40">
                            {c.id}
                          </span>
                        </td>
                        <td className="px-6 py-4 text-right">
                          <div className="flex justify-end gap-2">
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleOpenModal(c)}
                              className="w-8 h-8 rounded-lg hover:bg-white/10 transition-colors"
                              title="Editar Comunidad"
                            >
                              <Edit2 className="w-4 h-4 text-primary" />
                            </Button>
                          </div>
                        </td>
                      </tr>
                      {expandedCommunities[c.id] && (
                        <tr className="bg-white/2">
                          <td colSpan={5} className="px-6 py-4 bg-black/10">
                            <div className="pl-16 pr-6 py-2 space-y-3 animate-in slide-in-from-top-2 duration-300">
                              <h4 className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60">
                                Sectores / Caseríos registrados
                              </h4>
                              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3">
                                {data.sectors
                                  .filter((s) => s.communityId === c.id)
                                  .map((s) => (
                                    <div
                                      key={s.id}
                                      className="flex items-center justify-between p-3 rounded-xl bg-white/5 border border-white/5 hover:border-primary/20 transition-all duration-300 group/sector"
                                    >
                                      <div className="flex flex-col gap-0.5">
                                        <span className="text-xs font-black uppercase tracking-wide text-white/90">
                                          {s.name}
                                        </span>
                                        <span className="text-[10px] font-bold text-muted-foreground/60 uppercase">
                                          {s.customerCount ?? 0} Suministros
                                        </span>
                                      </div>
                                      <div className="flex gap-1">
                                        <Button
                                          variant="ghost"
                                          size="icon"
                                          onClick={() => downloadSectorCSV(s.id, s.name)}
                                          className="w-8 h-8 rounded-lg hover:bg-emerald-500/10 text-emerald-400 opacity-60 hover:opacity-100 transition-all"
                                          title={`Descargar Excel de ${s.name}`}
                                        >
                                          <FileSpreadsheet className="w-4 h-4" />
                                        </Button>
                                        <Button
                                          variant="ghost"
                                          size="icon"
                                          onClick={() =>
                                            setViewingSector({
                                              id: s.id,
                                              name: s.name,
                                            })
                                          }
                                          className="w-8 h-8 rounded-lg hover:bg-cyan-500/10 text-cyan-400 opacity-60 hover:opacity-100 transition-all"
                                          title={`Ver suministros de ${s.name}`}
                                        >
                                          <Users className="w-4 h-4" />
                                        </Button>
                                        <Button
                                          variant="ghost"
                                          size="icon"
                                          onClick={() => deleteSector(s.id)}
                                          className="w-8 h-8 rounded-lg hover:bg-red-500/10 text-red-500/60 hover:text-red-500 transition-all"
                                          title={`Eliminar sector ${s.name}`}
                                        >
                                          <Trash2 className="w-4 h-4" />
                                        </Button>
                                      </div>
                                    </div>
                                  ))}
                                {data.sectors.filter((s) => s.communityId === c.id).length ===
                                  0 && (
                                  <p className="text-xs text-muted-foreground italic col-span-full">
                                    No hay sectores registrados para esta comunidad.
                                  </p>
                                )}
                              </div>
                            </div>
                          </td>
                        </tr>
                      )}
                    </Fragment>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      <CommunityModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        editingCommunity={editingCommunity}
        setEditingCommunity={setEditingCommunity}
        editingSectors={editingSectors}
        addEditingSector={addEditingSector}
        updateEditingSectorName={updateEditingSectorName}
        removeEditingSector={removeEditingSector}
        onSave={handleSave}
        saving={saving}
      />
      {/* View Customers Modal */}
      {viewingSector && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-md animate-in fade-in duration-300">
          <Card className="w-full max-w-5xl border-white/10 bg-card shadow-2xl shadow-cyan-500/10 animate-in zoom-in-95 duration-300 overflow-hidden flex flex-col max-h-[90vh]">
            <div className="p-6 border-b border-white/5 flex items-center justify-between">
              <div className="space-y-1">
                <h2 className="text-2xl font-black uppercase tracking-tighter flex items-center gap-3">
                  <Users className="w-6 h-6 text-cyan-400" />
                  Suministros: {viewingSector.name}
                </h2>
                <p className="text-[10px] text-muted-foreground uppercase tracking-widest font-bold">
                  Gestión de clientes en este caserío
                </p>
              </div>
              <div className="flex items-center gap-3">
                <Button
                  onClick={() => tableRef.current?.openNewModal()}
                  className="h-10 font-black uppercase tracking-tighter rounded-xl bg-cyan-500 text-black hover:bg-cyan-400 transition-all"
                >
                  <Plus className="w-4 h-4 mr-2" />
                  Nuevo Suministro
                </Button>
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() => setViewingSector(null)}
                  className="rounded-full hover:bg-white/10"
                >
                  <X className="w-5 h-5" />
                </Button>
              </div>
            </div>
            <div className="p-8 overflow-y-auto flex-1">
              <CustomerTable ref={tableRef} sectorId={viewingSector.id} hideHeaderButtons />
            </div>
          </Card>
        </div>
      )}
    </div>
  );
}
