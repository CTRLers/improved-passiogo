// Direct Banner Test
// This script provides a direct way to test the notification banner without relying on ActionCable

document.addEventListener('DOMContentLoaded', function() {
  console.log('Direct banner test loaded');

  // Create a global function to directly manipulate the notification banner
  window.showDirectBanner = function(title, body, type) {
    console.log('Attempting to show direct banner');

    // Default values
    title = title || 'Direct Test Notification';
    body = body || 'This is a direct test notification sent at ' + new Date().toLocaleTimeString();
    type = type || 'info';

    // Find the notification banner element
    const bannerElement = document.querySelector('[data-controller="notification-banner"]');

    if (!bannerElement) {
      console.error('Notification banner element not found');
      return false;
    }

    console.log('Found notification banner element');

    // Find the required elements
    const container = bannerElement.querySelector('[data-notification-banner-target="container"]');
    const titleElement = bannerElement.querySelector('[data-notification-banner-target="title"]');
    const messageElement = bannerElement.querySelector('[data-notification-banner-target="message"]');
    const contentElement = bannerElement.querySelector('[data-notification-banner-target="content"]');

    if (!titleElement || !messageElement || !contentElement) {
      console.error('Required elements not found');
      console.log('container:', container);
      console.log('titleElement:', titleElement);
      console.log('messageElement:', messageElement);
      console.log('contentElement:', contentElement);
      return false;
    }

    console.log('Found all required elements');

    // Set content
    titleElement.textContent = title;
    messageElement.textContent = body;

    // Reset content classes
    contentElement.className = 'flex items-center space-x-3 p-4 mx-auto max-w-screen-xl';

    // Set type-specific classes
    switch(type) {
      case 'delay':
        contentElement.classList.add('bg-yellow-100', 'text-yellow-900');
        break;
      case 'announcement':
        contentElement.classList.add('bg-blue-100', 'text-blue-900');
        break;
      case 'service_disruption':
        contentElement.classList.add('bg-red-100', 'text-red-900');
        break;
      default:
        contentElement.classList.add('bg-gray-100', 'text-gray-900');
    }

    // Show the banner
    bannerElement.classList.remove('-translate-y-full');
    bannerElement.classList.add('translate-y-0');

    // Auto-hide after 5 seconds
    setTimeout(() => {
      bannerElement.classList.remove('translate-y-0');
      bannerElement.classList.add('-translate-y-full');
    }, 5000);

    console.log('Banner shown successfully');
    return true;
  };

  // Add a button to the page for testing
  const addTestButton = function() {
    // Check if the button already exists
    if (document.getElementById('direct-banner-test-button')) {
      return;
    }

    // Create the button
    const button = document.createElement('button');
    button.id = 'direct-banner-test-button';
    button.textContent = 'Direct Banner Test';
    button.style.position = 'fixed';
    button.style.bottom = '90px';
    button.style.right = '10px';
    button.style.zIndex = '9999';
    button.style.padding = '8px 16px';
    button.style.backgroundColor = '#f44336';
    button.style.color = 'white';
    button.style.border = 'none';
    button.style.borderRadius = '4px';
    button.style.cursor = 'pointer';

    // Add click event
    button.addEventListener('click', function() {
      window.showDirectBanner();
    });

    // Add to the page
    document.body.appendChild(button);
    console.log('Added direct banner test button');
  };

  // Add the test button after a short delay to ensure the page is loaded
  setTimeout(addTestButton, 1000);
});
