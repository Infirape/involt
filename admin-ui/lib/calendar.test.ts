import assert from "node:assert/strict";
import { describe, it } from "node:test";
import {
  formatDateEs,
  formatMonthEs,
  isWithin,
  monthGrid,
  parseIsoDate,
  shiftMonth,
  toIsoDate,
  toIsoMonth,
} from "./calendar.ts";

describe("parseIsoDate / toIsoDate", () => {
  it("round-trips valid dates and rejects invalid ones", () => {
    assert.deepEqual(parseIsoDate("2026-10-13"), { year: 2026, month: 10, day: 13 });
    assert.equal(toIsoDate(2026, 1, 5), "2026-01-05");
    assert.equal(parseIsoDate("2026-02-30"), null);
    assert.equal(parseIsoDate("13/10/2026"), null);
    assert.equal(parseIsoDate(""), null);
  });
});

describe("monthGrid", () => {
  it("builds Monday-first weeks padded with nulls", () => {
    // October 2026 starts on a Thursday and has 31 days.
    const grid = monthGrid(2026, 10);
    assert.deepEqual(grid[0], [null, null, null, 1, 2, 3, 4]);
    assert.deepEqual(grid[grid.length - 1], [26, 27, 28, 29, 30, 31, null]);
    assert.equal(grid.length, 5);
  });

  it("handles months starting on Sunday and leap Februaries", () => {
    assert.deepEqual(monthGrid(2026, 3)[0], [null, null, null, null, null, null, 1]);
    const feb = monthGrid(2028, 2)
      .flat()
      .filter((d) => d !== null);
    assert.equal(feb.length, 29);
  });
});

describe("shiftMonth", () => {
  it("wraps across years", () => {
    assert.deepEqual(shiftMonth(2026, 12, 1), { year: 2027, month: 1 });
    assert.deepEqual(shiftMonth(2026, 1, -1), { year: 2025, month: 12 });
  });
});

describe("Spanish formatting", () => {
  it("formats dates and months in Spanish", () => {
    assert.equal(formatDateEs("2026-10-03"), "03/10/2026");
    assert.equal(formatMonthEs("2026-09"), "Septiembre 2026");
    assert.equal(toIsoMonth(2026, 3), "2026-03");
    assert.equal(formatDateEs(""), "");
  });
});

describe("isWithin", () => {
  it("compares ISO strings against optional bounds", () => {
    assert.equal(isWithin("2026-10-13", "2026-10-01", "2026-10-31"), true);
    assert.equal(isWithin("2026-11-01", undefined, "2026-10-31"), false);
    assert.equal(isWithin("2026-09-30", "2026-10-01"), false);
    assert.equal(isWithin("2026-10", "2026-01", "2026-12"), true);
  });
});
