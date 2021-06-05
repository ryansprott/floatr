export default class Source {
  constructor(source) {
    this.positions = source.positions
    this.displayName = source.displayName
  }

  getFilteredPositions() {
    return this.positions.filter((position) => {
      return (position && position.lat && position.lon) ? position.distance > 0.0 : false
    })
  }

  getMaxDistance() {
    return Math.max(...this.getFilteredPositions().map(position => position.distance))
  }

  getMinDistance() {
    return Math.min(...this.getFilteredPositions().map(position => position.distance))
  }

  getAverageSpeed() {
    const sum = this.getFilteredPositions().reduce((acc, position) => acc + parseFloat(position.speed), 0)
    const avg = sum / this.getFilteredPositions().length
    return Math.round(avg * 100) / 100 || 0
  }

  getAverageCourse() {
    const sum = this.getFilteredPositions().reduce((acc, position) => acc + parseFloat(position.course), 0)
    const avg = sum / this.getFilteredPositions().length
    return Math.round(avg * 100) / 100 || 0
  }
}
