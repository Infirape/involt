import { create } from "@bufbuild/protobuf";
import { useCallback, useEffect, useState, useTransition } from "react";
import { toast } from "sonner";
import {
  type Community,
  CommunitySchema,
  type Sector,
  SectorSchema,
} from "@/app/gen/involt/v1/models_pb";
import { adminClient } from "@/lib/rpc";

export type SectorWithCount = Sector & { customerCount?: number };

export function useCommunities(options?: {
  onSaveSuccess?: (newSectors: { id: string; name: string }[]) => void;
}) {
  const [, startTransition] = useTransition();
  const [data, setData] = useState<{
    communities: Community[];
    sectors: SectorWithCount[];
    loading: boolean;
  }>({
    communities: [],
    sectors: [],
    loading: true,
  });

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingCommunity, setEditingCommunity] = useState<Community | null>(null);
  const [editingSectors, setEditingSectors] = useState<Sector[]>([]);
  const [saving, setSaving] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");

  const loadData = useCallback(async () => {
    try {
      const [commResp, sectResp, statsResp] = await Promise.all([
        adminClient.getCommunities({}),
        adminClient.getSectors({}),
        adminClient.getDashboardStats({}),
      ]);

      const sectorStatsMap = new Map<string, number>();
      if (statsResp.sectorStats) {
        for (const stat of statsResp.sectorStats) {
          sectorStatsMap.set(stat.sectorId, stat.totalCount);
        }
      }

      const sectorsWithCount: SectorWithCount[] = sectResp.sectors.map((s) => {
        return Object.assign(create(SectorSchema, s), {
          customerCount: sectorStatsMap.get(s.id) || 0,
        });
      });

      startTransition(() => {
        setData({
          communities: commResp.communities,
          sectors: sectorsWithCount,
          loading: false,
        });
      });
    } catch (error) {
      console.error("Error loading communities:", error);
      toast.error("Error al cargar comunidades");
      startTransition(() => {
        setData((prev) => ({ ...prev, loading: false }));
      });
    }
  }, []);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const handleOpenModal = (community?: Community) => {
    if (community) {
      setEditingCommunity(create(CommunitySchema, community));
      const communitySectors = data.sectors
        .filter((s) => s.communityId === community.id)
        .map((s) => create(SectorSchema, s));
      setEditingSectors(communitySectors);
    } else {
      setEditingCommunity(
        create(CommunitySchema, {
          name: "",
        }),
      );
      setEditingSectors([]);
    }
    setIsModalOpen(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingCommunity) return;

    if (!editingCommunity.name) {
      toast.error("El nombre es requerido");
      return;
    }

    setSaving(true);
    try {
      const resp = await adminClient.upsertCommunity({
        community: editingCommunity,
      });
      const savedCommunityId = resp.community?.id || editingCommunity.id;

      const newlyCreatedSectors: { id: string; name: string }[] = [];

      // Delete any removed sectors
      for (const sectorId of deletedSectorIds) {
        try {
          await adminClient.deleteSector({ id: sectorId });
        } catch (err) {
          console.error("Error deleting sector:", err);
        }
      }
      setDeletedSectorIds([]);

      // Save all editing sectors
      for (const s of editingSectors) {
        if (!s.name.trim()) continue;
        const sectorToSave = create(SectorSchema, {
          ...s,
          communityId: savedCommunityId,
        });
        const sectorResp = await adminClient.upsertSector({ sector: sectorToSave });
        if (!s.id && sectorResp.sector) {
          newlyCreatedSectors.push({ id: sectorResp.sector.id, name: sectorResp.sector.name });
        }
      }

      toast.success(editingCommunity.id ? "Comunidad actualizada" : "Comunidad creada");
      setIsModalOpen(false);
      await loadData();

      if (newlyCreatedSectors.length > 0) {
        options?.onSaveSuccess?.(newlyCreatedSectors);
      }
    } catch (error) {
      console.error("Error saving community:", error);
      toast.error("Error al guardar la comunidad");
    } finally {
      setSaving(false);
    }
  };

  const addEditingSector = () => {
    setEditingSectors((prev) => [
      ...prev,
      create(SectorSchema, {
        id: "",
        communityId: editingCommunity?.id || "",
        name: "",
      }),
    ]);
  };

  const updateEditingSectorName = (index: number, name: string) => {
    setEditingSectors((prev) =>
      prev.map((s, idx) => (idx === index ? create(SectorSchema, { ...s, name }) : s)),
    );
  };

  const [deletedSectorIds, setDeletedSectorIds] = useState<string[]>([]);

  const removeEditingSector = (index: number) => {
    const target = editingSectors[index];
    if (target?.id) {
      setDeletedSectorIds((prev) => [...prev, target.id]);
    }
    setEditingSectors((prev) => prev.filter((_, idx) => idx !== index));
  };

  const deleteSector = async (sectorId: string) => {
    if (
      !confirm(
        "¿Estás seguro de que deseas eliminar este sector? Esta acción no se puede deshacer.",
      )
    ) {
      return;
    }
    try {
      await adminClient.deleteSector({ id: sectorId });
      toast.success("Sector eliminado correctamente");
      await loadData();
    } catch (error) {
      console.error("Error deleting sector:", error);
      toast.error("Error al eliminar el sector");
    }
  };

  const downloadSectorCSV = async (sectorId: string, sectorName: string) => {
    const toastId = toast.loading("Generando archivo CSV...");
    try {
      const resp = await adminClient.getCustomers({
        sectorId,
        pageSize: 1000,
      });
      const customers = resp.customers || [];

      const headers = [
        "Código",
        "Nombre/Razón Social",
        "Dirección",
        "Medidor",
        "Lectura Inicial",
        "Última Lectura",
        "Tarifa",
        "Coordenadas",
      ];

      const rows = customers.map((c) => [
        c.code,
        c.name,
        c.address,
        c.meterNumber || "-",
        c.initialReading.toString(),
        c.lastReadingValue !== undefined ? c.lastReadingValue.toString() : "-",
        c.tariff || "-",
        c.latitude && c.longitude ? `${c.latitude}, ${c.longitude}` : "-",
      ]);

      const csvContent = [
        headers.join(","),
        ...rows.map((row) => row.map((val) => `"${String(val).replace(/"/g, '""')}"`).join(",")),
      ].join("\n");

      const blob = new Blob([`\uFEFF${csvContent}`], {
        type: "text/csv;charset=utf-8;",
      });
      const url = URL.createObjectURL(blob);

      const link = document.createElement("a");
      link.href = url;
      const sanitizedSectorName = sectorName.replace(/[^a-zA-Z0-9]/g, "_").toUpperCase();
      link.setAttribute("download", `Suministros_${sanitizedSectorName}.csv`);
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);

      toast.success("CSV descargado correctamente", { id: toastId });
    } catch (err) {
      console.error("Error downloading CSV:", err);
      toast.error("Error al descargar CSV", { id: toastId });
    }
  };

  const filteredCommunities = data.communities.filter((c) =>
    c.name.toLowerCase().includes(searchQuery.toLowerCase()),
  );

  return {
    data: { ...data, communities: filteredCommunities },
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
    refresh: loadData,
  };
}
