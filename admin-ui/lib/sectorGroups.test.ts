import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { groupSectorsByCommunity } from "./sectorGroups.ts";

describe("groupSectorsByCommunity", () => {
  const names = new Map([
    ["c2", "San Pablo"],
    ["c1", "Chetilla"],
  ]);

  it("groups by community name, communities and sectors alphabetically", () => {
    const groups = groupSectorsByCommunity(
      [
        { id: "s1", name: "TUBO", communityId: "c1" },
        { id: "s2", name: "Alto", communityId: "c2" },
        { id: "s3", name: "CADENA", communityId: "c1" },
      ],
      names,
    );
    assert.deepEqual(
      groups.map((g) => [g.communityName, g.sectors.map((s) => s.name)]),
      [
        ["Chetilla", ["CADENA", "TUBO"]],
        ["San Pablo", ["Alto"]],
      ],
    );
  });

  it("puts sectors without a known community last", () => {
    const groups = groupSectorsByCommunity(
      [
        { id: "s1", name: "Huerfano", communityId: "" },
        { id: "s2", name: "Otro", communityId: "gone" },
        { id: "s3", name: "CADENA", communityId: "c1" },
      ],
      names,
    );
    assert.deepEqual(
      groups.map((g) => g.communityName),
      ["Chetilla", "Sin comunidad"],
    );
    assert.equal(groups[1].sectors.length, 2);
  });
});
