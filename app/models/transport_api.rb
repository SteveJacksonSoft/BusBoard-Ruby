class TransportApi < BaseApi
  def initialize
    @app_key = get_application_key
  end

  def get_application_key
    # Add your API key here
  end

  def get_nearest_stopcodes(num_stopcodes, latitude, longitude)
    request_url = 'https://api.tfl.gov.uk/StopPoint?stopTypes=NaptanPublicBusCoachTram' \
                  "&lat=#{latitude}&lon=#{longitude}&radius=1000&app_key=#{@app_key}"

    data = get_json_response_from_api(request_url)

    nearest_two_stopcodes = []
    data['stopPoints'].first(num_stopcodes).each { |stop| nearest_two_stopcodes.push(stop['naptanId']) }

    nearest_two_stopcodes
  end

  def get_live_bus_stop(stopcode)
    request_url = "https://api.tfl.gov.uk/StopPoint/#{stopcode}/Arrivals?app_key=#{@app_key}"
    data = get_json_response_from_api(request_url)
    LiveBusStop.new(data)
  end

  def get_json_response_from_api(request_url)
    super
  end
end
