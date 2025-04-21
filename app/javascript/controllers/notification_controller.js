import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  toggle(event) {
    event.preventDefault()
    const notificationId = this.element.dataset.notificationId
    const isRead = this.element.classList.contains('opacity-75')
    
    const endpoint = isRead ? 'mark_as_unread' : 'mark_as_read'
    
    fetch(`/notifications/${notificationId}/${endpoint}`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    }).then(() => {
      this.element.classList.toggle('opacity-75')
      event.target.textContent = isRead ? 'Mark as read' : 'Mark as unread'
    })
  }

  markAllAsRead(event) {
    event.preventDefault()
    
    fetch('/notifications/mark_all_as_read', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    }).then(() => {
      window.location.reload()
    })
  }
}
