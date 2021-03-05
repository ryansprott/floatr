import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import { haversineDistance, svgMarker } from "../maps/index.js"

let heatmap = null;

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
    let bounds = new google.maps.LatLngBounds()

    positionData = positionData.filter((el) => {
      if (el.lat && el.lon) {
        let home = new google.maps.LatLng("32.7", "-117.1")
        let pos = new google.maps.LatLng(el.lat, el.lon)
        return haversineDistance(home, pos) < 3000
      } else {
        return false
      }
    })

    if (positionData.length > 1) {
      for (let i = 0; i < positionData.length - 1; i++) {
        let el1 = positionData[i]
        let el2 = positionData[i + 1]
        let pos1 = new google.maps.LatLng(el1.lat, el1.lon)
        let pos2 = new google.maps.LatLng(el2.lat, el2.lon)
        let poly = new google.maps.Polyline({
          strokeColor: this.colorFromSpeed(el1.speed, el2.speed),
          strokeOpacity: 1.0,
          strokeWeight: 3.0,
          map: this.map,
          path: [ pos1, pos2 ]
        })
        bounds.extend(pos1)
        poly.setMap(this.map)
      }
    }

    let lastSeen = positionData.pop()
    let marker = new google.maps.Marker({
      position: new google.maps.LatLng(lastSeen.lat, lastSeen.lon),
      icon: svgMarker,
    })
    this.map.fitBounds(bounds)
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
      opacity: 0.5,
      radius: 8,
    })
  }

  populateMap() {
    this.drawPolyline()
    this.drawHeatmap()
  }

  toggleHeatmap() {
    let target = heatmap.map ? null : this.map
    heatmap.setMap(target)
  }

  colorFromSpeed(speed1, speed2) {
    let speed = (parseFloat(speed1) + parseFloat(speed2)) / 2.0

    if (speed > 20.0) {
      return "#FF0000"
    } else if (speed <= 20.0 && speed > 10.0) {
      return "#FFA500"
    } else if (speed <= 10.0 && speed > 5.0) {
      return "#FFFF00"
    } else if (speed <= 5.0 && speed > 3.0) {
      return "#008000"
    } else {
      return "#0000FF"
    }
  }


}
