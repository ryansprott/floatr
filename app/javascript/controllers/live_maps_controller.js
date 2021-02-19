import { Controller } from "stimulus"

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

    this.map = new google.maps.Map(this.mapTarget, {
      styles: [
        { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
        { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
        { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
        {
          featureType: "administrative.locality",
          elementType: "labels.text.fill",
          stylers: [{ color: "#d59563" }],
        },
        {
          featureType: "poi",
          elementType: "labels.text.fill",
          stylers: [{ color: "#d59563" }],
        },
        {
          featureType: "poi.park",
          elementType: "geometry",
          stylers: [{ color: "#263c3f" }],
        },
        {
          featureType: "poi.park",
          elementType: "labels.text.fill",
          stylers: [{ color: "#6b9a76" }],
        },
        {
          featureType: "road",
          elementType: "geometry",
          stylers: [{ color: "#38414e" }],
        },
        {
          featureType: "road",
          elementType: "geometry.stroke",
          stylers: [{ color: "#212a37" }],
        },
        {
          featureType: "road",
          elementType: "labels.text.fill",
          stylers: [{ color: "#9ca5b3" }],
        },
        {
          featureType: "road.highway",
          elementType: "geometry",
          stylers: [{ color: "#746855" }],
        },
        {
          featureType: "road.highway",
          elementType: "geometry.stroke",
          stylers: [{ color: "#1f2835" }],
        },
        {
          featureType: "road.highway",
          elementType: "labels.text.fill",
          stylers: [{ color: "#f3d19c" }],
        },
        {
          featureType: "transit",
          elementType: "geometry",
          stylers: [{ color: "#2f3948" }],
        },
        {
          featureType: "transit.station",
          elementType: "labels.text.fill",
          stylers: [{ color: "#d59563" }],
        },
        {
          featureType: "water",
          elementType: "geometry",
          stylers: [{ color: "#17263c" }],
        },
        {
          featureType: "water",
          elementType: "labels.text.fill",
          stylers: [{ color: "#515c6d" }],
        },
        {
          featureType: "water",
          elementType: "labels.text.stroke",
          stylers: [{ color: "#17263c" }],
        },
      ],
    });

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
        let dx = this.haversineDistance(homeMarker.position, pos)
        if (dx < 3000.0) {
          filtered.push(pos)
        }
      })

      filtered.forEach((foo) => {
        path.push(foo)
        bounds.extend(foo)
      })

      const svgMarker = {
        path: "M 0, 0 m -75, 0 a 75,75 0 1,0 150,0 a 75,75 0 1,0 -150,0",
        fillColor: "chartreuse",
        fillOpacity: 0.5,
        strokeWeight: 0,
        rotation: 0,
        scale: 0.05,
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(0, 0),
      };

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

  haversineDistance(mk1, mk2) {
    const R = 3958.8; // Radius of the Earth in miles
    const rlat1 = mk1.lat() * (Math.PI / 180); // Convert degrees to radians
    const rlat2 = mk2.lat() * (Math.PI / 180); // Convert degrees to radians
    const difflat = rlat2 - rlat1; // Radian difference (latitudes)
    const difflon = (mk2.lng() - mk1.lng()) * (Math.PI / 180); // Radian difference (longitudes)
    const d = 2 * R * Math.asin(Math.sqrt(Math.sin(difflat / 2) * Math.sin(difflat / 2) + Math.cos(rlat1) * Math.cos(rlat2) * Math.sin(difflon / 2) * Math.sin(difflon / 2)));
    return d;
  }
}
