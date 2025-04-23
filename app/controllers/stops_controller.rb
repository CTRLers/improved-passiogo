
class StopsController < ApplicationController
  def index
    # Get all stops
    @stops = ExternalApiService.get_stops


    # Get all routes
    routes = ExternalApiService.get_routes

    # Create a map of route_id to route details
    route_map = {}
    routes.each do |route|
      route_map[route["id"]] = {
        "name" => route["name"],
        "color" => route["color"] || "#3B82F6" # Default to blue if no color specified
      }
    end

    # For each route, get its stops and build a mapping of stop_id to routes
    stop_routes_map = {}

    routes.each do |route|
      route_id = route["id"]
      route_stops = ExternalApiService.get_route_stops(route_id)

      route_stops.each do |stop|
        stop_id = stop["id"]
        stop_routes_map[stop_id] ||= []
        stop_routes_map[stop_id] << {
          "id" => route_id,
          "name" => route["name"],
          "color" => route["color"] || "#3B82F6"
        }
      end
    end

    # Enhance stops with route information
    @stops.each do |stop|
      stop_id = stop["id"]

      # Add routes that serve this stop
      if stop_routes_map[stop_id].present?
        stop["routes"] = stop_routes_map[stop_id]
      else
        stop["routes"] = []
      end

      # For backward compatibility
      if stop["route_id"].present?
        stop["route_name"] = route_map[stop["route_id"]]["name"]
      end
    end
  end

  def show
    @stop_id = params[:id] # Fixed param syntax
    @stop = ExternalApiService.get_stop(@stop_id)

    # Get all routes
    routes = ExternalApiService.get_routes

    # Create a map of route_id to route details
    route_map = {}
    routes.each do |route|
      route_map[route["id"]] = {
        "name" => route["name"],
        "color" => route["color"] || "#3B82F6" # Default to blue if no color specified
      }
    end

    # For each route, check if this stop is included
    @stop["routes"] = []

    routes.each do |route|
      route_id = route["id"]
      route_stops = ExternalApiService.get_route_stops(route_id)

      # Check if this stop is in the route's stops
      route_stops.each do |route_stop|
        if route_stop["id"] == @stop_id
          @stop["routes"] << {
            "id" => route_id,
            "name" => route["name"],
            "color" => route["color"] || "#3B82F6"
          }
          break
        end
      end
    end
  end
end
