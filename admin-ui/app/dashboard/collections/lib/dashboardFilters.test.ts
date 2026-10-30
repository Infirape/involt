import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { EMPTY_DASHBOARD_FILTERS, parseStoredFilters } from "./dashboardFilters.ts";

describe("parseStoredFilters", () => {
  it("restores a saved selection", () => {
    const saved = { fromPeriod: "2026-09", toPeriod: "2026-10", communityId: "c1", sectorId: "s1" };
    assert.deepEqual(parseStoredFilters(JSON.stringify(saved)), saved);
  });

  it("falls back to defaults for missing or corrupt storage", () => {
    assert.deepEqual(parseStoredFilters(null), EMPTY_DASHBOARD_FILTERS);
    assert.deepEqual(parseStoredFilters("{not json"), EMPTY_DASHBOARD_FILTERS);
    assert.deepEqual(parseStoredFilters("[1,2]"), EMPTY_DASHBOARD_FILTERS);
  });

  it("drops months before the floor, malformed months and inverted ranges", () => {
    const parse = (v: object) => parseStoredFilters(JSON.stringify(v));
    assert.equal(parse({ fromPeriod: "2026-03" }).fromPeriod, "");
    assert.equal(parse({ toPeriod: "2026-8" }).toPeriod, "");
    assert.deepEqual(parse({ fromPeriod: "2026-11", toPeriod: "2026-10" }), {
      ...EMPTY_DASHBOARD_FILTERS,
      fromPeriod: "2026-11",
    });
  });

  it("ignores non-string values", () => {
    assert.equal(parseStoredFilters(JSON.stringify({ communityId: 7 })).communityId, "");
  });
});
