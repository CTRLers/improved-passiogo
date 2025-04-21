import { Controller } from "@hotwired/stimulus";
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static values = {
    stops: Array
  }

  connect() {
    mapboxgl.accessToken = process.env.MAPBOX_ACCESS_TOKEN || 'your_mapbox_access_token_here';

    // Initialize the map
    this.initializeMap();

    // Add stops to the map if available in the DOM
    this.addStopsToMap();
  }

  initializeMap() {
    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [-74.0060, 40.7128], // Default to NYC coordinates; adjust as needed
      zoom: 12
    });

    // Add navigation controls
    this.map.addControl(new mapboxgl.NavigationControl());

    // Add geolocation control
    this.map.addControl(
      new mapboxgl.GeolocateControl({
        positionOptions: {
          enableHighAccuracy: true
        },
        trackUserLocation: true,
        showUserHeading: true
      })
    );
  }

  addStopsToMap() {
    // Get all stops from the DOM
    const stopElements = document.querySelectorAll('.stop-card');

    if (stopElements.length === 0) {
      console.log('No stops found in the DOM');
      return;
    }

    const bounds = new mapboxgl.LngLatBounds();
    const markers = [];

    stopElements.forEach(stopElement => {
      // Extract coordinates from the stop element
      const coordinatesText = stopElement.querySelector('p:first-of-type').textContent.trim();
      const coordinatesMatch = coordinatesText.match(/(-?\d+\.\d+),\s*(-?\d+\.\d+)/);

      if (!coordinatesMatch) return;

      const lat = parseFloat(coordinatesMatch[1]);
      const lng = parseFloat(coordinatesMatch[2]);

      if (isNaN(lat) || isNaN(lng)) return;

      // Get stop name
      const stopName = stopElement.querySelector('h3').textContent.trim();

      // Get route name if available
      const routeElement = stopElement.querySelector('.text-blue-600');
      const routeName = routeElement ? routeElement.textContent.trim() : '';

      // Create popup content
      const popupContent = document.createElement('div');
      popupContent.innerHTML = `
        <h3 class="text-lg font-semibold">${stopName}</h3>
        ${routeName ? `<p class="text-sm text-blue-600">${routeName}</p>` : ''}
        <a href="/stops/${stopElement.dataset.stopId}" class="text-blue-600 hover:text-blue-800 text-sm font-medium">View Details</a>
      `;

      // Create popup
      const popup = new mapboxgl.Popup({ offset: 25 })
        .setDOMContent(popupContent);

      // Create marker
      const marker = new mapboxgl.Marker({
        color: routeName ? '#3B82F6' : '#6B7280' // Blue for stops with routes, gray for others
      })
        .setLngLat([lng, lat])
        .setPopup(popup)
        .addTo(this.map);

      markers.push(marker);
      bounds.extend([lng, lat]);
    });

    // Fit map to bounds if we have markers
    if (markers.length > 0) {
      this.map.fitBounds(bounds, {
        padding: 50,
        maxZoom: 15
      });
    }
  }
}
