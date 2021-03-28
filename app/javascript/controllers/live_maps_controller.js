import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import { haversineDistance, svgMarker, colorFromSpeed } from "../maps/index.js"

export default class extends Controller {
  static targets = ["map"]

  async connect() {
    if (typeof (google) != "undefined") {
      await this.initMap()
    }
  }

  async populateSources() {
    let resp = await fetch(`/live_maps.json`)
    let data = await resp.json()
    this.sources = []
    for (let item of data) {
      this.sources.push(item)
    }
    this.refreshMap()
  }

  async initMap() {
    this.sources = []
    this.markers = []
    this.polylines = []
    this.zoomToggled = false
    this.map = new google.maps.Map(this.mapTarget, mapOptions)
    this.map.setTilt(0)
    this.homePosition = new google.maps.LatLng("32.7", "-117.1")
    this.map.setCenter(this.homePosition)
    this.map.setZoom(12)

    await this.populateSources()
    setInterval(async () => {
      await this.populateSources()
    }, 10000);
  }

  showOnMap(element) {
    element.setMap(this.map)
  }

  removeFromMap(element) {
    element.setMap(null)
  }

  refreshMap() {
    this.markers.map(el => this.removeFromMap(el))
    this.markers = []

    this.polylines.map(el => this.removeFromMap(el))
    this.polylines = []

    for (let source of this.sources) {
      let filteredPositions = this.filterPositions(source.positions)

      let filteredCourses = source.course.filter((el) => {
        return el !== null
      })

      if (filteredPositions.length > 1) {
        for (let i = 0; i < filteredPositions.length - 1; i++) {
          let el1 = filteredPositions[i]
          let el2 = filteredPositions[i + 1]
          let pos1 = new google.maps.LatLng(el1.latitude, el1.longitude)
          let pos2 = new google.maps.LatLng(el2.latitude, el2.longitude)
          let speed1 = filteredCourses[i].speed_over_ground
          let speed2 = filteredCourses[i + 1].speed_over_ground
          this.polylines.push(new google.maps.Polyline({
            strokeColor: colorFromSpeed(speed1, speed2),
            strokeOpacity: 1.0,
            strokeWeight: 3.0,
            path: [pos1, pos2]
          }))
        }

        let shipName = source.static.ship_name || source.static.callsign || source.static.mmsi.toString()
        let lastPosition = filteredPositions.pop()
        let mrk = new google.maps.Marker({
          position: new google.maps.LatLng(lastPosition.latitude, lastPosition.longitude),
          icon: Object.assign({ scale: 0.075 }, svgMarker),
          title: shipName,
          label: {
            text: " ",
            color: "lavender",
            fontSize: "14px",
            fontWeight: "bold",
          },
        })
        google.maps.event.addListener(mrk, "click", (event) => {
          let lbl = mrk.getLabel()
          lbl.text = mrk.title
          mrk.setLabel(lbl)
        })
        this.markers.push(mrk)
      }

      this.markers.map(el => this.showOnMap(el))
      this.polylines.map(el => this.showOnMap(el))
    }
  }

  toggleZoom() {
    this.zoomToggled = !this.zoomToggled
    this.bounds = new google.maps.LatLngBounds()
    for (let source of this.sources) {
      for (let position of this.filterPositions(source.positions)) {
        this.bounds.extend(new google.maps.LatLng(position.latitude, position.longitude))
      }
    }
    if (true === this.zoomToggled) {
      this.map.fitBounds(this.bounds)
    } else {
      this.map.setCenter(this.homePosition)
      this.map.setZoom(12)
    }
  }

  filterPositions(positions) {
    return positions.filter((el) => {
      if (el) {
        let pos = new google.maps.LatLng(el.latitude, el.longitude)
        return (haversineDistance(this.homePosition, pos) < 3000)
      } else {
        return false
      }
    })
  }
}
