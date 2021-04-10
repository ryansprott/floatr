import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import { svgMarker, colorFromSpeed, homePosition } from "../maps/index.js"
import Source from "../maps/source.js"

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
      this.sources.push(new Source(item))
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
    this.homePosition = homePosition()
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
      let filteredPositions = source.getFilteredPositions()

      if (filteredPositions.length > 1) {
        for (let i = 0; i < filteredPositions.length - 1; i++) {
          let el1 = filteredPositions[i]
          let el2 = filteredPositions[i + 1]
          let pos1 = new google.maps.LatLng(el1.lat, el1.lon)
          let pos2 = new google.maps.LatLng(el2.lat, el2.lon)
          this.polylines.push(new google.maps.Polyline({
            strokeColor: colorFromSpeed(el1.speed, el2.speed),
            strokeOpacity: 1.0,
            strokeWeight: 3.0,
            path: [pos1, pos2]
          }))
        }
        let lastPosition = filteredPositions.pop()
        let mrk = new google.maps.Marker({
          position: new google.maps.LatLng(lastPosition.lat, lastPosition.lon),
          icon: Object.assign({ scale: 0.06 }, svgMarker),
          title: source.getName(),
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
      for (let position of source.getFilteredPositions()) {
        this.bounds.extend(new google.maps.LatLng(position.lat, position.lon))
      }
    }
    if (true === this.zoomToggled) {
      this.map.fitBounds(this.bounds)
    } else {
      this.map.setCenter(this.homePosition)
      this.map.setZoom(12)
    }
  }
}
