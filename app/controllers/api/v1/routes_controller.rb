module Api
  module V1
    class RoutesController < ApplicationController
      def index
        routes = ExternalApiService.get_routes
        render json: routes
      end
      
      def show
        route = ExternalApiService.get_route(params[:id])
        render json: route
      end
    end
  end
end

# app/controllers/api/v1/stops_controller.rb
module Api
  module V1
    class StopsController < ApplicationController
      def index
        stops = ExternalApiService.get_stops
        render json: stops
      end
      
      def show
        stops = ExternalApiService.get_stops
        stop = stops[params[:id]]
        render json: stop
      end
      
      def by_route
        stops = ExternalApiService.get_route_stops(params[:route_id])
        render json: stops
      end
    end
  end
end
