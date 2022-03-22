export const svgMarker = {
  path: "M 0, 0 m -75, 0 a 75,75 0 1,0 150,0 a 75,75 0 1,0 -150,0",
  strokeColor: "green",
  strokeOpacity: 0.75,
  strokeWeight: 0.5,
  fillOpacity: 0.75,
  fillWeight: 1,
  rotation: 0,
}

export function homePosition() {
  return new google.maps.LatLng("32.7", "-117.1")
}

export function getLatLng (position) {
  return new google.maps.LatLng(
    position.lat,
    position.lon
  )
}
