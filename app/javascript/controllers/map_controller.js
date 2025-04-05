import { Controller } from "@hotwired/stimulus";
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  connect() {
    mapboxgl.accessToken = process.env.MAPBOX_ACCESS_TOKEN || 'your_mapbox_access_token_here';
    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [-74.0060, 40.7128], // Default to NYC coordinates; adjust as needed
      zoom: 12
    });

    // Example: Add a marker for demonstration
    new mapboxgl.Marker()
        .setLngLat([-74.0060, 40.7128])
        .addTo(this.map);
  }
}
