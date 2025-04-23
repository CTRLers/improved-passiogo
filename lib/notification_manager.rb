#!/usr/bin/env ruby
# Notification Manager - Unified interface for all notification functionality
#
# This module provides a unified interface for all notification functionality,
# including sending, finding, managing, templating, and scheduling notifications.

require_relative "notification_console_manager"
require_relative "notification_templates"
require_relative "notification_scheduler"

module NotificationManager
  # Start the interactive menu
  def self.interactive_menu
    loop do
      puts "\n🔔 Notification Manager"
      puts "=" * 60

      action = NotificationConsoleManager.prompt_options(
        "Select a module:",
        [
          { value: :notifications, label: "Notifications - Send, find, and manage notifications" },
          { value: :templates, label: "Templates - Create and use notification templates" },
          { value: :scheduler, label: "Scheduler - Schedule notifications for future delivery" },
          { value: :exit, label: "Exit" }
        ]
      )

      case action
      when :notifications
        NotificationConsoleManager.interactive_menu
      when :templates
        NotificationTemplates.interactive_menu
      when :scheduler
        NotificationScheduler.interactive_menu
      when :exit
        puts "Exiting Notification Manager"
        break
      end
    end
  end

  # Display help information
  def self.help
    puts <<~HELP

      🔔 Notification Manager - Unified Interface

      This module provides a unified interface for all notification functionality,
      including sending, finding, managing, templating, and scheduling notifications.

      Available modules:

      1. NotificationConsoleManager
         - Send notifications to users
         - Find and view notifications
         - Mark notifications as read/unread
         - Delete notifications
         - View notification statistics

      2. NotificationTemplates
         - Create and manage notification templates
         - Use templates to send notifications with placeholders

      3. NotificationScheduler
         - Schedule notifications for future delivery
         - View, cancel, and manage scheduled notifications

      To start the interactive menu:
        NotificationManager.interactive_menu

      For help on specific modules:
        NotificationConsoleManager.help
        NotificationTemplates.list
        NotificationScheduler.list

    HELP
  end

  # Initialize the notification system
  def self.initialize
    # Load default templates
    NotificationTemplates.load_defaults

    puts "\n✓ Notification system initialized"
    puts "Run NotificationManager.interactive_menu to start the interactive menu"
    puts "Run NotificationManager.help for more information"
  end
end

# Initialize the notification system if this file is executed directly
NotificationManager.initialize if __FILE__ == $0
