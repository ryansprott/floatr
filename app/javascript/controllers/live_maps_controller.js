import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import { haversineDistance, svgMarker, colorFromSpeed } from "../maps/index.js"

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

  async populateMap() {
    let resp1 = await fetch(`/live_maps.json`)
    let mapData = await resp1.json()
    let bounds = new google.maps.LatLngBounds()
    let homePosition = new google.maps.LatLng("32.7", "-117.1")

    for (let source of mapData) {
      let filteredPositions = source.positions.filter((el) => {
        if (el) {
          let pos = new google.maps.LatLng(el.latitude, el.longitude)
          return (haversineDistance(homePosition, pos) < 3000)
        } else {
          return false
        }
      })

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
          let poly = new google.maps.Polyline({
            strokeColor: colorFromSpeed(speed1, speed2),
            strokeOpacity: 1.0,
            strokeWeight: 3.0,
            map: this.map,
            path: [pos1, pos2]
          })
          bounds.extend(pos1)
          poly.setMap(this.map)
        }
        let shipName = source.static.ship_name || source.static.callsign || source.static.mmsi.toString()
        let el = filteredPositions[filteredPositions.length - 1]
        let mrk = new google.maps.Marker({
          position: new google.maps.LatLng(el.latitude, el.longitude),
          map: this.map,
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

      }
    }
    this.map.fitBounds(bounds)
  }
}
