
class StopsController < ApplicationController
  def index
    @stops = ExternalApiService.get_stops
  end

  def show
    @stop_id = params[:id] # Fixed param syntax
    @stop = ExternalApiService.get_stop(@stop_id)
  end
end
