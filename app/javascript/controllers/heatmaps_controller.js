import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["map"]

  connect() {
    if (typeof (google) != "undefined") {
      this.initMap()
    }
  }

  async initMap() {
    let resp = await fetch(`/sources/${this.mapTarget.dataset.src}/heatmaps.json`)
    let data = await resp.json()
    let heatmapData = data.map((el) => {
      return {
        weight: el.weight,
        location: new google.maps.LatLng(el.lat, el.lon),
      }
    })

    this.map = new google.maps.Map(this.mapTarget, {
      center: heatmapData[parseInt(heatmapData.length / 2)].location,
      zoom: 13,
    })

    let heatmap = new google.maps.visualization.HeatmapLayer({
      data: heatmapData,
      opacity: 1.0
    })

    heatmap.setMap(this.map);
  }
}
