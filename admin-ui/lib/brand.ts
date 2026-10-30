/** Brand shown in the panel: the company of the logged-in user, or InVolt by default. */
export interface Brand {
  name: string;
  /** Organisation behind the company (e.g. a municipality); may be empty. */
  entity: string;
  logoUrl: string;
  isDefault: boolean;
}

/** Company as stored with the logged-in user (from the Login response). */
export interface StoredCompany {
  name?: string;
  entity?: string;
  /** Path under the backend's /assets/; empty means the InVolt logo. */
  logo?: string;
}

export const DEFAULT_LOGO_URL = "/assets/logo.png";

export const DEFAULT_BRAND: Brand = {
  name: "InVolt",
  entity: "",
  logoUrl: DEFAULT_LOGO_URL,
  isDefault: true,
};

export function brandFromCompany(
  company: StoredCompany | null | undefined,
  apiBaseUrl: string,
): Brand {
  const name = company?.name?.trim();
  if (!name) return DEFAULT_BRAND;
  const logo = company?.logo?.trim();
  return {
    name,
    entity: company?.entity?.trim() ?? "",
    logoUrl: logo
      ? `${apiBaseUrl.replace(/\/+$/, "")}/assets/${logo.replace(/^\/+/, "")}`
      : DEFAULT_LOGO_URL,
    isDefault: false,
  };
}
