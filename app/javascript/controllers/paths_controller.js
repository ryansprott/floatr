import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["map"]

  connect() {
    if (typeof (google) != "undefined") {
      this.initMap()
    }
  }

  async initMap() {
    let resp = await fetch(`/sources/${this.mapTarget.dataset.src}/positions.json`)
    let data = await resp.json()

    this.map = new google.maps.Map(this.mapTarget, {
      zoom: 13,
    })

    let poly = new google.maps.Polyline({
      strokeColor: "#000000",
      strokeOpacity: 1.0,
      strokeWeight: 3,
    });

    let path = poly.getPath();

    data.forEach((el) => {
      let pos = new google.maps.LatLng(el.lat, el.lon)
      path.push(pos)
      // new google.maps.Marker({
      //   position: pos,
      //   map: this.map,
      // })
    })

    this.map.setCenter(path.getAt(parseInt(path.getLength() / 2)))
    poly.setMap(this.map);
  }
}
