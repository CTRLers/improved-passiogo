import consumer from "./consumer"

// Create a safe wrapper for the consumer
const safeConsumer = {
  subscriptions: {
    create: function(channelName, handlers) {
      try {
        // Try to create the subscription using the consumer
        return consumer.subscriptions.create(channelName, handlers);
      } catch (error) {
        console.error("Error creating subscription:", error);

        // Return a dummy subscription object that won't throw errors
        return {
          connected: handlers.connected || function() {},
          disconnected: handlers.disconnected || function() {},
          rejected: handlers.rejected || function() {},
          received: handlers.received || function() {},
          perform: function(action, data) {
            console.warn(`Cannot perform ${action} - ActionCable not connected`);
            return false;
          }
        };
      }
    }
  }
};

// Store the subscription as a global variable for debugging and testing
window.notificationChannel = safeConsumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("Connected to NotificationsChannel")
    // Add a visual indicator that the channel is connected
    const indicator = document.createElement('div')
    indicator.id = 'notification-channel-indicator'
    indicator.style.position = 'fixed'
    indicator.style.bottom = '10px'
    indicator.style.left = '10px'
    indicator.style.width = '10px'
    indicator.style.height = '10px'
    indicator.style.borderRadius = '50%'
    indicator.style.backgroundColor = 'green'
    indicator.style.zIndex = '9999'
    indicator.title = 'Notification channel connected'
    document.body.appendChild(indicator)
  },

  disconnected() {
    console.log("Disconnected from NotificationsChannel")
    // Update the indicator when disconnected
    const indicator = document.getElementById('notification-channel-indicator')
    if (indicator) {
      indicator.style.backgroundColor = 'red'
      indicator.title = 'Notification channel disconnected'
    }
  },

  rejected() {
    console.log("Connection to NotificationsChannel rejected")
    // Update the indicator when rejected
    const indicator = document.getElementById('notification-channel-indicator')
    if (indicator) {
      indicator.style.backgroundColor = 'orange'
      indicator.title = 'Notification channel connection rejected'
    }
  },

  received(data) {
    console.log("Notification received:", data)
    // Trigger notification when data is received from WebSocket
    const event = new CustomEvent('notification:received', {
      detail: {
        type: data.type,
        title: data.title,
        body: data.body,
        data: data.data
      }
    })
    window.dispatchEvent(event)
  },

  // Add a method to send a test notification
  sendTestNotification() {
    console.log("Sending test notification via channel")
    this.perform('test_notification')
  }
})

// Add a global function to test notifications from the console
window.testNotification = function() {
  console.log("Test notification function called")

  // Try to find the notification banner controller
  const bannerController = document.querySelector('[data-controller="notification-banner"]')
  if (bannerController && bannerController.__stimulusController) {
    console.log("Using notification banner controller")
    return bannerController.__stimulusController.showTestNotification()
  }

  // Fallback to using the channel
  if (window.notificationChannel) {
    console.log("Using notification channel")
    window.notificationChannel.sendTestNotification()
    return "Test notification sent via channel"
  }

  // Last resort - create a custom event
  console.log("Using custom event")
  const event = new CustomEvent('notification:received', {
    detail: {
      type: 'info',
      title: 'Manual Test Notification',
      body: `This is a manual test notification sent at ${new Date().toLocaleTimeString()}`,
      data: { test: true, manual: true }
    }
  })
  window.dispatchEvent(event)
  return "Test notification sent via custom event"
}
