require 'json'
require 'open-uri'

class BaseApi < ApplicationRecord
  def get_json_response_from_api(request_url)
    api_response = URI.open(request_url).read
    JSON.parse(api_response)
  rescue
    nil
  end
end
