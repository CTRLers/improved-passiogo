class NotificationService
  def self.notify(users, type:, title:, body:, data: {})
    Array(users).each do |user|
      # Create UserNotification record
      user_notification = user.user_notifications.create!(
        title: title,
        body: body,
        notification_type: type,
        data: data
      )

      # Broadcast notification to user's channel
      NotificationsChannel.broadcast_to(
        user,
        {
          id: user_notification.id,
          type: type,
          title: title,
          body: body,
          data: data
        }
      )
    end
  end

  def self.notify_route_delay(route, delay_minutes)
    users = User.subscribed_to_route(route.id)

    notify(
      users,
      type: :delay,
      title: "Route Delay",
      body: "Route #{route.name} is delayed by #{delay_minutes} minutes",
      data: {
        route_id: route.id,
        delay_minutes: delay_minutes
      }
    )
  end

  def self.notify_announcement(title:, body:)
    users = User.subscribed_to_announcements

    notify(
      users,
      type: :announcement,
      title: title,
      body: body
    )
  end
end
