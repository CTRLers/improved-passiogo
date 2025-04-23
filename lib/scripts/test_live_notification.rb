def send_test_notification(user_id)
  user = User.find(user_id)

  types = [ :info, :delay, :announcement, :service_disruption ]
  type = types.sample

  notification_data = {
    type: type,
    title: "Test #{type.to_s.titleize} Notification",
    body: "This is a test notification sent at #{Time.current.strftime('%H:%M:%S')}",
    data: {
      timestamp: Time.current,
      test: true
    }
  }

  result = NotificationService.notify(
    user,
    **notification_data
  )

  puts "\n✉️  Notification sent!"
  puts "Type: #{type}"
  puts "Title: #{notification_data[:title]}"
  puts "Body: #{notification_data[:body]}"
  puts "Timestamp: #{notification_data[:data][:timestamp]}"

  result
end

# Usage example (copy this to console):
# send_test_notification(User.first.id)
