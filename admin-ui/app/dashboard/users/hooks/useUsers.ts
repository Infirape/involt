import { useCallback, useEffect, useState, useTransition } from "react";
import { toast } from "sonner";
import { type User as AdminUser, UserRole } from "@/app/gen/involt/v1/admin_pb";
import type { Sector } from "@/app/gen/involt/v1/models_pb";
import { adminClient } from "@/lib/rpc";
import { generateUUID } from "@/lib/utils";

export function useUsers() {
  const [isPending, startTransition] = useTransition();
  const [data, setData] = useState<{
    users: AdminUser[];
    sectors: Sector[];
    loading: boolean;
  }>({
    users: [],
    sectors: [],
    loading: true,
  });

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<Partial<AdminUser> | null>(null);
  const [saving, setSaving] = useState(false);
  const [password, setPassword] = useState("");

  const fetchData = useCallback(async () => {
    try {
      const [usersResp, sectorsResp] = await Promise.all([
        adminClient.getUsers({}),
        adminClient.getSectors({}),
      ]);

      startTransition(() => {
        setData({
          users: usersResp.users,
          sectors: sectorsResp.sectors,
          loading: false,
        });
      });
    } catch (err) {
      console.error("Failed to fetch data:", err);
      startTransition(() => {
        setData((prev) => ({ ...prev, loading: false }));
      });
      toast.error("Error al cargar usuarios");
    }
  }, []);

  useEffect(() => {
    let isMounted = true;
    const init = async () => {
      await fetchData();
      if (!isMounted) return;
    };
    init();
    return () => {
      isMounted = false;
    };
  }, [fetchData]);

  const handleOpenModal = useCallback((user: Partial<AdminUser> | null = null) => {
    setEditingUser(
      user || {
        id: generateUUID(),
        email: "",
        role: UserRole.READER,
        assignedSectorIds: [],
      },
    );
    setPassword("");
    setIsModalOpen(true);
  }, []);

  const handleSave = useCallback(
    async (e: React.FormEvent) => {
      e.preventDefault();
      if (!editingUser) return;
      setSaving(true);
      try {
        await adminClient.upsertUser({
          user: editingUser as AdminUser,
          password: password,
        });
        toast.success("Usuario guardado correctamente");
        await fetchData();
        setIsModalOpen(false);
      } catch (err) {
        console.error("Failed to save user:", err);
        toast.error("Error al guardar usuario");
      } finally {
        setSaving(false);
      }
    },
    [editingUser, password, fetchData],
  );

  const toggleSector = useCallback((sectorId: string) => {
    setEditingUser((prev) => {
      if (!prev) return null;
      const sectors = prev.assignedSectorIds || [];
      const newSectors = sectors.includes(sectorId)
        ? sectors.filter((id) => id !== sectorId)
        : [...sectors, sectorId];
      return { ...prev, assignedSectorIds: newSectors };
    });
  }, []);

  return {
    data,
    isModalOpen,
    setIsModalOpen,
    editingUser,
    setEditingUser,
    saving,
    password,
    setPassword,
    handleOpenModal,
    handleSave,
    toggleSector,
    isPending,
  };
}
