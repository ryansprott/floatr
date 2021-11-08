import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import {
  svgMarker,
  colorFromSpeed,
  homePosition
} from "../maps/index.js"
import PositionPair from "../maps/position_pair.js"

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
    this.homePosition = homePosition()
    this.bounds = new google.maps.LatLngBounds()
    await this.fetchPositionData()
    this.drawPolylines()
  }

  async fetchPositionData() {
    const resp = await fetch(
      `/sources/${this.mapTarget.dataset.src}/positions.json`
    )
    const json = await resp.json()
    this.positionData = json.filter((position) => {
      return (
        !!position.lat &&
        !!position.lon &&
        !!position.distance
      ) && position.distance > 0.0
    }).map((position) => {
      return Object.assign(
        {
          latlng: new google.maps.LatLng
          (
            position.lat,
            position.lon
          )
        },
        position
      )
    })
  }

  drawPolylines() {
    let firstPosition = this.positionData[0]
    let firstSeen = new google.maps.Marker({
      position: firstPosition.latlng,
      icon: Object.assign(
        { scale: 0.25, fillColor: "green" },
        svgMarker
      ),
    })
    firstSeen.setMap(this.map)

    let lastPosition = this.positionData[this.positionData.length - 1]
    let lastSeen = new google.maps.Marker({
      position: lastPosition.latlng,
      icon: Object.assign(
        { scale: 0.25, fillColor: "red" },
        svgMarker
      ),
    })
    lastSeen.setMap(this.map)

    let polylines = []
    if (this.positionData.length > 1) {
      let latLngPair = []

      for (let i = 0; i < this.positionData.length - 1; i++) {
        let pos1 = this.positionData[i]
        let pos2 = this.positionData[i + 1]

        const pair = new PositionPair(pos1, pos2)

        if (
          (
            pair.hoursBetweenPositions() > 1 &&
            pair.distanceBetweenPositions() > 0.5
          ) ||
          pair.distanceBetweenPositions() > 5.0
        ) {
          polylines.push(latLngPair)
          latLngPair = []
          let signalLost = pair.startMarker()
          let signalFound = pair.endMarker()
          signalLost.setMap(this.map)
          signalFound.setMap(this.map)
        } else {
          latLngPair.push({
            positions: pair.path(),
            speeds: [
              pos1.speed,
              pos2.speed
            ]
          })
        }

        this.bounds.extend(pos1.latlng)
        this.bounds.extend(pos2.latlng)
      }
      polylines.push(latLngPair)
    } else {
      this.bounds.extend(firstPosition.latlng)
    }

    this.map.fitBounds(this.bounds)

    polylines.map((chunk) => {
      chunk.map((pair) => {
        let poly = new google.maps.Polyline({
          strokeColor: colorFromSpeed(
            pair.speeds[0],
            pair.speeds[1]
          ),
          strokeOpacity: 1.0,
          strokeWeight: 3.0,
          map: this.map,
          path: pair.positions
        })
        poly.setMap(this.map)
      })
    })

  }

  toggleZoom() {
    this.zoomToggled = !this.zoomToggled
    this.bounds = new google.maps.LatLngBounds()
    for (let position of this.positionData) {
      this.bounds.extend(position.latlng)
    }
    if (true === this.zoomToggled) {
      this.bounds.extend(this.homePosition)
    }
    this.map.fitBounds(this.bounds)
  }
}
