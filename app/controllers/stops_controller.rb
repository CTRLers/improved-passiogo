
class StopsController < ApplicationController
  def index
    @stops = ExternalApiService.get_stops
  end

  def show
    @stop_id = params[:id] # Fixed param syntax
    @stops = ExternalApiService.get_stops
    @stop = @stops[@stop_id]
  end
end
