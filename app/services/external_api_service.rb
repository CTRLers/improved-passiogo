require 'httparty'

class ExternalApiService
  include HTTParty
  base_uri 'http://127.0.0.1:8000' # Ensure this matches your API server

  def self.get_routes
    response = get('/routes') # Adjust the endpoint if needed
    if response.success?
      data = response.parsed_response
      data.values # Extracts route objects (removing ID keys)
    else
      []
    end
  end
end
