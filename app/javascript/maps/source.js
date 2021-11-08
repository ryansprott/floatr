export default class Source {
  constructor(source) {
    this.id = source.id
    this.displayName = source.displayName
    this.positions = source.positions
    this.flag = source.flag
  }

  getFilteredPositions() {
    const output = this.positions.filter((position) => {
      return (position && position.lat && position.lon) ? position.distance > 0.0 : false
    })
    return output.length > 1 ? output : []
  }

  getLastPosition () {
    const pos = this.getFilteredPositions().pop()
    return new google.maps.LatLng(pos.lat, pos.lon)
  }

  getMaxDistance() {
    return Math.max(...this.getFilteredPositions().map(position => position.distance))
  }

  getAverageSpeed() {
    const sum = this.getFilteredPositions().reduce((acc, position) => acc + parseFloat(position.speed), 0)
    const avg = sum / this.getFilteredPositions().length
    return Math.round(avg * 100) / 100 || "STOP"
  }

  getLastCourse() {
    const pos = this.getFilteredPositions().filter(el => el.course !== null).pop()
    return pos ? pos.course : "NONE"
  }
}
