class PostcodeApi < BaseApi
  def get_postcode_details(postcode)
    postcode_data = get_json_response_from_api("https://api.postcodes.io/postcodes/#{postcode}")

    return nil if postcode_data.nil?

    Postcode.new(postcode_data)
  end

  def get_json_response_from_api(request_url)
    super
  end
end
