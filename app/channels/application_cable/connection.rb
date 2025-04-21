module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      Rails.logger.info "ActionCable attempting to connect"
      self.current_user = find_verified_user
      Rails.logger.info "ActionCable connected as user #{current_user.id}" if current_user
    end

    private

    def find_verified_user
      # Try to find user from different cookie formats
      user = nil

      # Log cookie information for debugging
      Rails.logger.info "ActionCable cookies: #{cookies.to_h.keys}"

      # Try user.id cookie (set by Warden hooks)
      if cookies.signed["user.id"].present?
        Rails.logger.info "Found user.id cookie: #{cookies.signed["user.id"]}"
        user = User.find_by(id: cookies.signed["user.id"])
      end

      # Try user_id cookie (our backup)
      if user.nil? && cookies.signed[:user_id].present?
        Rails.logger.info "Found user_id cookie: #{cookies.signed[:user_id]}"
        user = User.find_by(id: cookies.signed[:user_id])
      end

      # For development, fallback to first user
      if user.nil? && Rails.env.development?
        Rails.logger.info "No user found in cookies, using first user for development"
        user = User.first
      end

      if user
        user
      else
        Rails.logger.error "ActionCable rejected connection - no user found"
        reject_unauthorized_connection
      end
    end
  end
end
