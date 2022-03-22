import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import { svgMarker, homePosition, getLatLng } from "../maps/index.js"
import PositionPair from "../maps/position_pair.js"

export default class extends Controller {
  static targets = ["map"]

  async connect () {
    if (typeof (google) != "undefined") {
      await this.initMap()
    }
  }

  async initMap () {
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
    this.drawFirstAndLastMarkers()
    this.drawPolylines()
  }

  async fetchPositionData () {
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
    })
  }

  drawFirstAndLastMarkers () {
    this.drawMarker(
      this.positionData[0],
      "green"
    )

    this.drawMarker(
      this.positionData[this.positionData.length - 1],
      "red"
    )
  }

  drawMarker (position, fillColor) {
    new google.maps.Marker({
      position: getLatLng(
        position
      ),
      icon: Object.assign(
        {
          scale: 0.15,
          fillColor: fillColor
        },
        svgMarker
      ),
    }).setMap(this.map)
  }

  drawPolylines () {
    this.chunkedPolylines().map((chunk) => {
      chunk.map((pair) => {
        pair.polyline().setMap(this.map)
      })
    })
  }

  chunkedPolylines () {
    let polylines = []
    if (this.positionData.length > 1) {
      let pairs = []
      for (let i = 0; i < this.positionData.length - 1; i++) {
        const pair = new PositionPair
        (
          this.positionData[i],
          this.positionData[i + 1]
        )

        if (pair.hasGap()) {
          polylines.push(pairs)
          pairs = []
          pair.startMarker().setMap(this.map)
          pair.endMarker().setMap(this.map)
        } else {
          pairs.push(pair)
        }

        [
          pair.startPosition(),
          pair.endPosition()
        ].map(position => {
          this.bounds.extend(position)
        })
      }

      polylines.push(pairs)
    } else {
      this.bounds.extend(
        getLatLng(
          this.positionData[0]
        )
      )
    }

    this.map.fitBounds(
      this.bounds
    )

    return polylines
  }

  toggleZoom () {
    this.zoomToggled = !this.zoomToggled
    this.bounds = new google.maps.LatLngBounds()

    for (let position of this.positionData) {
      this.bounds.extend(
        getLatLng(
          position
        )
      )
    }

    if (true === this.zoomToggled) {
      this.bounds.extend(
        this.homePosition
      )
    }

    this.map.fitBounds(
      this.bounds
    )
  }
}
