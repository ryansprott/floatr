import {
  svgMarker, getLatLng
} from "../maps/index.js"

export default class PositionPair {
  constructor(el1, el2) {
    this.el1 = el1
    this.el2 = el2
    this.pos1 = getLatLng(el1)
    this.pos2 = getLatLng(el2)
  }

  startPosition () {
    return this.pos1
  }

  endPosition () {
    return this.pos2
  }

  hoursBetweenPositions () {
    return this.differenceInHours(
      this.startPosition().created_at,
      this.endPosition().created_at
    )
  }

  distanceBetweenPositions () {
    return this.haversineDistance(
      this.startPosition(),
      this.endPosition()
    )
  }

  differenceBetweenDistances () {
    return Math.abs(
      this.el2.distance - this.el1.distance
    )
  }

  averageSpeed () {
    return (
      parseFloat(this.el1.speed) + parseFloat(this.el2.speed)
    ) / 2
  }

  path () {
    return [
      this.startPosition(),
      this.endPosition()
    ]
  }

  color () {
    return this.colorFromSpeed(
      this.el1.speed,
      this.el2.speed
    )
  }

  polyline () {
    return new google.maps.Polyline({
      strokeColor: this.color(),
      strokeOpacity: 1.0,
      strokeWeight: 3.0,
      path: this.path()
    })
  }

  marker (pos) {
    return new google.maps.Marker({
      position: pos,
      icon: Object.assign(
        { scale: 0.05, fillColor: "red" },
        svgMarker
      ),
    })
  }

  startMarker () {
    return this.marker(this.startPosition())
  }

  endMarker () {
    return this.marker(this.endPosition())
  }

  isMappable () {
    return this.averageSpeed() > 0.1 ||
    (
      this.distanceBetweenPositions() > 0.1 &&
      this.differenceBetweenDistances() > 0.1
    )
  }

  hasGap () {
    return this.distanceBetweenPositions() > 5.0 ||
      (
        this.hoursBetweenPositions() > 1 &&
        this.distanceBetweenPositions() > 0.5
      )
  }

  haversineDistance(mk1, mk2) {
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

  differenceInHours(datetime1, datetime2) {
    return Math.floor(((new Date(datetime2) - new Date(datetime1)) % 86400000) / 3600000);
  }

  colorFromSpeed(speed1, speed2) {
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
}
