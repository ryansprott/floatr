import {
  svgMarker,
  colorFromSpeed,
  differenceInHours,
  haversineDistance
} from "../maps/index.js"

export default class PositionPair {
  constructor(el1, el2) {
    this.el1 = el1
    this.el2 = el2
    this.pos1 = new google.maps.LatLng(el1.lat, el1.lon)
    this.pos2 = new google.maps.LatLng(el2.lat, el2.lon)
  }

  hoursBetweenPositions () {
    return differenceInHours(this.pos1.created_at, this.pos2.created_at)
  }

  distanceBetweenPositions () {
    return haversineDistance(this.pos1, this.pos2)
  }

  differenceBetweenDistances () {
    return Math.abs(this.el2.distance - this.el1.distance)
  }

  averageSpeed () {
    return (parseFloat(this.el1.speed) + parseFloat(this.el2.speed)) / 2
  }

  path () {
    return [this.pos1, this.pos2]
  }

  color () {
    return colorFromSpeed(this.el1.speed, this.el2.speed)
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
    return this.marker(this.pos1)
  }

  endMarker () {
    return this.marker(this.pos2)
  }

  isMappable () {
    return this.averageSpeed() > 0.1 ||
    (
      this.distanceBetweenPositions() > 0.1 &&
      this.differenceBetweenDistances() > 0.1
    )
  }
}
