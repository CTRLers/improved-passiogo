class RoutesController < ApplicationController
  before_action :authenticate_user!

  def index
    @routes = ExternalApiService.get_routes.map do |route|
      # Retrieve stops data from the external API for this route
      stops_data = ExternalApiService.get_route_stops(route["id"])

      # Extract stop names from the stops data
      stops_names = stops_data.map { |stop| stop["name"] }

      # Build a timeline based on stops data.
      # Here we're assuming each stop includes a "time" field; adjust as needed.
      timeline = stops_data.map do |stop|
        OpenStruct.new(
          time: stop["time"] || "TBD",
          stop_name: stop["name"],
          stop_id: stop["id"]
        )
      end

      # Expand the route hash with the additional fields using OpenStruct
      OpenStruct.new(
        name: route["name"],
        on_time?: route["on_time"],
        delay: route["delay"],
        start_time: route["start_time"],
        end_time: route["end_time"],
        frequency: route["frequency"],
        stops: stops_names,
        timeline: timeline
      )
    end
  end


  def show
    @route = ExternalApiService.get_route(params[:id]) # Fixed params syntax
    @stops = ExternalApiService.get_route_stops(params[:id])
  end

  def notify_delay
    @route = Route.find(params[:id])
    delay_minutes = params[:delay_minutes].to_i

    users = User.subscribed_to_route(@route.id)

    NotificationService.notify(
      users,
      type: :delay,
      title: "Route Delay",
      body: "Route #{@route.name} is delayed by #{delay_minutes} minutes",
      data: {

      }
    )

    head :ok
  end

  def test_notification
    NotificationService.notify(
      current_user,
      type: :announcement,
      title: "Test Notification",
      body: "This is a test notification message",
      data: {}  # Remove route_id since it's not needed for test
    )

    head :ok
  end
end
