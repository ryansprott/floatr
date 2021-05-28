import { Controller } from "stimulus"

export default class extends Controller {
  async connect() {
    this.load()
    setInterval(() => {
      this.load()
    }, 10000)
  }

  async load() {
    let resp = await fetch(`/source_summaries.json`)
    let data = await resp.json()
    document.getElementById("recently-added-table").innerHTML = data.recently_added
    document.getElementById("recently-seen-table").innerHTML = data.recently_seen
  }
}
