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
    this.sources = data.map(item => new Source(item))
    this.refreshMap()
    this.populateTable()
  }

  populateTable() {
    const tbl = document.getElementById('live-summary')
    tbl.innerHTML = ''
    for (let source of this.sources.sort((a, b) => b.getMaxDistance() - a.getMaxDistance())) {
      let filteredPositions = source.getFilteredPositions()
      if (filteredPositions.length > 0) {
        const tr = document.createElement('tr')
        const displayName = document.createElement('td')
        const link = document.createElement('a')
        const linkText = document.createTextNode(source.displayName)

        link.setAttribute('href', `/sources/${source.id}`)
        link.setAttribute('target', '_blank')
        link.appendChild(linkText)
        displayName.appendChild(link)
        tr.appendChild(displayName)

        const flag = document.createElement('td')
        flag.innerHTML = source.flag
        tr.appendChild(flag)

        const max = document.createElement('td')
        max.innerHTML = source.getMaxDistance()
        tr.appendChild(max)

        const averageCourse = document.createElement('td')
        averageCourse.innerHTML = source.getLastCourse()
        tr.appendChild(averageCourse)

        const averageSpeed = document.createElement('td')
        averageSpeed.innerHTML = source.getAverageSpeed()
        tr.appendChild(averageSpeed)

        tbl.appendChild(tr)
      }
    }
  }

  async initMap() {
    this.sources = []
    this.markers = []
    this.polylines = []
    this.zoomToggled = false
    this.homePosition = homePosition()

    this.map = new google.maps.Map(this.mapTarget, mapOptions)
    this.map.setCenter(this.homePosition)
    this.map.setTilt(0)
    this.map.setZoom(12)

    await this.populateSources()

    setInterval(async () => {
      await this.populateSources()
    }, 60000);
  }

  showOnMap(element) {
    element.setMap(this.map)
  }

  removeFromMap(element) {
    element.setMap(null)
  }

  hideMarkers() {
    this.markers.map(el => this.removeFromMap(el))
  }

  showMarkers() {
    this.markers.map(el => this.showOnMap(el))
  }

  clearMarkers() {
    this.markers = []
  }

  hidePolylines() {
    this.polylines.map(el => this.removeFromMap(el))
  }

  showPolylines() {
    this.polylines.map(el => this.showOnMap(el))
  }

  clearPolylines() {
    this.polylines = []
  }

  refreshMap() {
    this.hideMarkers()
    this.clearMarkers()
    this.hidePolylines()
    this.clearPolylines()

    for (let source of this.sources) {
      let filteredPositions = source.getFilteredPositions()

      if (filteredPositions.length > 0) {
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
          icon: Object.assign({ fillColor: "red", scale: 0.06 }, svgMarker),
          title: source.displayName,
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

      this.showMarkers()
      this.showPolylines()
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
