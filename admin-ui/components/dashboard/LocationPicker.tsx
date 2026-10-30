"use client";

import { MapContainer, TileLayer, Marker, useMapEvents } from "react-leaflet";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import { DEFAULT_MAP_CENTER } from "@/lib/geo";

// Fix for default marker icon in Leaflet
const icon = L.icon({
  iconUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
  iconRetinaUrl:
    "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png",
  shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
});

interface LocationPickerProps {
  lat: number;
  lng: number;
  onChange: (lat: number, lng: number) => void;
}

function MapEvents({
  onChange,
}: {
  onChange: (lat: number, lng: number) => void;
}) {
  useMapEvents({
    click(e) {
      onChange(e.latlng.lat, e.latlng.lng);
    },
  });
  return null;
}

export default function LocationPicker({
  lat,
  lng,
  onChange,
}: LocationPickerProps) {
  // Default center when the customer has no location yet
  const centerLat = lat !== 0 ? lat : DEFAULT_MAP_CENTER[0];
  const centerLng = lng !== 0 ? lng : DEFAULT_MAP_CENTER[1];

  return (
    <div className="h-64 w-full rounded-2xl overflow-hidden border border-white/10 relative group">
      <MapContainer
        center={[centerLat, centerLng]}
        zoom={15}
        maxZoom={22}
        className="h-full w-full"
      >
        <TileLayer
          attribution="Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community"
          url="https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
          maxZoom={22}
          maxNativeZoom={17}
        />
        <MapEvents onChange={onChange} />
        {lat !== 0 && lng !== 0 && (
          <Marker
            position={[lat, lng]}
            icon={icon}
            draggable={true}
            eventHandlers={{
              dragend: (e) => {
                const marker = e.target;
                const position = marker.getLatLng();
                onChange(position.lat, position.lng);
              },
            }}
          />
        )}
      </MapContainer>
      <div className="absolute bottom-4 left-4 z-1000 bg-black/80 backdrop-blur-md px-3 py-1.5 rounded-xl border border-white/10 shadow-2xl pointer-events-none">
        <p className="text-[9px] font-black uppercase tracking-widest text-primary">
          Haz click o arrastra el marcador
        </p>
      </div>
    </div>
  );
}
