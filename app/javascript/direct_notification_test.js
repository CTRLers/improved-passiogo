// Direct notification test
// This file provides a global function to directly test the notification banner

document.addEventListener('DOMContentLoaded', function() {
  console.log('Direct notification test loaded');
  
  // Create a global function to directly test the notification banner
  window.showDirectNotification = function(title, body, type) {
    console.log('Attempting to show direct notification');
    
    // Default values
    title = title || 'Test Notification';
    body = body || 'This is a test notification sent at ' + new Date().toLocaleTimeString();
    type = type || 'info';
    
    // Create a custom event
    const event = new CustomEvent('notification:received', {
      detail: {
        type: type,
        title: title,
        body: body,
        data: { direct_test: true }
      }
    });
    
    // Dispatch the event
    console.log('Dispatching notification:received event', event.detail);
    window.dispatchEvent(event);
    
    // Also try to find and use the controller directly
    const bannerElement = document.querySelector('[data-controller="notification-banner"]');
    if (bannerElement) {
      console.log('Found notification banner element');
      
      // Try to manually show the banner
      try {
        const container = bannerElement.querySelector('[data-notification-banner-target="container"]');
        const title = bannerElement.querySelector('[data-notification-banner-target="title"]');
        const message = bannerElement.querySelector('[data-notification-banner-target="message"]');
        
        if (container && title && message) {
          console.log('Found all required elements, showing manually');
          
          // Set content
          title.textContent = event.detail.title;
          message.textContent = event.detail.body;
          
          // Show the banner
          container.classList.remove('-translate-y-full');
          container.classList.add('translate-y-0');
          
          // Auto-hide after 5 seconds
          setTimeout(() => {
            container.classList.remove('translate-y-0');
            container.classList.add('-translate-y-full');
          }, 5000);
          
          return 'Notification shown manually';
        }
      } catch (error) {
        console.error('Error showing notification manually:', error);
      }
    } else {
      console.warn('Notification banner element not found');
    }
    
    return 'Attempted to show notification';
  };
  
  // Add a button to the page for testing
  const addTestButton = function() {
    // Check if the button already exists
    if (document.getElementById('direct-notification-test-button')) {
      return;
    }
    
    // Create the button
    const button = document.createElement('button');
    button.id = 'direct-notification-test-button';
    button.textContent = 'Direct Test';
    button.style.position = 'fixed';
    button.style.bottom = '50px';
    button.style.right = '10px';
    button.style.zIndex = '9999';
    button.style.padding = '8px 16px';
    button.style.backgroundColor = '#4CAF50';
    button.style.color = 'white';
    button.style.border = 'none';
    button.style.borderRadius = '4px';
    button.style.cursor = 'pointer';
    
    // Add click event
    button.addEventListener('click', function() {
      window.showDirectNotification();
    });
    
    // Add to the page
    document.body.appendChild(button);
    console.log('Added direct notification test button');
  };
  
  // Add the test button after a short delay to ensure the page is loaded
  setTimeout(addTestButton, 1000);
});
