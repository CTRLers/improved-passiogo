module Api
  module V1
    class StopsController < ApplicationController
      def index
        stops = ExternalApiService.get_stops
        render json: stops
      end
      
      def show
        stops = ExternalApiService.get_stops
        stop = stops[params[:id]
        render json: stop
      end
      
      def by_route
        stops = ExternalApiService.get_route_stops(param[:route_id])
        render json: stops
      end
    end
  end
endstops_controller.rb
