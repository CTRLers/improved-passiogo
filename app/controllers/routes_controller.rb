class RoutesController < ApplicationController
  def index
    # @routes = ExternalApiService.get_routes.map do |route|
    #   route["stops"] = ExternalApiService.get_route_stops(route["id"])
    #   route
    # end

    @routes = [
      OpenStruct.new(
        name: "Route A – Campus Loop",
        on_time?: true,
        delay: 0,
        start_time: "7:00 AM",
        end_time: "9:00 PM",
        frequency: 10,
        stops: [ "Library", "Engineering", "University Mall" ],
        timeline: [
          OpenStruct.new(time: "7:10 AM", stop_name: "Library"),
          OpenStruct.new(time: "7:15 AM", stop_name: "Engineering"),
          OpenStruct.new(time: "7:25 AM", stop_name: "University Mall")
        ]
      )
      # Add additional route objects here
    ]
  end

  def show
    @route = ExternalApiService.get_route(params[:id]) # Fixed params syntax
    @stops = ExternalApiService.get_route_stops(params[:id])
  end
end
