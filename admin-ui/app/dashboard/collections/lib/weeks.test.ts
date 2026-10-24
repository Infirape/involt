import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { currentWeek, previousWeek } from "./weeks.ts";

describe("treasury weeks (Monday to Sunday)", () => {
  it("current week runs from Monday up to today", () => {
    assert.deepEqual(currentWeek("2026-10-24"), { from: "2026-10-19", to: "2026-10-24" }); // Saturday
    assert.deepEqual(currentWeek("2026-10-19"), { from: "2026-10-19", to: "2026-10-19" }); // Monday
    assert.deepEqual(currentWeek("2026-10-25"), { from: "2026-10-19", to: "2026-10-25" }); // Sunday
  });

  it("previous week is the full Monday-to-Sunday before, across months and years", () => {
    assert.deepEqual(previousWeek("2026-10-24"), { from: "2026-10-12", to: "2026-10-18" });
    assert.deepEqual(previousWeek("2026-10-01"), { from: "2026-09-21", to: "2026-09-27" });
    assert.deepEqual(previousWeek("2027-01-05"), { from: "2026-12-28", to: "2027-01-03" });
  });
});
