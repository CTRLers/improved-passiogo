import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stop-subscription"
export default class extends Controller {
  static values = {
    id: String
  }

  toggle(event) {
    event.preventDefault()
    const stopId = this.element.dataset.stopSubscriptionId
    
    // Toggle subscription
    fetch(`/users/current/stop_subscriptions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ stop_subscription: { stop_id: stopId } })
    })
    .then(response => {
      if (response.ok) {
        // Update button state
        this.element.classList.toggle('bg-blue-600')
        this.element.classList.toggle('bg-gray-600')
        
        // Update button text
        const buttonText = this.element.querySelector('span')
        if (buttonText) {
          buttonText.textContent = this.element.classList.contains('bg-gray-600') 
            ? 'Unsubscribe from Stop Updates' 
            : 'Subscribe to Stop Updates'
        }
      }
    })
  }
}
