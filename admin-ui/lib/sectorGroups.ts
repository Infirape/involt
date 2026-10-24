// Groups sectors (caseríos) under their community for grouped dropdowns.

export interface SectorLike {
  id: string;
  name: string;
  communityId: string;
}

export interface SectorGroup<S extends SectorLike> {
  communityId: string;
  communityName: string;
  sectors: S[];
}

export const NO_COMMUNITY = "Sin comunidad";

const byName = (a: { name: string }, b: { name: string }) =>
  a.name.localeCompare(b.name, "es", { sensitivity: "base" });

/** Communities alphabetically (unknown ones last as "Sin comunidad"), sectors alphabetically. */
export function groupSectorsByCommunity<S extends SectorLike>(
  sectors: S[],
  communityNames: Map<string, string>,
): SectorGroup<S>[] {
  const groups = new Map<string, SectorGroup<S>>();
  for (const s of sectors) {
    const name = communityNames.get(s.communityId);
    const key = name ? s.communityId : "";
    let group = groups.get(key);
    if (!group) {
      group = { communityId: key, communityName: name ?? NO_COMMUNITY, sectors: [] };
      groups.set(key, group);
    }
    group.sectors.push(s);
  }
  const list = [...groups.values()];
  for (const g of list) g.sectors.sort(byName);
  return list.sort((a, b) => {
    if (!a.communityId !== !b.communityId) return a.communityId ? -1 : 1;
    return a.communityName.localeCompare(b.communityName, "es", { sensitivity: "base" });
  });
}
