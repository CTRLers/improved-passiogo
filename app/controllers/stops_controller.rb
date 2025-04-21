
class StopsController < ApplicationController
  def index
    # Get all stops
    @stops = ExternalApiService.get_stops

    # Get all routes to find route names for stops
    routes = ExternalApiService.get_routes

    # Create a map of route_id to route_name
    route_map = {}
    routes.each do |route|
      route_map[route['id']] = route['name']
    end

    # Enhance stops with route information if available
    @stops.each do |stop|
      if stop['route_id'].present?
        stop['route_name'] = route_map[stop['route_id']]
      end
    end
  end

  def show
    @stop_id = params[:id] # Fixed param syntax
    @stop = ExternalApiService.get_stop(@stop_id)
  end
end
