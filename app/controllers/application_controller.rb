class ApplicationController < ActionController::Base
  # Shared controller logic goes here
  skip_before_action :verify_authenticity_token
  # TODO: Fix cookies

  before_action :configure_permitted_parameters, if: :devise_controller?


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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name ])
  end
end
