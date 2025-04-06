class StopSubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # POST /stop_subscriptions
  def create
    stop = Stop.find(params[:stop_subscription][:stop_id])
    @user.subscribe_to_stop(stop)
    redirect_to user_path(@user), notice: "Stop subscription added."
  end

  # DELETE /stop_subscriptions/:id
  def destroy
    subscription = @user.stop_subscriptions.find(params[:id])
    stop = subscription.stop
    @user.unsubscribe_from_stop(stop)
    redirect_to user_path(@user), notice: "Stop subscription removed."
  end

  private

  def set_user
    @user = current_user
  end
end
