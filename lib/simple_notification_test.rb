# Simple notification test
# Load this file in the Rails console with: load 'lib/simple_notification_test.rb'

def test_notification(user_id = nil)
  # Find a user
  user = user_id ? User.find(user_id) : User.first

  unless user
    puts "Error: No users found"
    return
  end

  puts "Testing notification for user ##{user.id} (#{user.email})"

  # Create a notification
  notification = user.user_notifications.create!(
    title: "Console Test",
    body: "This is a test notification sent at #{Time.current.strftime('%H:%M:%S')}",
    notification_type: :info,
    data: { test: true }
  )

  puts "Created notification ##{notification.id}"

  # Broadcast directly using ActionCable
  begin
    NotificationsChannel.broadcast_to(
      user,
      {
        id: notification.id,
        type: :info,
        title: notification.title,
        body: notification.body,
        data: notification.data
      }
    )

    puts "Broadcast sent via ActionCable"
    puts "Check your browser to see if the notification appears"
  rescue => e
    puts "Error broadcasting notification: #{e.message}"
  end

  notification
end

puts "Simple notification test loaded"
puts "Run test_notification(user_id) to test"
