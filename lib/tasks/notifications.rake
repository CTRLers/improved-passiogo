namespace :notifications do
  desc "Start the interactive notification manager"
  task :manager => :environment do
    require_relative '../notification_manager'
    NotificationManager.interactive_menu
  end
  
  desc "Process due scheduled notifications"
  task :process_due => :environment do
    require_relative '../notification_scheduler'
    NotificationScheduler.process_due
  end
  
  desc "Send a test notification to a user"
  task :test, [:user_id] => :environment do |t, args|
    user_id = args[:user_id] || User.first&.id
    
    unless user_id
      puts "Error: No users found in the database"
      next
    end
    
    require_relative '../notification_console_manager'
    NotificationConsoleManager.send_to_user(
      user_id,
      type: :info,
      title: "Test Notification",
      body: "This is a test notification sent at #{Time.current.strftime('%H:%M:%S')}"
    )
  end
  
  desc "Show notification statistics"
  task :stats, [:user_id] => :environment do |t, args|
    require_relative '../notification_console_manager'
    
    if args[:user_id]
      NotificationConsoleManager.statistics(args[:user_id].to_i)
    else
      NotificationConsoleManager.statistics
    end
  end
  
  desc "Initialize the notification system with default templates"
  task :init => :environment do
    require_relative '../notification_manager'
    NotificationManager.initialize
  end
end
