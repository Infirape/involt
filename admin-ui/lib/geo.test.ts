import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { centerOf } from "./geo.ts";

describe("centerOf", () => {
  it("averages the located points and skips the ones without coordinates", () => {
    assert.deepEqual(
      centerOf([
        { latitude: -7, longitude: -78 },
        { latitude: 0, longitude: 0 },
        { latitude: -8, longitude: -79 },
      ]),
      [-7.5, -78.5],
    );
  });

  it("is null when nothing is located", () => {
    assert.equal(centerOf([]), null);
    assert.equal(centerOf([{ latitude: 0, longitude: 0 }]), null);
  });
});
