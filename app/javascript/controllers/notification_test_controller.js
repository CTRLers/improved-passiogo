import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  trigger(event) {
    event.preventDefault()
    
    fetch('/routes/test_notification', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
  }
}