# Direct Banner Test
# This script provides a way to test the notification banner directly from the Rails console
# Load this file in the Rails console with: load 'lib/direct_banner_test.rb'

def show_banner(user_id = nil, options = {})
  # Find a user
  user = user_id ? User.find(user_id) : User.first

  unless user
    puts "Error: No users found"
    return
  end

  # Default options
  options[:title] ||= "Direct Banner Test"
  options[:body] ||= "This is a direct banner test sent at #{Time.current.strftime('%H:%M:%S')}"
  options[:type] ||= :info

  puts "Testing direct banner for user ##{user.id} (#{user.email})"
  puts "Title: #{options[:title]}"
  puts "Body: #{options[:body]}"
  puts "Type: #{options[:type]}"

  # Create a notification record
  notification = user.user_notifications.create!(
    title: options[:title],
    body: options[:body],
    notification_type: options[:type],
    data: { direct_test: true }
  )

  puts "Created notification ##{notification.id}"
  puts "Now run this JavaScript in your browser console:"
  puts "window.showDirectBanner('#{options[:title]}', '#{options[:body]}', '#{options[:type]}')"

  notification
end

puts "Direct banner test loaded"
puts "Run show_banner(user_id, options) to test"
puts "Example: show_banner(nil, { title: 'Hello', body: 'World', type: :info })"
