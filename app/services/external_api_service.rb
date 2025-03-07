# app/services/external_api_service.rb 
# internal api
require "net/http"
require "json"

class ExternalApiService
  BASE_URL = "http://localhost:8000" # Change this to the actual URL where FastAPI is running

  def self.get_routes
    uri = URI("#{BASE_URL}/routes")
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data.values
    else
      Rails.logger.error("Failed to fetch routes: #{response.message}")
      []
    end
  end

  def self.get_route(route_id)
    uri = URI("#{BASE_URL}/routes/#{route_id}")
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data
    else
      Rails.logger.error("Failed to fetch route #{route_id}: #{response.message}")
      nil
    end
  end

  def self.get_stops
    uri = URI("#{BASE_URL}/stops")
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data.values
    else
      Rails.logger.error("Failed to fetch stops: #{response.message}")
      []
    end
  end

  def self.get_stop(stop_id)
    uri = URI("#{BASE_URL}/stops/#{stop_id}")
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data
    else
      Rails.logger.error("Failed to fetch routes: #{response.message}")
      []
    end
  end

  def self.get_route_stops(route_id)
    uri = URI("#{BASE_URL}/routes/#{route_id}/stops")
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data.values
    else
      Rails.logger.error("Failed to fetch stops for route #{route_id}: #{response.message}")
      []
    end
  end
end
