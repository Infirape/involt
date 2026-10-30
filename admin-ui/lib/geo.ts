export type LatLng = [number, number];

/** Map center used before any located customer is known (Lima, Perú). */
export const DEFAULT_MAP_CENTER: LatLng = [-12.0464, -77.0428];

/** Average position of the points with coordinates; null when none has them. */
export function centerOf(points: { latitude: number; longitude: number }[]): LatLng | null {
  const located = points.filter((p) => p.latitude !== 0 && p.longitude !== 0);
  if (located.length === 0) return null;
  const lat = located.reduce((sum, p) => sum + p.latitude, 0) / located.length;
  const lng = located.reduce((sum, p) => sum + p.longitude, 0) / located.length;
  return [lat, lng];
}
