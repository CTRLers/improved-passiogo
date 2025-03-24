class RoutesController < ApplicationController
  def index
    @routes = ExternalApiService.get_routes.map do |route|
      route["stops"] = ExternalApiService.get_route_stops(route["id"])
      route
    end
  end

  def show
    @route = ExternalApiService.get_route(params[:id]) # Fixed params syntax
    @stops = ExternalApiService.get_route_stops(params[:id])
  end
end
