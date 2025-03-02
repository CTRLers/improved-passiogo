module Api
  module V1
    class StopsController < ApplicationController
      def index
        stops = ExternalApiService.get_stops
        render json: stops
      end

      def show
        stop = ExternalApiService.get_stop(params[:id])
        render json: stop
      end

      def by_route
        stops = ExternalApiService.get_route_stops(params[:route_id])
        render json: stops
      end
    end
   end
  end

