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
    let homeMarker = new google.maps.Marker({
      position: homePosition,
      map: this.map,
    })

    for (let source of mapData) {
      let poly = new google.maps.Polyline({
        strokeColor: "#FF0000",
        strokeOpacity: 1.0,
        strokeWeight: 1.0,
      })

      let path = poly.getPath()

      let filteredPositions = source.positions.filter((el) => {
        return el !== ""
      }).map((el) => {
        let pos = new google.maps.LatLng(el.split(",")[0], el.split(",")[1])
        return (haversineDistance(homePosition, pos) < 3000) ? pos : null
      })

      for (let position of filteredPositions) {
        if (position) {
          path.push(position)
          bounds.extend(position)
        }
      }

      let shipName = source.source.ship_name || source.source.callsign || source.source.mmsi.toString()
      let mrk = new google.maps.Marker({
        position: filteredPositions[filteredPositions.length - 1],
        map: this.map,
        icon: Object.assign({ fillColor: "chartreuse", scale: 0.05 }, svgMarker),
        title: shipName,
        label: {
          text: " ",
          color: "orange",
          fontSize: "24px",
        },
      })
      google.maps.event.addListener(mrk, "click", (event) => {
        let lbl = mrk.getLabel()
        lbl.text = mrk.title
        mrk.setLabel(lbl)
      })

      poly.setMap(this.map)
    }
    this.map.fitBounds(bounds)
  }
}
