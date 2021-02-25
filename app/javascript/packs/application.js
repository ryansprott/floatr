// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("bootstrap")
require('datatables.net-bs4')
import "../stylesheets/application";

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "controllers"

window.initMap = function (...args) {
  const event = document.createEvent("Events")
  event.initEvent("google-maps-callback", true, true)
  event.args = args
  window.dispatchEvent(event)
}

window.onload = () => {
  let table = $("#searchable-table").DataTable({
    "pageLength": 10,
    "lengthChange": false,
    "info": false,
    "ordering": true,
    "order": [3, "desc"],
    "dom": '<"row"<"col"i><"col-auto"p>>t'
  });

  $("#search-input").val("");

  $("#search-input").on("keyup", function () {
    table.search(this.value).draw();
  });
}
