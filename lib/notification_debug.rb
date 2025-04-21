module NotificationDebug
  # Test the ActionCable connection by sending a notification to a specific user
  def self.test_actioncable(user_id)
    user = User.find(user_id)
    
    # Create a notification
    notification = user.user_notifications.create!(
      title: "ActionCable Test",
      body: "This is a test notification sent at #{Time.current.strftime('%H:%M:%S')}",
      notification_type: :info,
      data: { test: true, debug: true }
    )
    
    # Broadcast directly to the user's channel
    NotificationsChannel.broadcast_to(
      user,
      {
        id: notification.id,
        type: :info,
        title: "ActionCable Test",
        body: "This is a test notification sent at #{Time.current.strftime('%H:%M:%S')}",
        data: { test: true, debug: true }
      }
    )
    
    puts "\n✉️  ActionCable test notification sent to user ##{user_id}!"
    puts "Check the browser console for 'Notification received' messages"
    puts "If you don't see the notification in the browser, check the Rails logs for connection issues"
    
    notification
  end
  
  # Check the ActionCable connection status
  def self.check_connection_status
    puts "\n🔌 ActionCable Connection Status:"
    
    # Check if the ActionCable server is running
    if defined?(ActionCable::Server::Base) && ActionCable.server.present?
      puts "✓ ActionCable server is running"
    else
      puts "✗ ActionCable server is not running"
    end
    
    # Check for active connections
    if defined?(ActionCable::Server::Base) && ActionCable.server.connections.present?
      connection_count = ActionCable.server.connections.count
      puts "✓ #{connection_count} active connection(s)"
      
      # Show details of each connection
      ActionCable.server.connections.each_with_index do |connection, index|
        user = connection.current_user rescue nil
        puts "  Connection ##{index + 1}: User ##{user&.id || 'unknown'}"
      end
    else
      puts "✗ No active connections"
    end
    
    # Check for active subscriptions
    if defined?(ActionCable::SubscriptionAdapter::Base) && ActionCable.server.pubsub.present?
      puts "✓ PubSub adapter is running: #{ActionCable.server.pubsub.class.name}"
    else
      puts "✗ PubSub adapter is not running"
    end
    
    # Return connection info
    {
      server_running: defined?(ActionCable::Server::Base) && ActionCable.server.present?,
      connection_count: defined?(ActionCable::Server::Base) && ActionCable.server.connections.present? ? ActionCable.server.connections.count : 0,
      pubsub_adapter: defined?(ActionCable::SubscriptionAdapter::Base) && ActionCable.server.pubsub.present? ? ActionCable.server.pubsub.class.name : nil
    }
  end
  
  # Check if a user has a valid ActionCable connection
  def self.check_user_connection(user_id)
    user = User.find(user_id)
    
    puts "\n👤 Checking ActionCable connection for User ##{user_id}:"
    
    # Check if the user has an active connection
    if defined?(ActionCable::Server::Base) && ActionCable.server.connections.present?
      user_connections = ActionCable.server.connections.select do |connection|
        begin
          connection.current_user&.id == user.id
        rescue
          false
        end
      end
      
      if user_connections.any?
        puts "✓ User has #{user_connections.count} active connection(s)"
      else
        puts "✗ User has no active connections"
      end
    else
      puts "✗ No active connections on the server"
    end
    
    # Return connection info
    {
      user_id: user.id,
      connection_count: defined?(ActionCable::Server::Base) && ActionCable.server.connections.present? ? 
        ActionCable.server.connections.count { |c| begin; c.current_user&.id == user.id; rescue; false; end } : 0
    }
  end
  
  # List all active connections
  def self.list_connections
    puts "\n🔌 Active ActionCable Connections:"
    
    if defined?(ActionCable::Server::Base) && ActionCable.server.connections.present?
      connections = ActionCable.server.connections
      puts "Total connections: #{connections.count}"
      
      connections.each_with_index do |connection, index|
        begin
          user = connection.current_user
          user_info = user ? "User ##{user.id} (#{user.email})" : "No user"
          puts "Connection ##{index + 1}: #{user_info}"
        rescue => e
          puts "Connection ##{index + 1}: Error getting user info - #{e.message}"
        end
      end
      
      connections
    else
      puts "No active connections"
      []
    end
  end
  
  # Help method
  def self.help
    puts <<~HELP
      
      🔧 Notification Debug Tools
      
      # Test ActionCable connection
      NotificationDebug.test_actioncable(user_id)
      
      # Check ActionCable connection status
      NotificationDebug.check_connection_status
      
      # Check if a user has an active connection
      NotificationDebug.check_user_connection(user_id)
      
      # List all active connections
      NotificationDebug.list_connections
      
      # Show this help
      NotificationDebug.help
    HELP
  end
end
