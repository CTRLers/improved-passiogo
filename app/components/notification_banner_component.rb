# frozen_string_literal: true

class NotificationBannerComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
    @unread_count = user.user_notifications.unread.count
  end

  def render?
    @user.present?
  end
end
