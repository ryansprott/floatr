import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import {
  svgMarker,
  colorFromSpeed,
  haversineDistance,
  homePosition
} from "../maps/index.js"

let heatmap = null;

export default class extends Controller {
  static targets = ["map"]

  async connect() {
    if (typeof (google) != "undefined") {
      await this.initMap()
    }
  }

  async initMap() {
    this.map = new google.maps.Map(
      this.mapTarget,
      mapOptions
    )
    this.map.setTilt(0)
    this.positionData = []
    this.zoomToggled = false
    this.bounds = new google.maps.LatLngBounds()
    this.homePosition = homePosition()

    await this.drawPolyline()
  }

  async drawPolyline() {
    let resp = await fetch(
      `/sources/${this.mapTarget.dataset.src}/positions.json`
    )
    this.positionData = await resp.json()

    this.positionData = this.positionData.filter((el) => {
      return el.lat && el.lon
    })

    let polylines = []

    if (this.positionData.length > 1) {
      let latLngPair = []

      let firstSeen = new google.maps.Marker({
        position: new google.maps.LatLng(
          this.positionData[0].lat,
          this.positionData[0].lon
        ),
        icon: Object.assign({ scale: 0.25, fillColor: "green" }, svgMarker),
      })
      firstSeen.setMap(this.map)

      for (let i = 0; i < this.positionData.length - 1; i++) {
        let el1 = this.positionData[i]
        let el2 = this.positionData[i + 1]
        let pos1 = new google.maps.LatLng(el1.lat, el1.lon)
        let pos2 = new google.maps.LatLng(el2.lat, el2.lon)

        if (haversineDistance(pos1, pos2) > 1.0) {
          polylines.push(latLngPair)
          latLngPair = []

          // const dist1 = haversineDistance(this.homePosition, pos1)
          // const dist2 = haversineDistance(this.homePosition, pos2)

          let signalLost = new google.maps.Marker({
            position: pos1,
            icon: Object.assign({ scale: 0.05, fillColor: "red" }, svgMarker),
          })
          let signalFound = new google.maps.Marker({
            position: pos2,
            icon: Object.assign({ scale: 0.05, fillColor: "red" }, svgMarker),
          })
          signalLost.setMap(this.map)
          signalFound.setMap(this.map)
        } else {
          latLngPair.push({
            positions: [pos1, pos2],
            speeds: [el1.speed, el2.speed]
          })
        }

        this.bounds.extend(pos1)
      }
      polylines.push(latLngPair)
    } else {
      this.bounds.extend(new google.maps.LatLng(this.positionData[0].lat, this.positionData[0].lon))
    }

    polylines.map((chunk) => {
      chunk.map((pair) => {
        let poly = new google.maps.Polyline({
          strokeColor: colorFromSpeed(pair.speeds[0], pair.speeds[1]),
          strokeOpacity: 1.0,
          strokeWeight: 3.0,
          map: this.map,
          path: pair.positions
        })
        poly.setMap(this.map)
      })
    })

    let lastSeen = this.positionData.pop()
    let marker = new google.maps.Marker({
      position: new google.maps.LatLng(lastSeen.lat, lastSeen.lon),
      icon: Object.assign({ scale: 0.25, fillColor: "red" }, svgMarker),
    })
    marker.setMap(this.map)

    this.map.fitBounds(this.bounds)
  }

  async drawHeatmap() {
    let resp = await fetch(`/sources/${this.mapTarget.dataset.src}/heatmaps.json`)
    let heatmapData = await resp.json()
    heatmap = new google.maps.visualization.HeatmapLayer({
      data: heatmapData.map((el) => {
        return {
          weight: el.weight,
          location: new google.maps.LatLng(el.lat, el.lon),
        }
      }),
      opacity: 0.75,
    })
  }

  toggleHeatmap() {
    let target = heatmap.map ? null : this.map
    heatmap.setMap(target)
  }

  toggleZoom() {
    this.zoomToggled = !this.zoomToggled
    this.bounds = new google.maps.LatLngBounds()
    for (let el1 of this.positionData) {
      let pos1 = new google.maps.LatLng(el1.lat, el1.lon)
      this.bounds.extend(pos1)
    }
    if (true === this.zoomToggled) {
      this.bounds.extend(this.homePosition)
    }
    this.map.fitBounds(this.bounds)
  }
}
