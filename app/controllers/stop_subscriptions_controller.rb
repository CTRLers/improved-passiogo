class StopSubscriptionsController < ApplicationController
  before_action :set_user

  # POST /users/:user_id/stop_subscriptions
  def create
    # Retrieve the stop ID from the nested params
    stop = Stop.find(params[:stop_subscription][:stop_id])
    @user.subscribe_to_stop(stop)
    redirect_to @user, notice: "Stop subscription added."
  end

  # DELETE /users/:user_id/stop_subscriptions/:id
  def destroy
    # Find the stop subscription using the subscription ID provided in params
    subscription = @user.stop_subscriptions.find(params[:id])
    stop = subscription.stop
    @user.unsubscribe_from_stop(stop)
    redirect_to @user, notice: "Stop subscription removed."
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
