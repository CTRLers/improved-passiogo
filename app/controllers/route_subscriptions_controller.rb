class RouteSubscriptionsController < ApplicationController
  before_action :set_user

  # POST /users/:user_id/route_subscriptions
  def create
    # Retrieve the route ID from the nested parameters
    route = Route.find(params[:route_subscription][:route_id])
    @user.subscribe_to_route(route)
    redirect_to @user, notice: "Route subscription added."
  end

  # DELETE /users/:user_id/route_subscriptions/:id
  def destroy
    # Find the subscription by its ID
    subscription = @user.route_subscriptions.find(params[:id])
    route = subscription.route
    @user.unsubscribe_from_route(route)
    redirect_to @user, notice: "Route subscription removed."
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
