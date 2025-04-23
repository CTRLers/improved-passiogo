namespace :notification do
  desc "Test the notification system"
  task :test, [ :user_id ] => :environment do |t, args|
    require_relative "../notification_test"

    user_id = args[:user_id]
    NotificationTest.run_all_tests(user_id)
  end

  desc "Send a direct test notification"
  task :direct, [ :user_id ] => :environment do |t, args|
    require_relative "../notification_test"

    user_id = args[:user_id]
    NotificationTest.send_test_notification(user_id)
  end

  desc "Test the notification service"
  task :service, [ :user_id ] => :environment do |t, args|
    require_relative "../notification_test"

    user_id = args[:user_id]
    NotificationTest.test_notification_service(user_id)
  end

  desc "Test the notification console manager"
  task :console, [ :user_id ] => :environment do |t, args|
    require_relative "../notification_test"

    user_id = args[:user_id]
    NotificationTest.test_console_manager(user_id)
  end
end
