export const svgMarker = {
  path: "M 0, 0 m -75, 0 a 75,75 0 1,0 150,0 a 75,75 0 1,0 -150,0",
  strokeColor: "green",
  strokeOpacity: 0.75,
  strokeWeight: 0.5,
  // fillColor: "red",
  fillOpacity: 0.75,
  fillWeight: 1,
  rotation: 0,
}

export function homePosition() {
  return new google.maps.LatLng("32.7", "-117.1")
}

export function haversineDistance(mk1, mk2) {
  let d = 0.0
  try {
    const R = 3958.8; // Radius of the Earth in miles
    const rlat1 = mk1.lat() * (Math.PI / 180); // Convert degrees to radians
    const rlat2 = mk2.lat() * (Math.PI / 180); // Convert degrees to radians
    const difflat = rlat2 - rlat1; // Radian difference (latitudes)
    const difflon = (mk2.lng() - mk1.lng()) * (Math.PI / 180); // Radian difference (longitudes)
    d = 2 * R * Math.asin(Math.sqrt(Math.sin(difflat / 2) * Math.sin(difflat / 2) + Math.cos(rlat1) * Math.cos(rlat2) * Math.sin(difflon / 2) * Math.sin(difflon / 2)));
  } catch (e) {
    return undefined;
  }
  return d;
}

export function colorFromSpeed(speed1, speed2) {
  let speed = (parseFloat(speed1) + parseFloat(speed2)) / 2.0
  if (speed > 17.0) {
    return "#f94144"
  } else if (speed <= 17.0 && speed > 15.0) {
    return "#f3722c"
  } else if (speed <= 15.0 && speed > 13.0) {
    return "#f8961e"
  } else if (speed <= 13.0 && speed > 11.0) {
    return "#f9844a"
  } else if (speed <= 11.0 && speed > 9.0) {
    return "#f9c74f"
  } else if (speed <= 9.0 && speed > 7.0) {
    return "#90be6d"
  } else if (speed <= 7.0 && speed > 5.0) {
    return "#43aa8b"
  } else if (speed <= 5.0 && speed > 3.0) {
    return "#4d908e"
  } else if (speed <= 3.0 && speed > 2.0) {
    return "#577590"
  } else {
    return "#277da1"
  }
}
