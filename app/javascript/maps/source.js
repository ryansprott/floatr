import { homePosition } from "./index.js"

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
      return (el && el.lat && el.lon) ? el.distance > 0.0 : false
    })
  }

  getFilteredCourse() {
    return this.course.filter((el) => {
      return el !== null
    })
  }
}
