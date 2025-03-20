class RouteSubscriptionsController < ApplicationController
  before_action :set_user

  # POST /users/:user_id/route_subscriptions/:route_id
  def create
    route = Route.find(params[:route_id])
    @user.subscribe_to_route(route)
    redirect_to @user, notice: "Route subscription added."
  end

  # DELETE /users/:user_id/route_subscriptions/:route_id
  def destroy
    route = Route.find(params[:route_id])
    @user.unsubscribe_from_route(route)
    redirect_to @user, notice: "Route subscription removed."
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
