import { useEffect, useState } from "react";
import { adminClient } from "@/lib/rpc";

// Communities rarely change: one request per page load, shared by every dropdown.
let cached: Promise<Map<string, string>> | null = null;

function loadCommunityNames(): Promise<Map<string, string>> {
  cached ??= adminClient
    .getCommunities({})
    .then((resp) => new Map(resp.communities.map((c) => [c.id, c.name])))
    .catch((err: unknown) => {
      cached = null; // retry on the next mount
      throw err;
    });
  return cached;
}

/** Community id → name. Skips the request when `enabled` is false (names given by the caller). */
export function useCommunityNames(enabled = true): Map<string, string> {
  const [names, setNames] = useState<Map<string, string>>(() => new Map());
  useEffect(() => {
    if (!enabled) return;
    let alive = true;
    loadCommunityNames()
      .then((m) => {
        if (alive) setNames(m);
      })
      .catch(() => {
        // Without names the sectors still list, grouped as "Sin comunidad".
      });
    return () => {
      alive = false;
    };
  }, [enabled]);
  return names;
}
