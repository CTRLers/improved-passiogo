class RoutesController < ApplicationController
  def index
    @routes = ExternalApiService.get_routes
  end
  
  def show
    @route = ExternalApiService.get_route(params[:id])
    @stops = ExternalApiService.get_route_stops(params[:id])
  end
end
