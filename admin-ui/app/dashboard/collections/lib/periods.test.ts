import assert from "node:assert/strict";
import { describe, it } from "node:test";
import {
  COLLECTIONS_FIRST_PERIOD,
  clampSemester,
  defaultFromPeriod,
  earliestPeriod,
  isFirstSemester,
  semesterMonths,
  visiblePeriods,
} from "./periods.ts";

describe("collections period floor", () => {
  it("hides periods before the floor from filters", () => {
    const periods = [{ id: "2026-10" }, { id: "2026-09" }, { id: "2026-08" }, { id: "2026-03" }];
    assert.deepEqual(visiblePeriods(periods), [{ id: "2026-10" }, { id: "2026-09" }]);
  });

  it("leaves out months before the floor from a semester", () => {
    assert.deepEqual(semesterMonths(2026, "H2"), ["2026-09", "2026-10", "2026-11", "2026-12"]);
    assert.deepEqual(semesterMonths(2026, "H1"), []);
    assert.equal(semesterMonths(2027, "H1").length, 6);
  });

  it("moves a semester before the floor up to the first one", () => {
    assert.deepEqual(clampSemester(2026, "H1"), { year: 2026, half: "H2" });
    assert.deepEqual(clampSemester(2025, "H2"), { year: 2026, half: "H2" });
    assert.deepEqual(clampSemester(2026, "H2"), { year: 2026, half: "H2" });
    assert.deepEqual(clampSemester(2027, "H1"), { year: 2027, half: "H1" });
  });

  it("knows the earliest semester", () => {
    assert.equal(isFirstSemester(2026, "H2"), true);
    assert.equal(isFirstSemester(2027, "H1"), false);
  });

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
