class RoutesController < ApplicationController
  def index
    @routes = ExternalApiService.get_routes
  end
end
