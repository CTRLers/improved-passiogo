class UsersController < ApplicationController
  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      # (Optionally sign in the user here)
      redirect_to @user, notice: 'Account created successfully.'
    else
      render :new
    end
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: 'Account deleted successfully.'
  end

  private

  def user_params
    # Adjust permitted params as needed (if using has_secure_password, password & confirmation are required)
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :fcm_token)
  end
end
