module NotificationTest
  # Send a test notification and verify it was broadcast
  def self.send_test_notification(user_id = nil)
    # Find a user to send the notification to
    user = user_id ? User.find(user_id) : User.first

    unless user
      puts "Error: No user found"
      return
    end

    puts "\n🔍 Testing notification system with user ##{user.id}"

    # Create a unique test message
    test_id = SecureRandom.hex(4)
    title = "Test Notification #{test_id}"
    body = "This is a test notification sent at #{Time.current.strftime('%H:%M:%S')}"

    # Create the notification record directly
    notification = user.user_notifications.create!(
      title: title,
      body: body,
      notification_type: :info,
      data: { test_id: test_id }
    )

    puts "✓ Created notification record ##{notification.id}"

    # Broadcast the notification directly using ActionCable
    begin
      result = NotificationsChannel.broadcast_to(
        user,
        {
          id: notification.id,
          type: :info,
          title: title,
          body: body,
          data: { test_id: test_id }
        }
      )

      puts "✓ Broadcast result: #{result.inspect}"
      puts "\n✉️ Test notification sent!"
      puts "Title: #{title}"
      puts "Body: #{body}"
      puts "Test ID: #{test_id}"
      puts "\nCheck your browser to see if the notification appears."
      puts "If not, check the browser console for errors and the Rails logs for connection issues."
    rescue => e
      puts "✗ Error broadcasting notification: #{e.message}"
      puts e.backtrace.join("\n")
    end

    notification
  end

  # Test the full notification flow using NotificationService
  def self.test_notification_service(user_id = nil)
    # Find a user to send the notification to
    user = user_id ? User.find(user_id) : User.first

    unless user
      puts "Error: No user found"
      return
    end

    puts "\n🔍 Testing NotificationService with user ##{user.id}"

    # Create a unique test message
    test_id = SecureRandom.hex(4)
    title = "Service Test #{test_id}"
    body = "This is a service test notification sent at #{Time.current.strftime('%H:%M:%S')}"

    # Use the NotificationService to send the notification
    begin
      result = NotificationService.notify(
        user,
        type: :info,
        title: title,
        body: body,
        data: { test_id: test_id, service_test: true }
      )

      puts "\n✉️ Service test notification sent!"
      puts "Title: #{title}"
      puts "Body: #{body}"
      puts "Test ID: #{test_id}"
      puts "\nCheck your browser to see if the notification appears."
    rescue => e
      puts "✗ Error sending notification: #{e.message}"
      puts e.backtrace.join("\n")
    end

    result
  end

  # Test the NotificationConsoleManager
  def self.test_console_manager(user_id = nil)
    # Find a user to send the notification to
    user = user_id ? User.find(user_id) : User.first

    unless user
      puts "Error: No user found"
      return
    end

    puts "\n🔍 Testing NotificationConsoleManager with user ##{user.id}"

    # Create a unique test message
    test_id = SecureRandom.hex(4)
    title = "Console Test #{test_id}"
    body = "This is a console test notification sent at #{Time.current.strftime('%H:%M:%S')}"

    # Use the NotificationConsoleManager to send the notification
    begin
      result = NotificationConsoleManager.send_to_user(
        user.id,
        type: :info,
        title: title,
        body: body,
        data: { test_id: test_id, console_test: true }
      )

      puts "\nCheck your browser to see if the notification appears."
    rescue => e
      puts "✗ Error sending notification: #{e.message}"
      puts e.backtrace.join("\n")
    end

    result
  end

  # Run all tests
  def self.run_all_tests(user_id = nil)
    puts "\n🧪 Running all notification tests"

    direct_result = send_test_notification(user_id)
    puts "\n" + "-" * 50

    service_result = test_notification_service(user_id)
    puts "\n" + "-" * 50

    console_result = test_console_manager(user_id)

    puts "\n✅ All tests completed"

    {
      direct: direct_result,
      service: service_result,
      console: console_result
    }
  end

  # Help method
  def self.help
    puts <<~HELP

      🧪 Notification Test Tools

      # Send a direct test notification
      NotificationTest.send_test_notification(user_id)

      # Test the NotificationService
      NotificationTest.test_notification_service(user_id)

      # Test the NotificationConsoleManager
      NotificationTest.test_console_manager(user_id)

      # Run all tests
      NotificationTest.run_all_tests(user_id)

      # Show this help
      NotificationTest.help
    HELP
  end
end
