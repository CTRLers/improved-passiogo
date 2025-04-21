import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "content", "title", "message", "icon"]

  connect() {
    console.log("NotificationBannerController connected")
    // Listen for custom notification events
    window.addEventListener('notification:received', this.handleNotification.bind(this))

    // Add a debug message to verify the controller is connected
    const debugMessage = document.createElement('div')
    debugMessage.id = 'notification-banner-debug'
    debugMessage.style.position = 'fixed'
    debugMessage.style.bottom = '10px'
    debugMessage.style.right = '10px'
    debugMessage.style.padding = '5px'
    debugMessage.style.backgroundColor = 'rgba(0,0,0,0.5)'
    debugMessage.style.color = 'white'
    debugMessage.style.fontSize = '10px'
    debugMessage.style.zIndex = '9999'
    debugMessage.textContent = 'Notification Banner Ready'
    document.body.appendChild(debugMessage)

    // Remove the debug message after 5 seconds
    setTimeout(() => {
      if (debugMessage.parentNode) {
        debugMessage.parentNode.removeChild(debugMessage)
      }
    }, 5000)
  }

  disconnect() {
    console.log("NotificationBannerController disconnected")
    window.removeEventListener('notification:received', this.handleNotification.bind(this))
  }

  handleNotification(event) {
    console.log("Notification received:", event.detail) // Add this for debugging

    try {
      const { type, title, body } = event.detail

      // Validate required fields
      if (!title && !body) {
        console.error("Notification missing required fields", event.detail)
        return
      }

      this.titleTarget.textContent = title || "Notification"
      this.messageTarget.textContent = body || ""

      this.setNotificationStyle(type)
      this.show()

      // Auto-hide after 5 seconds
      setTimeout(() => this.hide(), 5000)

      // Flash the connection indicator to show activity
      const indicator = document.getElementById('notification-channel-indicator')
      if (indicator) {
        const originalColor = indicator.style.backgroundColor
        indicator.style.backgroundColor = 'yellow'
        setTimeout(() => {
          indicator.style.backgroundColor = originalColor
        }, 500)
      }
    } catch (error) {
      console.error("Error handling notification:", error)
    }
  }

  show() {
    this.element.classList.remove("-translate-y-full")
    this.element.classList.add("translate-y-0")
  }

  hide() {
    this.element.classList.remove("translate-y-0")
    this.element.classList.add("-translate-y-full")
  }

  setNotificationStyle(type) {
    const content = this.contentTarget

    // Reset classes
    content.className = "flex items-center space-x-3 p-4 mx-auto max-w-screen-xl"

    switch(type) {
      case 'delay':
        content.classList.add("bg-yellow-100", "text-yellow-900")
        break
      case 'announcement':
        content.classList.add("bg-blue-100", "text-blue-900")
        break
      case 'service_disruption':
        content.classList.add("bg-red-100", "text-red-900")
        break
      default:
        content.classList.add("bg-gray-100", "text-gray-900")
    }
  }

  // Method to manually show a test notification
  showTestNotification() {
    const testEvent = {
      detail: {
        type: 'info',
        title: 'Test Notification',
        body: `This is a manual test notification sent at ${new Date().toLocaleTimeString()}`,
        data: { test: true, manual: true }
      }
    }

    this.handleNotification(testEvent)
    return 'Test notification shown'
  }
}
