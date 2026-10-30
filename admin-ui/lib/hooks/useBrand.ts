import { useEffect, useState } from "react";
import { type Brand, brandFromCompany, DEFAULT_BRAND } from "@/lib/brand";
import { API_BASE_URL } from "@/lib/utils";

/** Brand of the logged-in user's company (InVolt until it is known). */
export function useBrand(): Brand {
  const [brand, setBrand] = useState<Brand>(DEFAULT_BRAND);

  useEffect(() => {
    try {
      const stored = localStorage.getItem("admin_user");
      const company = stored ? JSON.parse(stored).company : undefined;
      setBrand(brandFromCompany(company, API_BASE_URL));
    } catch {
      setBrand(DEFAULT_BRAND);
    }
  }, []);

  return brand;
}
