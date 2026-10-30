import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { brandFromCompany, DEFAULT_BRAND, DEFAULT_LOGO_URL } from "./brand.ts";

describe("brandFromCompany", () => {
  it("uses the company name, entity and backend logo", () => {
    const brand = brandFromCompany(
      { name: "Acme Energía", entity: "Municipalidad Acme", logo: "companies/acme.png" },
      "http://api.test/",
    );
    assert.deepEqual(brand, {
      name: "Acme Energía",
      entity: "Municipalidad Acme",
      logoUrl: "http://api.test/assets/companies/acme.png",
      isDefault: false,
    });
  });

  it("falls back to the InVolt logo when the company has none", () => {
    const brand = brandFromCompany({ name: "Acme" }, "http://api.test");
    assert.equal(brand.logoUrl, DEFAULT_LOGO_URL);
    assert.equal(brand.entity, "");
  });

  it("is InVolt without a company", () => {
    assert.equal(brandFromCompany(undefined, "http://api.test"), DEFAULT_BRAND);
    assert.equal(brandFromCompany(null, "http://api.test"), DEFAULT_BRAND);
    assert.equal(brandFromCompany({ name: "  " }, "http://api.test"), DEFAULT_BRAND);
  });
});
