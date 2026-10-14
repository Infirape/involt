import { create } from "@bufbuild/protobuf";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { toast } from "sonner";
import { GetCommunitiesRequestSchema, GetSectorsRequestSchema } from "@/app/gen/involt/v1/admin_pb";
import { adminClient } from "@/lib/rpc";
import type { SectorTab } from "../types";

/** Loads communities/sectors once and tracks the selected sector for the matrix sidebar. */
export function useSectors() {
  const [sectors, setSectors] = useState<SectorTab[]>([]);
  const [selectedSectorId, setSelectedSectorId] = useState("");
  const [expandedCommunities, setExpandedCommunities] = useState<Set<string>>(new Set());
  const hasFetched = useRef(false);

  useEffect(() => {
    if (hasFetched.current) return;
    hasFetched.current = true;

    async function loadSectors() {
      try {
        const [communitiesResp, sectorsResp] = await Promise.all([
          adminClient.getCommunities(create(GetCommunitiesRequestSchema, {})),
          adminClient.getSectors(create(GetSectorsRequestSchema, {})),
        ]);
        const communityNames = new Map(communitiesResp.communities.map((c) => [c.id, c.name]));
        const tabs: SectorTab[] = sectorsResp.sectors.map((sector) => ({
          id: sector.id,
          name: sector.name,
          communityId: sector.communityId,
          communityName: communityNames.get(sector.communityId) ?? "Sin comunidad",
        }));
        setSectors(tabs);
        if (tabs.length > 0) {
          setSelectedSectorId(tabs[0].id);
          setExpandedCommunities(new Set([tabs[0].communityId]));
        }
      } catch {
        toast.error("Error al cargar los caseríos");
      }
    }
    void loadSectors();
  }, []);

  const toggleCommunity = useCallback((communityId: string) => {
    setExpandedCommunities((prev) => {
      const next = new Set(prev);
      if (next.has(communityId)) next.delete(communityId);
      else next.add(communityId);
      return next;
    });
  }, []);

  const communitiesWithSectors = useMemo(
    () =>
      sectors.reduce<Record<string, { name: string; sectors: SectorTab[] }>>((acc, s) => {
        if (!acc[s.communityId]) acc[s.communityId] = { name: s.communityName, sectors: [] };
        acc[s.communityId].sectors.push(s);
        return acc;
      }, {}),
    [sectors],
  );

  const selectedSector = sectors.find((s) => s.id === selectedSectorId);

  return {
    selectedSectorId,
    selectSector: setSelectedSectorId,
    selectedSector,
    expandedCommunities,
    toggleCommunity,
    communitiesWithSectors,
  };
}
