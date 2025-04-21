# Console commands for testing notifications
# Load this file in the Rails console with: load 'lib/console_commands.rb'

# Send a test notification to the first user
def test_notification
  user = User.first
  
  unless user
    puts "Error: No users found"
    return
  end
  
  puts "Sending test notification to user ##{user.id}"
  
  notification = NotificationService.notify(
    user,
    type: :info,
    title: "Console Test Notification",
    body: "This is a test notification sent from the console at #{Time.current.strftime('%H:%M:%S')}",
    data: { console_test: true }
  )
  
  puts "Notification sent! Check your browser."
  notification
end

# Send a test notification to a specific user
def notify_user(user_id, type: :info, title: nil, body: nil)
  user = User.find(user_id)
  
  title ||= "Notification for #{user.full_name}"
  body ||= "This is a notification sent at #{Time.current.strftime('%H:%M:%S')}"
  
  notification = NotificationService.notify(
    user,
    type: type,
    title: title,
    body: body,
    data: { console_command: true }
  )
  
  puts "Notification sent to user ##{user_id}!"
  notification
end

# List available notification types
def notification_types
  types = [:info, :announcement, :delay, :service_disruption, :alert, :success]
  
  puts "Available notification types:"
  types.each { |type| puts "- #{type}" }
  
  types
end

# Show help for notification commands
def notification_help
  puts <<~HELP
    
    📬 Notification Console Commands
    
    # Send a test notification to the first user
    test_notification
    
    # Send a notification to a specific user
    notify_user(user_id, type: :info, title: "Title", body: "Message")
    
    # List available notification types
    notification_types
    
    # Show this help
    notification_help
    
    # Load the full notification manager
    load 'lib/notification_console_manager.rb'
    NotificationConsoleManager.interactive_menu
    
    # Run comprehensive tests
    load 'lib/notification_test.rb'
    NotificationTest.run_all_tests
  HELP
end

# Print help message when this file is loaded
notification_help
