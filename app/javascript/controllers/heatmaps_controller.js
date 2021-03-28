import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import { haversineDistance, svgMarker, colorFromSpeed } from "../maps/index.js"

let heatmap = null;

export default class extends Controller {
  static targets = ["map"]

  async connect() {
    if (typeof (google) != "undefined") {
      await this.initMap()
    }
  }

  async initMap() {
    this.map = new google.maps.Map(this.mapTarget, mapOptions)
    this.map.setTilt(0)
    this.positionData = []
    this.zoomToggled = false
    this.bounds = new google.maps.LatLngBounds()
    this.home = new google.maps.LatLng("32.7", "-117.1")

    await this.populateMap()
  }

  async drawPolyline() {
    let resp = await fetch(`/sources/${this.mapTarget.dataset.src}/positions.json`)
    this.positionData = await resp.json()

    this.positionData = this.positionData.filter((el) => {
      if (el.lat && el.lon) {
        let pos = new google.maps.LatLng(el.lat, el.lon)
        return haversineDistance(this.home, pos) < 3000
      } else {
        return false
      }
    })

    if (this.positionData.length > 1) {
      for (let i = 0; i < this.positionData.length - 1; i++) {
        let el1 = this.positionData[i]
        let el2 = this.positionData[i + 1]
        let pos1 = new google.maps.LatLng(el1.lat, el1.lon)
        let pos2 = new google.maps.LatLng(el2.lat, el2.lon)
        let poly = new google.maps.Polyline({
          strokeColor: colorFromSpeed(el1.speed, el2.speed),
          strokeOpacity: 1.0,
          strokeWeight: 3.0,
          map: this.map,
          path: [pos1, pos2]
        })
        this.bounds.extend(pos1)
        poly.setMap(this.map)
      }
    } else {
      this.bounds.extend(new google.maps.LatLng(this.positionData[0].lat, this.positionData[0].lon))
    }
    this.map.fitBounds(this.bounds)

    let lastSeen = this.positionData.pop()
    let marker = new google.maps.Marker({
      position: new google.maps.LatLng(lastSeen.lat, lastSeen.lon),
      icon: Object.assign({ scale: 0.15 }, svgMarker),
    })
    marker.setMap(this.map)
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

  async populateMap() {
    await this.drawPolyline()
    await this.drawHeatmap()
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
      this.bounds.extend(this.home)
    }
    this.map.fitBounds(this.bounds)
  }
}
