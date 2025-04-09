class ApplicationController < ActionController::Base
  # Shared controller logic goes here
  skip_before_action :verify_authenticity_token
  # TODO: Fix cookies
end
