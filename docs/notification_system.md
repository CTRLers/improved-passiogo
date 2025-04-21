# Notification System Documentation

## Overview
The notification system provides a comprehensive solution for managing and delivering notifications to users across the application. It includes features for sending real-time notifications, managing templates, scheduling future notifications, and handling notification delivery through both web interface and ActionCable websockets.

## Core Components

### NotificationManager
The central hub that provides a unified interface for all notification functionality. It coordinates between different notification modules and provides an interactive CLI menu.

Key features:
- Interactive menu system
- Integration of all notification subsystems
- System initialization with default templates

### NotificationService
The primary service responsible for creating and delivering notifications.

Key methods:
- `notify(users, type:, title:, body:, data: {})`: Core method for sending notifications
- `notify_route_delay(route, delay_minutes)`: Specialized method for route delays
- `notify_announcement(title:, body:)`: Method for system-wide announcements

### NotificationConsoleManager
Handles command-line operations and user interactions for notification management.

Features:
- Send notifications to single/multiple/all users
- Find and display notifications
- Mark notifications as read/unread
- Delete notifications
- View notification statistics

### NotificationTemplates
Manages reusable notification templates with placeholder support.

Features:
- Template creation and management
- Placeholder system for dynamic content
- Default templates for common scenarios
- Interactive template management

### NotificationScheduler
Handles scheduling and delivery of future notifications.

Features:
- Schedule notifications for future delivery
- Process due notifications
- Cancel scheduled notifications
- View scheduled notifications

## Notification Types
- `:info` - General information
- `:announcement` - System-wide announcements
- `:delay` - Transit delay notifications
- `:service_disruption` - Service disruption alerts
- `:alert` - Important alerts
- `:success` - Success messages

## Web Interface

### Routes
```ruby
resources :notifications, only: [:index] do
  post :mark_as_read, on: :member
  post :mark_as_unread, on: :member
  post :mark_all_as_read, on: :collection
end
```

### Components
- `NotificationBannerComponent`: Displays notification banner with unread count
- Stimulus controllers:
  - `notification_controller.js`: Handles individual notification interactions
  - `notification_banner_controller.js`: Manages notification banner display

## Real-time Notifications

### WebSocket Integration
Uses ActionCable for real-time notification delivery:
- Channel: `NotificationsChannel`
- Client subscription handling in `notifications_channel.js`
- Real-time updates through `NotificationsChannel.broadcast_to`

## Command Line Interface

### Interactive Mode
Start the interactive menu:
```ruby
rails runner lib/notification_cli.rb menu
```

### Direct Commands
```ruby
rails runner lib/notification_cli.rb send --user=1 --type=info --title="Test" --body="Message"
rails runner lib/notification_cli.rb find --user=1 --type=info --unread
rails runner lib/notification_cli.rb view 123
```

## Debug Tools
The `NotificationDebug` module provides tools for testing and debugging:
- Test ActionCable connections
- Check connection status
- Monitor active connections
- Send test notifications

## Database Model

### UserNotification
Attributes:
- `user_id`: References the user
- `notification_type`: Type of notification
- `title`: Notification title
- `body`: Notification content
- `data`: Additional JSON data
- `read_at`: Timestamp when read
- `created_at`: Creation timestamp

Scopes:
- `unread`: Notifications not yet read
- `read`: Already read notifications

## Usage Examples

### Sending a Simple Notification
```ruby
NotificationService.notify(
  user,
  type: :info,
  title: "Welcome",
  body: "Welcome to the system!",
  data: { custom: "data" }
)
```

### Using Templates
```ruby
NotificationTemplates.use(
  'welcome',
  user.id,
  data_replacements: { name: user.name }
)
```

### Scheduling a Notification
```ruby
NotificationScheduler.schedule(
  user.id,
  type: :announcement,
  title: "Scheduled Message",
  body: "This is a scheduled notification",
  deliver_at: 1.hour.from_now
)
```

## Best Practices

1. Use templates for recurring notifications
2. Include relevant data in the `data` hash for frontend processing
3. Use appropriate notification types for different scenarios
4. Implement proper error handling for notification delivery
5. Monitor notification delivery through debug tools
6. Use batch operations for multiple notifications when possible

## Error Handling
The system includes comprehensive error handling for:
- Invalid recipients
- Template errors
- Scheduling conflicts
- Delivery failures
- Connection issues

## Future Improvements
- Database storage for scheduled notifications
- Rate limiting for notifications
- Better notification grouping
- Enhanced template management
- Notification preferences per user
- Analytics and metrics