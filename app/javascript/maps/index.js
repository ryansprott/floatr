export const svgMarker = {
  path: "M 0, 0 m -75, 0 a 75,75 0 1,0 150,0 a 75,75 0 1,0 -150,0",
  strokeColor: "red",
  strokeOpacity: 1,
  strokeWeight: 1,
  fillColor: "red",
  fillOpacity: 0.5,
  fillWeight: 1,
  rotation: 0,
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

export function colorFromSpeed(speed1, speed2) {
  let speed = (parseFloat(speed1) + parseFloat(speed2)) / 2.0
  if (speed > 15.0) {
    return "#FF0000"
  } else if (speed <= 15.0 && speed > 10.0) {
    return "#FFA500"
  } else if (speed <= 10.0 && speed > 5.0) {
    return "#FFFF00"
  } else if (speed <= 5.0 && speed > 3.0) {
    return "#008000"
  } else {
    return "#0000FF"
  }
}
