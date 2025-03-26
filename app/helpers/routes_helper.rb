module RoutesHelper
  def fetch_stops(route_id)
    ExternalApiService.get_route_stops(route_id)
  end
end
