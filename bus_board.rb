require 'json'
require 'open-uri'

WIDTH_OF_LINE_SECTION = 10
WIDTH_OF_DESTINATION_SECTION = 30
WIDTH_OF_ARRIVING_SECTION = 12

def get_application_key
  data = File.read('secrets.txt').split

  # Either substitute your API key here or write a secrets.txt file with the key in the first line
  data[0]
end

def get_json_response_from_api(request_url)
  api_response = URI.open(request_url).read
  JSON.parse(api_response)
rescue
  nil
end

class TransportApi
  def initialize
    @app_key = get_application_key
  end

  def get_two_stopcodes_nearest(latitude, longitude)
    request_url = 'https://api.tfl.gov.uk/StopPoint?stopTypes=NaptanPublicBusCoachTram' \
                  "&lat=#{latitude}&lon=#{longitude}&radius=1000&app_key=#{@app_key}"

    data = get_json_response_from_api(request_url)

    nearest_two_stopcodes = []
    data['stopPoints'].first(2).each { |stop| nearest_two_stopcodes.push(stop['naptanId']) }

    nearest_two_stopcodes
  end

  def get_live_bus_stop(stopcode)
    request_url = "https://api.tfl.gov.uk/StopPoint/#{stopcode}/Arrivals?app_key=#{@app_key}"
    data = get_json_response_from_api(request_url)
    LiveBusStop.new(data)
  end
end

class LiveBusStop
  def initialize(data)
    @data = data
  end

  def no_buses?
    @data.empty?
  end

  def name
    @data.first['stationName']
  end

  def direction
    @data.first['direction']
  end

  def next_arrivals_summary(num_next_buses)
    arrival_summaries = []

    @data.sort_by { |object| object['timeToStation'] }
         .first(num_next_buses).each { |bus_data|
      arriving_bus = Bus.new(bus_data)
      arrival_summaries.push(arriving_bus.arrival_summary)
    }

    arrival_summaries.join("\n")
  end
end

class Bus
  def initialize(data)
    @data = data
  end

  def line_name
    @data['lineName']
  end

  def time_until_arrival
    time_in_minutes = @data['timeToStation'] * 0.01
    time_in_minutes.round
  end

  def destination_name
    @data['destinationName']
  end

  def arrival_summary
    line_name.ljust(WIDTH_OF_LINE_SECTION) +
      destination_name.ljust(WIDTH_OF_DESTINATION_SECTION) +
      time_until_arrival.to_s + ' min'
  end
end

class PostcodeApi
  def get_postcode_details(postcode)
    postcode_data = get_json_response_from_api("https://api.postcodes.io/postcodes/#{postcode}")

    return nil if postcode_data.nil?

    Postcode.new(postcode_data)
  end
end

class Postcode
  def initialize(data)
    @data = data['result']
  end

  def longitude
    @data['longitude']
  end

  def latitude
    @data['latitude']
  end
end

def ask_user_for_postcode
  puts
  puts 'Welcome to BusBoard.'
  puts
  puts 'Please input a postcode: '
  gets.chomp
end

def display_busboard(stop)
  puts
  puts "These are the upcoming #{stop.direction} buses at " + stop.name + ':'
  puts
  puts 'Line'.ljust(WIDTH_OF_LINE_SECTION) + 'Destination'.ljust(WIDTH_OF_DESTINATION_SECTION) + 'Arriving in'
  puts '-' * (WIDTH_OF_LINE_SECTION + WIDTH_OF_DESTINATION_SECTION + WIDTH_OF_ARRIVING_SECTION)
  puts stop.next_arrivals_summary(5)
  puts
end

def display_error(error_message)
  puts
  puts error_message
  puts
end

def get_stops_from_postcode(postcode_details)
  transport_api = TransportApi.new

  stopcodes = transport_api.get_two_stopcodes_nearest(postcode_details.latitude, postcode_details.longitude)

  stops = []
  stopcodes.each { |stopcode| stops.push(transport_api.get_live_bus_stop(stopcode)) }
  stops
end

def run_app
  postcode_api = PostcodeApi.new

  postcode = ask_user_for_postcode

  return display_error('No postcode was entered.') if postcode == ''

  postcode_details = postcode_api.get_postcode_details(postcode)

  return display_error('That is not a valid postcode.') if postcode_details.nil?

  @stops = get_stops_from_postcode(postcode_details)

  return display_error('There are no buses near that postcode at the moment.') if @stops.all?(&:no_buses?)

  @stops.each { |stop| display_busboard(stop) }
end

run_app
