import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import { svgMarker } from "../maps/marker.js"

export default class extends Controller {
  static targets = ["map"]

  connect() {
    if (typeof (google) != "undefined") {
      this.initMap()
    }
  }

  initMap() {
    this.map = new google.maps.Map(this.mapTarget, mapOptions)
    this.map.setTilt(0)
    this.populateMap()
  }

  async drawPolyline() {
    let resp = await fetch(`/sources/${this.mapTarget.dataset.src}/positions.json`)
    let positionData = await resp.json()

    let poly = new google.maps.Polyline({
      strokeColor: "#FF0000",
      strokeOpacity: 1.0,
      strokeWeight: 1.5,
    })
    let path = poly.getPath()
    let bounds = new google.maps.LatLngBounds()

    positionData.forEach((el) => {
      if (el.lat && el.lon) {
        let pos = new google.maps.LatLng(el.lat, el.lon)
        path.push(pos)
        bounds.extend(pos)
      }
    })

    let lastSeen = positionData.pop()
    let marker = new google.maps.Marker({
      position: new google.maps.LatLng(lastSeen.lat, lastSeen.lon),
      icon: svgMarker,
    })

    this.map.fitBounds(bounds)
    poly.setMap(this.map)
    marker.setMap(this.map)
  }

  async drawHeatmap() {
    let resp = await fetch(`/sources/${this.mapTarget.dataset.src}/heatmaps.json`)
    let heatmapData = await resp.json()
    let heatmap = new google.maps.visualization.HeatmapLayer({
      data: heatmapData.map((el) => {
        return {
          weight: el.weight,
          location: new google.maps.LatLng(el.lat, el.lon),
        }
      }),
      opacity: 0.5,
      radius: 8,
    })
    heatmap.setMap(this.map)
  }

  async populateMap() {
    await this.drawPolyline()
    await this.drawHeatmap()
  }
}
