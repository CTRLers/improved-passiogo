class StopsController < ApplicationController
  def index
    @stops = ExternalApiService.get_stops
  end
  
  def show
    # This will need adjustment since your FastAPI doesn't have a direct stop endpoint
    @stop_id = params[:id]
    @stops = ExternalApiService.get_stops
    @stop = @stops[@stop_id]
  end
end
