import { create } from "@bufbuild/protobuf";
import { useCallback, useEffect, useMemo, useState, useTransition } from "react";
import { toast } from "sonner";
import {
  ConnectionType,
  type Customer,
  CustomerSchema,
  type Sector,
} from "@/app/gen/involt/v1/models_pb";
import { adminClient } from "@/lib/rpc";

export function useCustomers(initialSectorId = "") {
  const [isPending, startTransition] = useTransition();
  const [data, setData] = useState<{
    customers: Customer[];
    sectors: Sector[];
    totalCount: number;
    loading: boolean;
  }>({
    customers: [],
    sectors: [],
    totalCount: 0,
    loading: true,
  });

  const [pagination, setPagination] = useState({
    pageNumber: 1,
    pageSize: 15,
  });

  const [filters, setFilters] = useState({
    sectorId: initialSectorId,
    searchQuery: "",
    communityId: "",
  });

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isEditing, setIsEditing] = useState(false);
  const [editingCustomer, setEditingCustomer] = useState<Partial<Customer> | null>(null);
  const [saving, setSaving] = useState(false);

  const fetchAll = useCallback(
    async (
      page: number,
      size: number,
      sectorId: string,
      searchQuery: string,
      communityId: string,
    ) => {
      try {
        const [customersResp, sectorsResp] = await Promise.all([
          adminClient.getCustomers({
            sectorId,
            searchQuery,
            pageNumber: page,
            pageSize: size,
            communityId,
          }),
          adminClient.getSectors({}),
        ]);

        startTransition(() => {
          setData({
            customers: customersResp.customers,
            sectors: sectorsResp.sectors,
            totalCount: customersResp.totalCount,
            loading: false,
          });
        });
      } catch (err) {
        console.error("Failed to fetch data:", err);
        startTransition(() => {
          setData((prev) => ({ ...prev, loading: false }));
        });
        toast.error("Error al cargar datos");
      }
    },
    [],
  );

  const { sectorId, searchQuery, communityId } = filters;
  const { pageNumber, pageSize } = pagination;

  useEffect(() => {
    fetchAll(pageNumber, pageSize, sectorId, searchQuery, communityId);
  }, [pageNumber, pageSize, sectorId, searchQuery, communityId, fetchAll]);

  const handleOpenModal = useCallback(
    (customer: Partial<Customer> | null = null) => {
      const isEdit = Boolean(customer?.code);
      setIsEditing(isEdit);

      const defaultCustomer: Partial<Customer> = {
        id: crypto.randomUUID(),
        name: "",
        code: "",
        address: "",
        connectionType: ConnectionType.MONOFASICA,
        sectorId: customer?.sectorId || data.sectors[0]?.id || "",
        latitude: 0,
        longitude: 0,
        initialReading: 0,
      };

      setEditingCustomer({
        ...defaultCustomer,
        ...customer,
      } as Partial<Customer>);
      setIsModalOpen(true);
    },
    [data.sectors],
  );

  const handleSave = useCallback(
    async (e: React.FormEvent) => {
      e.preventDefault();
      if (!editingCustomer) return;
      setSaving(true);
      try {
        const effectiveSectorId = editingCustomer.sectorId || data.sectors[0]?.id || "";
        const selectedSector = data.sectors.find((s) => s.id === effectiveSectorId);

        const customerToSave = create(CustomerSchema, {
          id: editingCustomer.id,
          code: editingCustomer.code,
          name: editingCustomer.name,
          address: editingCustomer.address,
          sectorId: effectiveSectorId,
          communityId: selectedSector?.communityId || "COM-001",
          connectionType: editingCustomer.connectionType,
          latitude: editingCustomer.latitude,
          longitude: editingCustomer.longitude,
          initialReading: editingCustomer.initialReading,
          meterNumber: editingCustomer.meterNumber,
          tariff: editingCustomer.tariff,
          contractStart: editingCustomer.contractStart,
          lastReadingValue: editingCustomer.lastReadingValue,
        });

        await adminClient.upsertCustomer({
          customer: customerToSave,
        });
        toast.success("Cliente guardado correctamente");
        await fetchAll(pageNumber, pageSize, sectorId, searchQuery, communityId);
        setIsModalOpen(false);
      } catch (err) {
        console.error("Failed to save customer:", err);
        toast.error("Error al guardar cliente");
      } finally {
        setSaving(false);
      }
    },
    [
      editingCustomer,
      data.sectors,
      fetchAll,
      pageNumber,
      pageSize,
      sectorId,
      searchQuery,
      communityId,
    ],
  );

  const handleDeleteCustomer = useCallback(
    async (id: string) => {
      if (
        !confirm(
          "¿Estás seguro de que deseas dar de baja este suministro? Esta acción no se puede deshacer.",
        )
      ) {
        return;
      }
      try {
        await adminClient.deleteCustomer({ id });
        toast.success("Suministro dado de baja");
        await fetchAll(pageNumber, pageSize, sectorId, searchQuery, communityId);
      } catch (err) {
        console.error("Failed to delete customer:", err);
        toast.error("Error al eliminar cliente");
      }
    },
    [fetchAll, pageNumber, pageSize, sectorId, searchQuery, communityId],
  );

  const totalPages = useMemo(
    () => Math.ceil(data.totalCount / pageSize),
    [data.totalCount, pageSize],
  );

  return {
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
    isPending,
  };
}
