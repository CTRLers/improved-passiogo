class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "NotificationsChannel: User #{current_user.id} subscribed"
    stream_for current_user
  end

  def unsubscribed
    Rails.logger.info "NotificationsChannel: User #{current_user.id} unsubscribed"
    # Any cleanup needed when channel is unsubscribed
  end

  # Add a test method that can be called from the client
  def test_notification
    Rails.logger.info "NotificationsChannel: Test notification requested by user #{current_user.id}"
    NotificationService.notify(
      current_user,
      type: :info,
      title: "Test Channel Notification",
      body: "This is a test notification sent directly through the channel at #{Time.current.strftime('%H:%M:%S')}",
      data: { test: true }
    )
  end
end
