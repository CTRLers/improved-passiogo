import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
    name:   String,
    lat:    Number,
    lng:    Number
  }
  static targets = ["map"]

  async connect() {
    await this._loadScript()
    const { Map }    = await google.maps.importLibrary("maps")
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker")
    this.mapClass    = Map
    this.markerClass = AdvancedMarkerElement
    this._initMap()
  }

  _loadScript() {
    return new Promise(resolve => {
      if (window.google?.maps?.importLibrary) return resolve()
      const s = document.createElement("script")
      s.src   = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&v=beta`
      s.async = s.defer = true
      s.onload = () => resolve()
      document.head.appendChild(s)
    })
  }

  _initMap() {
    const center = { lat: this.latValue, lng: this.lngValue }
    // build the map
    this.map = new this.mapClass(this.mapTarget, {
      center,
      zoom: 14,
      mapId: this.nameValue
    })
    console.log("loaded map")
    // place your marker at the very center
    const marker =new this.markerClass({
      map:      this.map,
      position: center,
      title:    this.nameValue,
    })
    // const marker = new google.maps.marker.AdvancedMarkerElement({
    //   map:      this.map,
    //   position: center,
    //   title:    this.nameValue,
    // });



    console.log("placed marker")
  }
}
