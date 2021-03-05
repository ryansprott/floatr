import { Controller } from "stimulus"
import { mapOptions } from "../maps/map_options.js"
import { haversineDistance, svgMarker } from "../maps/index.js"

export default class extends Controller {
  static targets = ["map"]

  connect() {
    if (typeof (google) != "undefined") {
      this.initMap()
    }
  }

  async initMap() {
    let homeMarker = new google.maps.Marker({
      position: new google.maps.LatLng("32.7", "-117.1"),
    });

    this.map = new google.maps.Map(this.mapTarget, mapOptions);

    let resp1 = await fetch(`/live_maps.json`)
    let mapData = await resp1.json()
    let bounds = new google.maps.LatLngBounds();

    mapData.forEach((source) => {
      let poly = new google.maps.Polyline({
        strokeColor: "#FF0000",
        strokeOpacity: 1.0,
        strokeWeight: 1.5,
      });
      let path = poly.getPath();

      let filtered = []
      source.positions.forEach((position) => {
        let pos = new google.maps.LatLng(position.split(",")[0], position.split(",")[1])
        let dx = haversineDistance(homeMarker.position, pos)
        if (dx < 3000.0) {
          filtered.push(pos)
        }
      })

      filtered.forEach((foo) => {
        path.push(foo)
        bounds.extend(foo)
      })

      const shipName = source.source.ship_name || source.source.callsign || source.source.mmsi.toString()

      let mrk = new google.maps.Marker({
        position: filtered[filtered.length - 1],
        map: this.map,
        icon: svgMarker,
        title: shipName,
        label: {
          text: " ",
          color: "orange",
          fontSize: "12px",
        },
      })

      google.maps.event.addListener(mrk, "click", (event) => {
        const lbl = mrk.getLabel()
        lbl.text = mrk.title;
        mrk.setLabel(lbl);
      })

      poly.setMap(this.map);
      homeMarker.setMap(this.map);
    })

    this.map.fitBounds(bounds)
  }
}
