class RouteSubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # POST /route_subscriptions
  def create
    route = Route.find(params[:route_subscription][:route_id])
    @user.subscribe_to_route(route)
    redirect_to user_path(@user), notice: "Route subscription added."
  end

  # DELETE /route_subscriptions/:id
  def destroy
    subscription = @user.route_subscriptions.find(params[:id])
    route = subscription.route
    @user.unsubscribe_from_route(route)
    redirect_to user_path(@user), notice: "Route subscription removed."
  end

  private

  def set_user
    @user = current_user
  end
end
