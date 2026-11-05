import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { hidesDebtUnderCut } from "./cutCell.ts";

describe("hidesDebtUnderCut", () => {
  it("hides what a customer under a temporary cut still owes", () => {
    assert.equal(hidesDebtUnderCut(true, 10), true);
  });

  it("keeps paid receipts and active customers as they are", () => {
    assert.equal(hidesDebtUnderCut(true, 0), false);
    assert.equal(hidesDebtUnderCut(false, 10), false);
  });
});
