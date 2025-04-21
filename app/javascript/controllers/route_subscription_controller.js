import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="route-subscription"
export default class extends Controller {
  toggle(event) {
    event.preventDefault()
    const routeId = event.currentTarget.dataset.routeId
    
    // Toggle subscription
    fetch(`/users/current/route_subscriptions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ route_subscription: { route_id: routeId } })
    })
    .then(response => {
      if (response.ok) {
        // Update button state
        event.currentTarget.classList.toggle('bg-blue-600')
        event.currentTarget.classList.toggle('bg-gray-600')
      }
    })
  }
}
