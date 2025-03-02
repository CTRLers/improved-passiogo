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
