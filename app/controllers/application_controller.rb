
class ApplicationController < ActionController::Base
  # Shared controller logic goes here
  skip_before_action :verify_authenticity_token
  # TODO: Fix cookies
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
