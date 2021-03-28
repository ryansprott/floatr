import { haversineDistance, homePosition } from "./index.js"

export default class Source {
  constructor(source) {
    this.positions = source.positions
    this.course = source.course
    this.static = source.static
    this.homePosition = homePosition()
  }

  getName() {
    return this.static.ship_name || this.static.callsign || this.static.mmsi.toString()
  }

  getFilteredPositions() {
    return this.positions.filter((el) => {
      if (el) {
        let pos = new google.maps.LatLng(el.latitude, el.longitude)
        return (haversineDistance(this.homePosition, pos) < 3000)
      } else {
        return false
      }
    })
  }

  getFilteredCourse() {
    return this.course.filter((el) => {
      return el !== null
    })
  }
}
