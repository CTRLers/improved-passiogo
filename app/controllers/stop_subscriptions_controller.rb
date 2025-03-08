class StopSubscriptionsController < ApplicationController
  before_action :set_user

  # POST /users/:user_id/stop_subscriptions/:stop_id
  def create
    stop = Stop.find(params[:stop_id])
    @user.subscribe_to_stop(stop)
    redirect_to @user, notice: 'Stop subscription added.'
  end

  # DELETE /users/:user_id/stop_subscriptions/:stop_id
  def destroy
    stop = Stop.find(params[:stop_id])
    @user.unsubscribe_from_stop(stop)
    redirect_to @user, notice: 'Stop subscription removed.'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
