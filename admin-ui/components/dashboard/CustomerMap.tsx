"use client";

import L from "leaflet";
import { useEffect, useMemo, useState } from "react";
import { MapContainer, Marker, Popup, TileLayer, useMap, ZoomControl } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import type { Customer } from "@/app/gen/involt/v1/models_pb";
import { centerOf, DEFAULT_MAP_CENTER, type LatLng } from "@/lib/geo";
import { useBrand } from "@/lib/hooks/useBrand";
import { adminClient } from "@/lib/rpc";

/** Moves the map once the customers (and so their center) are known. */
function Recenter({ center }: { center: LatLng }) {
  const map = useMap();
  useEffect(() => {
    map.setView(center);
  }, [map, center]);
  return null;
}

export default function CustomerMap() {
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => setMounted(true), 0);

    async function fetchCustomers() {
      try {
        const resp = await adminClient.getCustomers({});
        setCustomers(resp.customers);
      } catch (err) {
        console.error("Failed to fetch customers for map:", err);
      }
    }
    fetchCustomers();
    return () => clearTimeout(timer);
  }, []);

  const brand = useBrand();
  // Centered on the located customers.
  const center = useMemo<LatLng>(() => centerOf(customers) ?? DEFAULT_MAP_CENTER, [customers]);

  // Custom Primary Glow Icon
  const primaryIcon = useMemo(() => {
    if (typeof window === "undefined") return null;
    return L.divIcon({
      className: "custom-div-icon",
      html: `<div style="
        width: 10px; 
        height: 10px; 
        background-color: #FF00FF; 
        border-radius: 50%; 
        box-shadow: 0 0 10px #FF00FF, 0 0 5px #FF00FF inset;
        border: 2px solid white;
      "></div>`,
      iconSize: [10, 10],
      iconAnchor: [5, 5],
    });
  }, []);

  if (!mounted || typeof window === "undefined") {
    return (
      <div className="h-[400px] w-full rounded-4xl bg-white/5 animate-pulse flex items-center justify-center">
        <p className="text-xs font-black uppercase tracking-widest text-muted-foreground">
          Inicializando Mapa...
        </p>
      </div>
    );
  }

  return (
    <div className="h-[400px] w-full rounded-4xl overflow-hidden border border-white/5 shadow-2xl relative group">
      {/* Visual Filters for Dark Mode Aesthetics */}
      <div className="absolute inset-0 z-400 pointer-events-none bg-black/10 mix-blend-overlay border-4 border-black/20" />

      <div className="absolute top-6 left-6 z-1000 flex items-center gap-3">
        <div className="bg-black/80 backdrop-blur-xl px-4 py-2 rounded-2xl border border-white/10 shadow-2xl">
          <div className="flex items-center gap-2">
            <div className="w-2 h-2 rounded-full bg-primary animate-pulse" />
            <p className="text-[10px] font-black uppercase tracking-[0.2em] text-white">
              {brand.name}
            </p>
          </div>
        </div>
      </div>

      <MapContainer
        center={center}
        zoom={15}
        maxZoom={22}
        scrollWheelZoom={true}
        dragging={true}
        zoomControl={false}
        doubleClickZoom={true}
        touchZoom={true}
        className="h-full w-full brightness-[0.8] contrast-[1.1]"
      >
        <ZoomControl position="bottomright" />
        <Recenter center={center} />
        <TileLayer
          attribution="Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community"
          url="https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
          maxZoom={22}
          maxNativeZoom={17}
        />
        {customers.map(
          (customer) =>
            customer.latitude !== 0 &&
            primaryIcon && (
              <Marker
                key={customer.id}
                position={[customer.latitude, customer.longitude]}
                icon={primaryIcon}
              >
                <Popup className="premium-popup">
                  <div className="p-2 bg-black text-white rounded-lg">
                    <p className="font-black uppercase text-[10px] tracking-widest text-primary mb-1">
                      {customer.name}
                    </p>
                    <p className="text-[9px] font-bold text-muted-foreground">
                      CÓDIGO: {customer.code}
                    </p>
                  </div>
                </Popup>
              </Marker>
            ),
        )}
      </MapContainer>
    </div>
  );
}
