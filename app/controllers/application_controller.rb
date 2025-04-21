class ApplicationController < ActionController::Base
  # Shared controller logic goes here
  skip_before_action :verify_authenticity_token
  # TODO: Fix cookies

  # Helper method to show flash messages as notifications
  def show_notification(type, title, body, data = {})
    NotificationService.notify(
      current_user,
      type: type,
      title: title,
      body: body,
      data: data
    )
  end

end
