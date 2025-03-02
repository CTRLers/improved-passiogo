module Api
  module V1
    class RoutesController < ApplicationController
      def index
        routes = ExternalApiService.get_routes
        render json: routes
      end
      
      def show
        stops = ExternalApiService.get_stops()
        id = params[:id]
        stop = stops[id]
        render(json: stop)
      end
    end
  end
end
