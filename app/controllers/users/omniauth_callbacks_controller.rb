# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth "Google"
  end

  def facebook
    handle_auth "Facebook"
  end

  def failure
    redirect_to root_path, alert: "Authentication failed, please try again."
  end

  private

  def handle_auth(kind)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: kind
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.#{kind.downcase}_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
