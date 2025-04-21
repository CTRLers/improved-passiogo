#!/usr/bin/env ruby
# Notification CLI - Command Line Interface for managing notifications
# 
# Usage: rails runner lib/notification_cli.rb [command] [options]
#
# This script provides a command-line interface for managing notifications.
# It can be run directly from the command line using the Rails runner.

require_relative 'notification_console_manager'

class NotificationCLI
  def self.run(args = ARGV)
    command = args.shift&.to_sym
    
    case command
    when :help, nil
      show_help
    when :menu, :interactive
      NotificationConsoleManager.interactive_menu
    when :send
      handle_send(args)
    when :find
      handle_find(args)
    when :view
      handle_view(args)
    when :stats
      handle_stats(args)
    when :mark_read
      handle_mark_read(args)
    when :mark_unread
      handle_mark_unread(args)
    when :delete
      handle_delete(args)
    else
      puts "Unknown command: #{command}"
      show_help
    end
  end
  
  def self.show_help
    puts <<~HELP
      Notification CLI - Command Line Interface for managing notifications
      
      Usage: rails runner lib/notification_cli.rb [command] [options]
      
      Commands:
        help                    Show this help message
        menu, interactive       Start the interactive menu
        send [options]          Send a notification
        find [options]          Find notifications
        view [id]               View a specific notification
        stats [user_id]         View notification statistics
        mark_read [ids]         Mark notifications as read
        mark_unread [ids]       Mark notifications as unread
        delete [ids]            Delete notifications
      
      Examples:
        rails runner lib/notification_cli.rb menu
        rails runner lib/notification_cli.rb send --user=1 --type=info --title="Test" --body="Test message"
        rails runner lib/notification_cli.rb find --user=1 --type=info --unread
        rails runner lib/notification_cli.rb view 123
        rails runner lib/notification_cli.rb stats 1
        rails runner lib/notification_cli.rb mark_read 1,2,3
        rails runner lib/notification_cli.rb mark_unread 1,2,3
        rails runner lib/notification_cli.rb delete 1,2,3
    HELP
  end
  
  def self.handle_send(args)
    options = parse_options(args)
    
    if options[:interactive]
      NotificationConsoleManager.interactive_send
      return
    end
    
    # Check required parameters
    unless options[:user] || options[:users] || options[:all]
      puts "Error: You must specify a recipient (--user, --users, or --all)"
      return
    end
    
    unless options[:title] && options[:body]
      puts "Error: You must specify a title and body"
      return
    end
    
    # Send notification based on recipient type
    if options[:user]
      NotificationConsoleManager.send_to_user(
        options[:user].to_i,
        type: (options[:type] || :info).to_sym,
        title: options[:title],
        body: options[:body],
        data: options[:data] || {}
      )
    elsif options[:users]
      user_ids = options[:users].split(',').map(&:strip).map(&:to_i)
      NotificationConsoleManager.send_to_users(
        user_ids,
        type: (options[:type] || :info).to_sym,
        title: options[:title],
        body: options[:body],
        data: options[:data] || {}
      )
    elsif options[:all]
      NotificationConsoleManager.send_to_all(
        type: (options[:type] || :announcement).to_sym,
        title: options[:title],
        body: options[:body],
        data: options[:data] || {}
      )
    end
  end
  
  def self.handle_find(args)
    options = parse_options(args)
    
    if options[:interactive]
      NotificationConsoleManager.interactive_find
      return
    end
    
    # Build query options
    query_options = {}
    
    query_options[:user_id] = options[:user].to_i if options[:user]
    query_options[:type] = options[:type].to_sym if options[:type]
    query_options[:read] = true if options[:read]
    query_options[:read] = false if options[:unread]
    query_options[:since] = options[:since].to_i.days.ago if options[:since]
    query_options[:until] = options[:until].to_i.days.ago if options[:until]
    query_options[:search] = options[:search] if options[:search]
    query_options[:limit] = options[:limit].to_i if options[:limit]
    
    # Find and display notifications
    notifications = NotificationConsoleManager.find_notifications(query_options)
    NotificationConsoleManager.display_notifications(notifications)
  end
  
  def self.handle_view(args)
    if args.empty?
      puts "Error: You must specify a notification ID"
      return
    end
    
    notification_id = args.first.to_i
    NotificationConsoleManager.view(notification_id)
  end
  
  def self.handle_stats(args)
    user_id = args.first&.to_i
    NotificationConsoleManager.statistics(user_id)
  end
  
  def self.handle_mark_read(args)
    if args.empty?
      puts "Error: You must specify notification IDs"
      return
    end
    
    notification_ids = args.first.split(',').map(&:strip).map(&:to_i)
    NotificationConsoleManager.mark_as_read(notification_ids)
  end
  
  def self.handle_mark_unread(args)
    if args.empty?
      puts "Error: You must specify notification IDs"
      return
    end
    
    notification_ids = args.first.split(',').map(&:strip).map(&:to_i)
    NotificationConsoleManager.mark_as_unread(notification_ids)
  end
  
  def self.handle_delete(args)
    if args.empty?
      puts "Error: You must specify notification IDs"
      return
    end
    
    notification_ids = args.first.split(',').map(&:strip).map(&:to_i)
    
    puts "Are you sure you want to delete #{notification_ids.size} notification(s)? (y/n)"
    confirm = STDIN.gets.chomp.downcase
    
    if confirm == 'y'
      NotificationConsoleManager.delete(notification_ids)
    else
      puts "Delete operation cancelled"
    end
  end
  
  def self.parse_options(args)
    options = {}
    
    args.each do |arg|
      if arg.start_with?('--')
        key, value = arg[2..-1].split('=')
        options[key.to_sym] = value || true
      end
    end
    
    options
  end
end

# Run the CLI if this file is executed directly
NotificationCLI.run if __FILE__ == $0
