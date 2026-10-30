import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { COLLECTIONS_FIRST_PERIOD, defaultFromPeriod, earliestPeriod } from "./periods.ts";

describe("collections period floor", () => {
  it("starts in September 2026", () => {
    assert.equal(COLLECTIONS_FIRST_PERIOD, "2026-09");
  });

  it("defaults to the last 12 months, never before the floor", () => {
    assert.equal(defaultFromPeriod("2026-10"), "2026-09");
    assert.equal(defaultFromPeriod("2027-08"), "2026-09");
    assert.equal(defaultFromPeriod("2027-12"), "2027-01");
  });

  it("clamps a lower bound to the floor", () => {
    assert.equal(earliestPeriod(), "2026-09");
    assert.equal(earliestPeriod(""), "2026-09");
    assert.equal(earliestPeriod("2026-03"), "2026-09");
    assert.equal(earliestPeriod("2026-11"), "2026-11");
  });
});
