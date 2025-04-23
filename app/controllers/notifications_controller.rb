class NotificationsController < ApplicationController
  before_action :authenticate_user!, except: [ :test_page ]
  before_action :set_notification, only: [ :mark_as_read, :mark_as_unread ]

  def index
    @notifications = current_user.user_notifications
                                .order(created_at: :desc)
                                .page(params[:page])
  end

  def mark_all_as_read
    current_user.user_notifications.unread.update_all(read_at: Time.current)
    head :ok
  end

  def mark_as_read
    @notification.mark_as_read!
    head :ok
  end

  def mark_as_unread
    @notification.mark_as_unread!
    head :ok
  end

  # POST /notifications/test
  def test
    # Create a test notification
    notification = current_user.user_notifications.create!(
      title: "Test Notification",
      body: "This is a test notification created at #{Time.current.strftime('%H:%M:%S')}",
      notification_type: params[:type] || :info,
      data: { test: true }
    )

    # Broadcast the notification
    NotificationsChannel.broadcast_to(
      current_user,
      {
        id: notification.id,
        type: params[:type] || :info,
        title: notification.title,
        body: notification.body,
        data: notification.data
      }
    )

    respond_to do |format|
      format.html { redirect_back(fallback_location: notifications_path, notice: "Test notification sent") }
      format.json { render json: { success: true, notification: notification } }
    end
  end

  # GET /notifications/test_page
  def test_page
    # Simple page to test notifications
    render layout: false
  end

  private

  def set_notification
    @notification = current_user.user_notifications.find(params[:id])
  end
end
