import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import { svgMarker, homePosition } from "../maps/index.js"
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
    this.drawMarkers()
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

  getLatLng (position) {
    return new google.maps.LatLng(
      position.lat,
      position.lon
    )
  }

  drawMarkers () {
    let firstSeen = new google.maps.Marker({
      position: this.getLatLng(
        this.positionData[0]
      ),
      icon: Object.assign(
        {
          scale: 0.25,
          fillColor: "green"
        },
        svgMarker
      ),
    })

    firstSeen.setMap(this.map)

    let lastSeen = new google.maps.Marker({
      position: this.getLatLng(
        this.positionData[this.positionData.length - 1]
      ),
      icon: Object.assign(
        {
          scale: 0.25,
          fillColor: "red"
        },
        svgMarker
      ),
    })

    lastSeen.setMap(this.map)
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

        const gapInPolylines = pair.distanceBetweenPositions() > 5.0 ||
          (
            pair.hoursBetweenPositions() > 1 &&
            pair.distanceBetweenPositions() > 0.5
          )

        if (gapInPolylines) {
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
        this.getLatLng(
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
        this.getLatLng(
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
