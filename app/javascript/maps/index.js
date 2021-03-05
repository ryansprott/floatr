export const svgMarker = {
  path: "M 0, 0 m -75, 0 a 75,75 0 1,0 150,0 a 75,75 0 1,0 -150,0",
  strokeColor: "red",
  strokeOpacity: 1,
  strokeWeight: 5,
  fillColor: "red",
  fillOpacity: 0.25,
  fillWeight: 1,
  rotation: 0,
  scale: 0.2,
}

export function haversineDistance(mk1, mk2) {
  const R = 3958.8; // Radius of the Earth in miles
  const rlat1 = mk1.lat() * (Math.PI / 180); // Convert degrees to radians
  const rlat2 = mk2.lat() * (Math.PI / 180); // Convert degrees to radians
  const difflat = rlat2 - rlat1; // Radian difference (latitudes)
  const difflon = (mk2.lng() - mk1.lng()) * (Math.PI / 180); // Radian difference (longitudes)
  const d = 2 * R * Math.asin(Math.sqrt(Math.sin(difflat / 2) * Math.sin(difflat / 2) + Math.cos(rlat1) * Math.cos(rlat2) * Math.sin(difflon / 2) * Math.sin(difflon / 2)));
  return d;
}
