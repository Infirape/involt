import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { collectionRate, formatSoles, limaToday, parseAmount, sumAmounts } from "./money.ts";

describe("sumAmounts", () => {
  it("adds in cents to avoid float drift", () => {
    assert.equal(sumAmounts([0.1, 0.2]), 0.3);
    assert.equal(sumAmounts([10, 12.5, 0.01]), 22.51);
    assert.equal(sumAmounts([]), 0);
  });
});

describe("formatSoles", () => {
  it("formats with two decimals and thousands separator", () => {
    assert.equal(formatSoles(12.5), "S/ 12.50");
    assert.equal(formatSoles(1234.5), "S/ 1,234.50");
    assert.equal(formatSoles(0), "S/ 0.00");
  });
});

describe("parseAmount", () => {
  it("accepts dot or comma decimals and rejects junk", () => {
    assert.equal(parseAmount("12.5"), 12.5);
    assert.equal(parseAmount("12,50"), 12.5);
    assert.equal(parseAmount(" 7 "), 7);
    assert.equal(parseAmount("12.345"), null);
    assert.equal(parseAmount("abc"), null);
    assert.equal(parseAmount("-3"), null);
    assert.equal(parseAmount(""), null);
  });
});

describe("collectionRate", () => {
  it("returns the collected percentage rounded to one decimal", () => {
    assert.equal(collectionRate(200, 150), 75);
    assert.equal(collectionRate(3, 1), 33.3);
    assert.equal(collectionRate(0, 0), 0);
  });
});

describe("limaToday", () => {
  it("uses Lima's calendar day (UTC-5)", () => {
    assert.equal(limaToday(new Date("2026-10-14T03:00:00Z")), "2026-10-13");
    assert.equal(limaToday(new Date("2026-10-14T06:00:00Z")), "2026-10-14");
  });
});
