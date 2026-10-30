"use client";

import Image from "next/image";
import { useState } from "react";
import { type Brand, DEFAULT_LOGO_URL } from "@/lib/brand";

interface BrandLogoProps {
  brand: Brand;
  width: number;
  height: number;
  className?: string;
  priority?: boolean;
}

/** Company logo served by the backend; falls back to the InVolt logo if it fails to load. */
export function BrandLogo({ brand, width, height, className, priority }: BrandLogoProps) {
  const [failed, setFailed] = useState<string | null>(null);
  const src = failed === brand.logoUrl ? DEFAULT_LOGO_URL : brand.logoUrl;

  return (
    <Image
      src={src}
      alt={brand.entity || brand.name}
      width={width}
      height={height}
      priority={priority}
      unoptimized
      onError={() => setFailed(brand.logoUrl)}
      className={className}
    />
  );
}
