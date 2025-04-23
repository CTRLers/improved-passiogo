// app/javascript/controllers/stops_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "listView", "mapView",
    "viewListBtn", "viewMapBtn",
    "searchInput", "routeFilter", "sortSelect",
    "grid", "stopCard"
  ]

  connect() {
    this.showList()
    this.sortCards()
  }

  // — View toggle —
  showList() {
    this.listViewTarget.classList.replace("hidden", "block")
    this.mapViewTarget.classList.replace("block", "hidden")

    this.viewListBtnTarget.classList.replace("bg-gray-200", "bg-blue-600")
    this.viewListBtnTarget.classList.replace("text-gray-700", "text-white")
    this.viewMapBtnTarget.classList.replace("bg-blue-600", "bg-gray-200")
    this.viewMapBtnTarget.classList.replace("text-white", "text-gray-700")
  }

  showMap() {
    this.mapViewTarget.classList.replace("hidden", "block")
    this.listViewTarget.classList.replace("block", "hidden")

    this.viewMapBtnTarget.classList.replace("bg-gray-200", "bg-blue-600")
    this.viewMapBtnTarget.classList.replace("text-gray-700", "text-white")
    this.viewListBtnTarget.classList.replace("bg-blue-600", "bg-gray-200")
    this.viewListBtnTarget.classList.replace("text-white", "text-gray-700")

    window.dispatchEvent(new Event("resize"))
  }

  // — Search & filter —
  filter() {
    const term    = this.searchInputTarget.value.toLowerCase()
    const routeId = this.routeFilterTarget.value

    this.stopCardTargets.forEach(card => {
      const name   = card.querySelector("h3").textContent.toLowerCase()
      const tags   = Array.from(card.querySelectorAll(".route-tag"))
      const legacy = card.querySelector(".legacy-route")?.textContent.toLowerCase() || ""

      const matchesSearch =
          name.includes(term) ||
          tags.some(t => t.textContent.toLowerCase().includes(term)) ||
          legacy.includes(term)

      const matchesRoute =
          routeId === "all" ||
          tags.some(t => t.dataset.routeId === routeId)

      card.style.display = matchesSearch && matchesRoute ? "" : "none"
    })

    this.sortCards()
  }

  // — Sort —
  sort() {
    this.sortCards()
  }

  sortCards() {
    const by      = this.sortSelectTarget.value
    const visible = this.stopCardTargets.filter(c => c.style.display !== "none")

    visible.sort((a, b) => {
      if (by === "name") {
        return a.querySelector("h3").textContent.localeCompare(
            b.querySelector("h3").textContent
        )
      }
      if (by === "routes") {
        return b.querySelectorAll(".route-tag").length
            - a.querySelectorAll(".route-tag").length
      }
      return 0
    })

    visible.forEach(c => this.gridTarget.appendChild(c))
  }
}
