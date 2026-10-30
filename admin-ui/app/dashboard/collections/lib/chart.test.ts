import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { formatSolesCompact, niceTicks } from "./chart.ts";

describe("niceTicks", () => {
  it("rounds the axis max up to a 1/2/5 step and returns evenly spaced ticks", () => {
    assert.deepEqual(niceTicks(87), [0, 20, 40, 60, 80, 100]);
    assert.deepEqual(niceTicks(1234), [0, 500, 1000, 1500]);
    assert.deepEqual(niceTicks(4.2), [0, 1, 2, 3, 4, 5]);
  });

  it("never returns a zero-height axis", () => {
    assert.deepEqual(niceTicks(0), [0, 1]);
  });
});

describe("formatSolesCompact", () => {
  it("abbreviates thousands for axis labels", () => {
    assert.equal(formatSolesCompact(0), "S/ 0");
    assert.equal(formatSolesCompact(850), "S/ 850");
    assert.equal(formatSolesCompact(1500), "S/ 1.5k");
    assert.equal(formatSolesCompact(12000), "S/ 12k");
  });
});
