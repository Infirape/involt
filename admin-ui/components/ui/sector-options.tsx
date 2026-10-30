"use client";

import { useMemo } from "react";
import { useCommunityNames } from "@/lib/hooks/useCommunityNames";
import { groupSectorsByCommunity, type SectorLike } from "@/lib/sectorGroups";

interface SectorOptionsProps {
  sectors: SectorLike[];
  /** Community id → name when the caller already has it; otherwise it is fetched once. */
  communityNames?: Map<string, string>;
  /** Classes for <option>/<optgroup> (e.g. dark backgrounds on native dropdowns). */
  optionClassName?: string;
}

/** <option>s of a sector <select>, grouped under their community with <optgroup>. */
export function SectorOptions({ sectors, communityNames, optionClassName }: SectorOptionsProps) {
  const fetched = useCommunityNames(!communityNames);
  const names = communityNames ?? fetched;
  const groups = useMemo(() => groupSectorsByCommunity(sectors, names), [sectors, names]);

  return (
    <>
      {groups.map((g) => (
        <optgroup key={g.communityId || "none"} label={g.communityName} className={optionClassName}>
          {g.sectors.map((s) => (
            <option key={s.id} value={s.id} className={optionClassName}>
              {s.name}
            </option>
          ))}
        </optgroup>
      ))}
    </>
  );
}
