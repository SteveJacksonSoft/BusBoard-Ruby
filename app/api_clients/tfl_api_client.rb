# frozen_string_literal: true
require 'uri'
require 'faraday'

class TflApiClient
  TFL_API_BASE_URL = 'https://api.tfl.gov.uk'

  def get_next_buses_for_stop_point_id(stop_point_id)
    safe_stop_point_id = URI.encode_www_form_component(stop_point_id)
    api_endpoint = "/StopPoint/#{safe_stop_point_id}/Arrivals"
    get api_endpoint
  end

  private

  def client
    Faraday.new do |config|
      config.response :json
      config.adapter :net_http
    end
  end

  def error_if_unsuccessful(http_response)
    raise BadRequestError, "Received response #{http_response.body}" unless http_response.success?
  end

  def get(api_endpoint)
    request_target = TFL_API_BASE_URL + api_endpoint
    begin
      response = client.get(request_target)
      error_if_unsuccessful(response)
      response.body
    rescue BadRequestError => e
      raise(BadRequestError, "Request to #{request_target} failed: " + e.message)
    end
  end
end
