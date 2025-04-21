module NotificationScheduler
  # Storage for scheduled notifications - in a real app, this would be in the database
  @scheduled_notifications = []
  
  # Schedule a notification for future delivery
  def self.schedule(recipients, type:, title:, body:, data: {}, deliver_at:)
    # Validate delivery time
    unless deliver_at.is_a?(Time) || deliver_at.is_a?(DateTime)
      puts "Error: deliver_at must be a Time or DateTime object"
      return nil
    end
    
    if deliver_at <= Time.current
      puts "Error: deliver_at must be in the future"
      return nil
    end
    
    # Create a scheduled notification
    scheduled = {
      id: next_id,
      recipients: recipients,
      type: type,
      title: title,
      body: body,
      data: data,
      deliver_at: deliver_at,
      created_at: Time.current,
      status: :pending
    }
    
    @scheduled_notifications << scheduled
    
    puts "\n📅 Notification scheduled for #{deliver_at.strftime('%Y-%m-%d %H:%M:%S')}"
    puts "ID: #{scheduled[:id]}"
    puts "Type: #{type}"
    puts "Title: #{title}"
    
    scheduled
  end
  
  # List all scheduled notifications
  def self.list(status: nil)
    notifications = @scheduled_notifications
    
    # Filter by status if provided
    if status
      notifications = notifications.select { |n| n[:status] == status }
    end
    
    puts "\n📋 Scheduled Notifications (#{notifications.count}):"
    
    if notifications.empty?
      puts "No scheduled notifications found."
      return []
    end
    
    puts "-" * 100
    puts "| %-5s | %-10s | %-20s | %-15s | %-40s |" % ["ID", "Status", "Delivery Time", "Type", "Title"]
    puts "-" * 100
    
    notifications.each do |notification|
      puts "| %-5s | %-10s | %-20s | %-15s | %-40s |" % [
        notification[:id],
        notification[:status],
        notification[:deliver_at].strftime('%Y-%m-%d %H:%M'),
        notification[:type],
        notification[:title].truncate(40)
      ]
    end
    
    puts "-" * 100
    notifications
  end
  
  # View a specific scheduled notification
  def self.view(id)
    notification = find(id)
    
    unless notification
      puts "Scheduled notification ##{id} not found"
      return nil
    end
    
    puts "\n📝 Scheduled Notification ##{notification[:id]}"
    puts "=" * 50
    puts "Status:      #{notification[:status]}"
    puts "Delivery at: #{notification[:deliver_at].strftime('%Y-%m-%d %H:%M:%S')}"
    puts "Created at:  #{notification[:created_at].strftime('%Y-%m-%d %H:%M:%S')}"
    puts "Type:        #{notification[:type]}"
    puts "=" * 50
    puts "Title:       #{notification[:title]}"
    puts "Body:        #{notification[:body]}"
    puts "=" * 50
    
    # Display recipients
    case notification[:recipients]
    when Integer
      puts "Recipient:   User ##{notification[:recipients]}"
    when Array
      puts "Recipients:  #{notification[:recipients].count} users"
      puts "             #{notification[:recipients].join(', ')}"
    when :all
      puts "Recipients:  ALL USERS"
    end
    
    puts "=" * 50
    puts "Data:        #{notification[:data].inspect}"
    
    notification
  end
  
  # Cancel a scheduled notification
  def self.cancel(id)
    notification = find(id)
    
    unless notification
      puts "Scheduled notification ##{id} not found"
      return false
    end
    
    if notification[:status] != :pending
      puts "Cannot cancel notification with status #{notification[:status]}"
      return false
    end
    
    notification[:status] = :cancelled
    
    puts "\n✓ Cancelled scheduled notification ##{id}"
    true
  end
  
  # Deliver a scheduled notification immediately
  def self.deliver_now(id)
    notification = find(id)
    
    unless notification
      puts "Scheduled notification ##{id} not found"
      return false
    end
    
    if notification[:status] != :pending
      puts "Cannot deliver notification with status #{notification[:status]}"
      return false
    end
    
    # Send the notification based on recipient type
    case notification[:recipients]
    when Integer
      # Single user
      NotificationConsoleManager.send_to_user(
        notification[:recipients],
        type: notification[:type],
        title: notification[:title],
        body: notification[:body],
        data: notification[:data]
      )
    when Array
      # Multiple users
      NotificationConsoleManager.send_to_users(
        notification[:recipients],
        type: notification[:type],
        title: notification[:title],
        body: notification[:body],
        data: notification[:data]
      )
    when :all
      # All users
      NotificationConsoleManager.send_to_all(
        type: notification[:type],
        title: notification[:title],
        body: notification[:body],
        data: notification[:data]
      )
    end
    
    # Update status
    notification[:status] = :delivered
    notification[:delivered_at] = Time.current
    
    puts "\n✓ Delivered scheduled notification ##{id}"
    true
  end
  
  # Process due notifications
  def self.process_due
    due_count = 0
    
    @scheduled_notifications.each do |notification|
      next unless notification[:status] == :pending
      next unless notification[:deliver_at] <= Time.current
      
      deliver_now(notification[:id])
      due_count += 1
    end
    
    puts "\n✓ Processed #{due_count} due notifications" if due_count > 0
    due_count
  end
  
  # Interactive scheduling
  def self.interactive_schedule
    puts "\n📅 Schedule a New Notification"
    
    # Get recipient type
    recipient_type = NotificationConsoleManager.prompt_options(
      "Select recipient type:",
      [
        {value: :user, label: "Single user"},
        {value: :users, label: "Multiple users"},
        {value: :all, label: "All users"}
      ]
    )
    
    # Get user IDs based on recipient type
    recipients = nil
    case recipient_type
    when :user
      user_id = NotificationConsoleManager.prompt_input("Enter user ID:").to_i
      recipients = user_id
    when :users
      input = NotificationConsoleManager.prompt_input("Enter user IDs (comma-separated):")
      recipients = input.split(',').map(&:strip).map(&:to_i)
    when :all
      recipients = :all
    end
    
    # Get notification type
    type = NotificationConsoleManager.prompt_options(
      "Select notification type:",
      NotificationConsoleManager::NOTIFICATION_TYPES.map { |t| {value: t, label: t.to_s.titleize} }
    )
    
    # Get notification content
    title = NotificationConsoleManager.prompt_input("Enter notification title:")
    body = NotificationConsoleManager.prompt_input("Enter notification body:")
    
    # Get delivery time
    puts "\nEnter delivery time:"
    year = NotificationConsoleManager.prompt_input("Year (YYYY):").to_i
    month = NotificationConsoleManager.prompt_input("Month (1-12):").to_i
    day = NotificationConsoleManager.prompt_input("Day (1-31):").to_i
    hour = NotificationConsoleManager.prompt_input("Hour (0-23):").to_i
    minute = NotificationConsoleManager.prompt_input("Minute (0-59):").to_i
    
    begin
      deliver_at = Time.new(year, month, day, hour, minute)
    rescue ArgumentError => e
      puts "Error: Invalid date/time - #{e.message}"
      return
    end
    
    if deliver_at <= Time.current
      puts "Error: Delivery time must be in the future"
      return
    end
    
    # Confirm before scheduling
    puts "\n📋 Notification Summary:"
    puts "Type: #{type}"
    puts "Title: #{title}"
    puts "Body: #{body}"
    puts "Delivery time: #{deliver_at.strftime('%Y-%m-%d %H:%M:%S')}"
    puts "Recipients: #{recipient_type == :all ? 'ALL USERS' : recipients.inspect}"
    
    confirm = NotificationConsoleManager.prompt_yes_no("Schedule this notification?")
    return unless confirm
    
    # Schedule the notification
    schedule(recipients, type: type, title: title, body: body, deliver_at: deliver_at)
  end
  
  # Interactive menu for scheduled notifications
  def self.interactive_menu
    loop do
      puts "\n📅 Notification Scheduler"
      puts "=" * 50
      
      action = NotificationConsoleManager.prompt_options(
        "Select an action:",
        [
          {value: :list, label: "List scheduled notifications"},
          {value: :view, label: "View a scheduled notification"},
          {value: :schedule, label: "Schedule a new notification"},
          {value: :cancel, label: "Cancel a scheduled notification"},
          {value: :deliver, label: "Deliver a scheduled notification now"},
          {value: :process, label: "Process due notifications"},
          {value: :exit, label: "Exit"}
        ]
      )
      
      case action
      when :list
        status_options = [
          {value: nil, label: "All"},
          {value: :pending, label: "Pending"},
          {value: :delivered, label: "Delivered"},
          {value: :cancelled, label: "Cancelled"}
        ]
        
        status = NotificationConsoleManager.prompt_options(
          "Filter by status:",
          status_options
        )
        
        list(status: status)
      when :view
        id = NotificationConsoleManager.prompt_input("Enter notification ID:").to_i
        view(id)
      when :schedule
        interactive_schedule
      when :cancel
        id = NotificationConsoleManager.prompt_input("Enter notification ID:").to_i
        cancel(id)
      when :deliver
        id = NotificationConsoleManager.prompt_input("Enter notification ID:").to_i
        deliver_now(id)
      when :process
        process_due
      when :exit
        puts "Exiting Notification Scheduler"
        break
      end
    end
  end
  
  # Helper method to find a scheduled notification by ID
  def self.find(id)
    @scheduled_notifications.find { |n| n[:id] == id.to_i }
  end
  
  # Helper method to generate the next ID
  def self.next_id
    max_id = @scheduled_notifications.map { |n| n[:id] }.max || 0
    max_id + 1
  end
end
