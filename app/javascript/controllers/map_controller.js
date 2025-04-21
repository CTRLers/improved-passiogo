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

      // Get route tags if available
      const routeTags = stopElement.querySelectorAll('.inline-flex.items-center.px-2');
      let routeTagsHTML = '';

      if (routeTags.length > 0) {
        routeTagsHTML = '<div class="mt-2 mb-2 flex flex-wrap gap-1">';
        routeTags.forEach(tag => {
          // Clone the tag to preserve its styling
          routeTagsHTML += tag.outerHTML;
        });
        routeTagsHTML += '</div>';
      } else {
        // Fallback to legacy route display
        const routeElement = stopElement.querySelector('.text-blue-600');
        if (routeElement) {
          routeTagsHTML = `<p class="text-sm text-blue-600 mb-2">${routeElement.textContent.trim()}</p>`;
        }
      }

      // Create popup content
      const popupContent = document.createElement('div');
      popupContent.innerHTML = `
        <h3 class="text-lg font-semibold">${stopName}</h3>
        ${routeTagsHTML}
        <a href="/stops/${stopElement.dataset.stopId}" class="text-blue-600 hover:text-blue-800 text-sm font-medium">View Details</a>
      `;

      // Create popup
      const popup = new mapboxgl.Popup({ offset: 25 })
        .setDOMContent(popupContent);

      // Determine marker color based on number of routes
      let markerColor = '#6B7280'; // Default gray
      const routeCount = routeTags.length;

      if (routeCount > 3) {
        markerColor = '#EF4444'; // Red for stops with many routes (4+)
      } else if (routeCount > 1) {
        markerColor = '#3B82F6'; // Blue for stops with multiple routes (2-3)
      } else if (routeCount === 1) {
        markerColor = '#10B981'; // Green for stops with one route
      }

      // Create marker
      const marker = new mapboxgl.Marker({
        color: markerColor
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
