module NotificationConsoleManager
  NOTIFICATION_TYPES = [ :info, :announcement, :delay, :service_disruption, :alert, :success ]

  # Send a notification to a specific user
  def self.send_to_user(user_id, type: :info, title:, body:, data: {})
    user = User.find(user_id)
    notification = NotificationService.notify(
      user,
      type: type,
      title: title,
      body: body,
      data: data
    )

    puts "\n✉️  Notification sent to user ##{user_id}!"
    puts "Type: #{type}"
    puts "Title: #{title}"
    puts "Body: #{body}"

    notification
  end

  # Interactive method to create and send a notification
  def self.interactive_send
    puts "\n📝 Interactive Notification Creator"

    # Get recipient type
    recipient_type = prompt_options(
      "Select recipient type:",
      [
        { value: :user, label: "Single user" },
        { value: :users, label: "Multiple users" },
        { value: :all, label: "All users" }
      ]
    )

    # Get user IDs based on recipient type
    user_ids = []
    case recipient_type
    when :user
      user_id = prompt_input("Enter user ID:")
      user_ids = [ user_id.to_i ]
    when :users
      input = prompt_input("Enter user IDs (comma-separated):")
      user_ids = input.split(",").map(&:strip).map(&:to_i)
    end

    # Get notification type
    type = prompt_options(
      "Select notification type:",
      NOTIFICATION_TYPES.map { |t| { value: t, label: t.to_s.titleize } }
    )

    # Get notification content
    title = prompt_input("Enter notification title:")
    body = prompt_input("Enter notification body:")

    # Confirm before sending
    puts "\n📋 Notification Summary:"
    puts "Type: #{type}"
    puts "Title: #{title}"
    puts "Body: #{body}"
    puts "Recipients: #{recipient_type == :all ? 'ALL USERS' : user_ids.join(', ')}"

    confirm = prompt_yes_no("Send this notification?")
    return unless confirm

    # Send notification based on recipient type
    case recipient_type
    when :user
      send_to_user(user_ids.first, type: type, title: title, body: body)
    when :users
      send_to_users(user_ids, type: type, title: title, body: body)
    when :all
      send_to_all(type: type, title: title, body: body)
    end
  end

  # Send a notification to multiple users
  def self.send_to_users(user_ids, type: :info, title:, body:, data: {})
    users = User.where(id: user_ids)
    count = users.count

    notifications = NotificationService.notify(
      users,
      type: type,
      title: title,
      body: body,
      data: data
    )

    puts "\n✉️  Notification sent to #{count} users!"
    puts "Type: #{type}"
    puts "Title: #{title}"
    puts "Body: #{body}"

    notifications
  end

  # Send a notification to all users
  def self.send_to_all(type: :announcement, title:, body:, data: {})
    users = User.all
    count = users.count

    notifications = NotificationService.notify(
      users,
      type: type,
      title: title,
      body: body,
      data: data
    )

    puts "\n✉️  Notification sent to ALL users (#{count})!"
    puts "Type: #{type}"
    puts "Title: #{title}"
    puts "Body: #{body}"

    notifications
  end

  # Find notifications by various criteria
  def self.find_notifications(options = {})
    query = UserNotification.all

    # Filter by user
    if options[:user_id]
      query = query.where(user_id: options[:user_id])
    end

    # Filter by type
    if options[:type]
      query = query.where(notification_type: options[:type])
    end

    # Filter by read status
    if options[:read] == true
      query = query.read
    elsif options[:read] == false
      query = query.unread
    end

    # Filter by date range
    if options[:since]
      query = query.where("created_at >= ?", options[:since])
    end

    if options[:until]
      query = query.where("created_at <= ?", options[:until])
    end

    # Search in title or body
    if options[:search]
      search_term = "%#{options[:search]}%"
      query = query.where("title ILIKE ? OR body ILIKE ?", search_term, search_term)
    end

    # Order results
    order_by = options[:order_by] || "created_at"
    order_direction = options[:order_direction] || "desc"
    query = query.order("#{order_by} #{order_direction}")

    # Limit results
    if options[:limit]
      query = query.limit(options[:limit])
    end

    results = query.to_a
    puts "\n🔍 Found #{results.count} notifications matching criteria"

    results
  end

  # Interactive method to find and display notifications
  def self.interactive_find
    puts "\n🔍 Interactive Notification Finder"

    options = {}

    # User filter
    if prompt_yes_no("Filter by user?")
      options[:user_id] = prompt_input("Enter user ID:").to_i
    end

    # Type filter
    if prompt_yes_no("Filter by notification type?")
      options[:type] = prompt_options(
        "Select notification type:",
        NOTIFICATION_TYPES.map { |t| { value: t, label: t.to_s.titleize } }
      )
    end

    # Read status filter
    if prompt_yes_no("Filter by read status?")
      read_status = prompt_options(
        "Select read status:",
        [
          { value: true, label: "Read" },
          { value: false, label: "Unread" }
        ]
      )
      options[:read] = read_status
    end

    # Date range filter
    if prompt_yes_no("Filter by date range?")
      if prompt_yes_no("Filter by start date?")
        days = prompt_input("Enter number of days ago for start date:").to_i
        options[:since] = days.days.ago
      end

      if prompt_yes_no("Filter by end date?")
        days = prompt_input("Enter number of days ago for end date:").to_i
        options[:until] = days.days.ago
      end
    end

    # Search filter
    if prompt_yes_no("Search in title or body?")
      options[:search] = prompt_input("Enter search term:")
    end

    # Limit results
    if prompt_yes_no("Limit number of results?")
      options[:limit] = prompt_input("Enter maximum number of results:").to_i
    end

    # Find notifications with the specified options
    notifications = find_notifications(options)

    # Display results in a formatted table
    display_notifications(notifications)

    # Return the notifications for further processing
    notifications
  end

  # Display notifications in a formatted table
  def self.display_notifications(notifications)
    return puts "\nNo notifications found." if notifications.empty?

    puts "\n📋 Notifications (#{notifications.count}):"
    puts "-" * 100
    puts "| %-5s | %-15s | %-10s | %-20s | %-30s |" % [ "ID", "User", "Type", "Created", "Title" ]
    puts "-" * 100

    notifications.each do |notification|
      user = User.find_by(id: notification.user_id)
      user_name = user ? "#{user.id} (#{user.email})" : "User ##{notification.user_id}"
      created_at = notification.created_at.strftime("%Y-%m-%d %H:%M")
      read_status = notification.read_at ? "✓" : " "

      puts "| %-5s | %-15s | %-10s | %-20s | %-30s |" % [
        "#{notification.id} #{read_status}",
        user_name.truncate(15),
        notification.notification_type.to_s.truncate(10),
        created_at,
        notification.title.truncate(30)
      ]
    end

    puts "-" * 100
  end

  # View a specific notification in detail
  def self.view(notification_id)
    notification = UserNotification.find(notification_id)
    user = User.find_by(id: notification.user_id)

    puts "\n📝 Notification ##{notification.id}"
    puts "=" * 50
    puts "User:       #{user ? "#{user.id} (#{user.email})" : "User ##{notification.user_id}"}"
    puts "Type:       #{notification.notification_type}"
    puts "Created at: #{notification.created_at.strftime('%Y-%m-%d %H:%M:%S')}"
    puts "Status:     #{notification.read_at ? 'Read' : 'Unread'}"
    if notification.read_at
      puts "Read at:    #{notification.read_at.strftime('%Y-%m-%d %H:%M:%S')}"
    end
    puts "=" * 50
    puts "Title:      #{notification.title}"
    puts "Body:       #{notification.body}"
    puts "=" * 50
    puts "Data:       #{notification.data.present? ? notification.data.to_json : 'None'}"

    # Offer actions for this notification
    actions = []
    if notification.read_at
      actions << { value: :mark_unread, label: "Mark as unread" }
    else
      actions << { value: :mark_read, label: "Mark as read" }
    end
    actions << { value: :delete, label: "Delete notification" }
    actions << { value: :cancel, label: "Cancel" }

    action = prompt_options("Select an action:", actions)

    case action
    when :mark_read
      mark_as_read([ notification.id ])
    when :mark_unread
      mark_as_unread([ notification.id ])
    when :delete
      if prompt_yes_no("Are you sure you want to delete this notification?")
        delete([ notification.id ])
      end
    end

    notification
  end

  # Get notification statistics
  def self.statistics(user_id = nil)
    query = user_id ? UserNotification.where(user_id: user_id) : UserNotification

    stats = {
      total: query.count,
      read: query.read.count,
      unread: query.unread.count,
      by_type: query.group(:notification_type).count,
      last_24h: query.where("created_at >= ?", 24.hours.ago).count,
      last_7d: query.where("created_at >= ?", 7.days.ago).count
    }

    if user_id
      puts "\n📊 Notification statistics for User ##{user_id}:"
    else
      puts "\n📊 System-wide notification statistics:"
    end

    puts "Total: #{stats[:total]}"
    puts "Read: #{stats[:read]} (#{percentage(stats[:read], stats[:total])}%)"
    puts "Unread: #{stats[:unread]} (#{percentage(stats[:unread], stats[:total])}%)"
    puts "Last 24 hours: #{stats[:last_24h]}"
    puts "Last 7 days: #{stats[:last_7d]}"
    puts "By type:"

    stats[:by_type].each do |type, count|
      puts "  - #{type}: #{count} (#{percentage(count, stats[:total])}%)"
    end

    stats
  end

  # Mark notifications as read or unread
  def self.mark_as_read(notification_ids)
    notifications = UserNotification.where(id: notification_ids)
    count = notifications.count

    notifications.update_all(read_at: Time.current)

    puts "\n✓ Marked #{count} notifications as read"
  end

  def self.mark_as_unread(notification_ids)
    notifications = UserNotification.where(id: notification_ids)
    count = notifications.count

    notifications.update_all(read_at: nil)

    puts "\n✓ Marked #{count} notifications as unread"
  end

  # Delete notifications
  def self.delete(notification_ids)
    count = UserNotification.where(id: notification_ids).count
    UserNotification.where(id: notification_ids).delete_all

    puts "\n🗑️ Deleted #{count} notifications"
  end

  # Interactive menu for managing notifications
  def self.interactive_menu
    loop do
      puts "\n📬 Notification Console Manager"
      puts "=" * 50

      action = prompt_options(
        "Select an action:",
        [
          { value: :send, label: "Send a notification" },
          { value: :find, label: "Find notifications" },
          { value: :view, label: "View a specific notification" },
          { value: :stats, label: "View notification statistics" },
          { value: :mark_read, label: "Mark notifications as read" },
          { value: :mark_unread, label: "Mark notifications as unread" },
          { value: :delete, label: "Delete notifications" },
          { value: :exit, label: "Exit" }
        ]
      )

      case action
      when :send
        interactive_send
      when :find
        interactive_find
      when :view
        notification_id = prompt_input("Enter notification ID:").to_i
        view(notification_id)
      when :stats
        if prompt_yes_no("View statistics for a specific user?")
          user_id = prompt_input("Enter user ID:").to_i
          statistics(user_id)
        else
          statistics
        end
      when :mark_read
        ids_input = prompt_input("Enter notification IDs (comma-separated):").split(",").map(&:strip).map(&:to_i)
        mark_as_read(ids_input)
      when :mark_unread
        ids_input = prompt_input("Enter notification IDs (comma-separated):").split(",").map(&:strip).map(&:to_i)
        mark_as_unread(ids_input)
      when :delete
        ids_input = prompt_input("Enter notification IDs (comma-separated):").split(",").map(&:strip).map(&:to_i)
        if prompt_yes_no("Are you sure you want to delete #{ids_input.size} notification(s)?")
          delete(ids_input)
        end
      when :exit
        puts "Exiting Notification Console Manager"
        break
      end
    end
  end

  # Helper method to calculate percentage
  def self.percentage(part, total)
    total.zero? ? 0 : ((part.to_f / total) * 100).round(1)
  end

  # Helper method to prompt for input
  def self.prompt_input(message)
    print "#{message} "
    gets.chomp
  end

  # Helper method to prompt for yes/no
  def self.prompt_yes_no(message)
    print "#{message} (y/n) "
    gets.chomp.downcase == "y"
  end

  # Helper method to prompt for options
  def self.prompt_options(message, options)
    puts message
    options.each_with_index do |option, index|
      puts "#{index + 1}. #{option[:label]}"
    end

    print "Enter your choice (1-#{options.size}): "
    choice = gets.chomp.to_i

    if choice < 1 || choice > options.size
      puts "Invalid choice. Please try again."
      return prompt_options(message, options)
    end

    options[choice - 1][:value]
  end

  # Display usage help
  def self.help
    puts <<~HELP

      📬 Notification Console Manager - Available Commands:

      # Interactive mode
      NotificationConsoleManager.interactive_menu

      # Send notifications
      NotificationConsoleManager.send_to_user(user_id, type: :info, title: "Title", body: "Message")
      NotificationConsoleManager.send_to_users([user_id1, user_id2], type: :announcement, title: "Title", body: "Message")
      NotificationConsoleManager.send_to_all(title: "System Announcement", body: "Important message for all users")
      NotificationConsoleManager.interactive_send

      # Find and view notifications
      NotificationConsoleManager.find_notifications(user_id: 1, type: :delay, read: false, since: 1.day.ago)
      NotificationConsoleManager.interactive_find
      NotificationConsoleManager.view(notification_id)
      NotificationConsoleManager.display_notifications(notifications)

      # Get statistics
      NotificationConsoleManager.statistics
      NotificationConsoleManager.statistics(user_id)

      # Manage notifications
      NotificationConsoleManager.mark_as_read([notification_id1, notification_id2])
      NotificationConsoleManager.mark_as_unread([notification_id1, notification_id2])
      NotificationConsoleManager.delete([notification_id1, notification_id2])

      # Show this help
      NotificationConsoleManager.help
    HELP
  end
end
