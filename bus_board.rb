require 'json'
require 'open-uri'

WIDTH_OF_LINE_SECTION = 10
WIDTH_OF_DESTINATION_SECTION = 30
WIDTH_OF_ARRIVING_SECTION = 12

class LiveBusStop
  def initialize(data)
    @data = data
  end

  def name
    @data.first['stationName']
  end

  def next_arrivals_summary(num_next_buses)
    arrival_summaries = []

    @data.sort_by { |object| object['timeToStation'] }
         .first(num_next_buses).each do |bus_data|
      arriving_bus = Bus.new(bus_data)
      arrival_summaries.push(arriving_bus.arrival_summary)
    end

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

def get_stopcode_from_user_input
  puts
  puts 'Welcome to BusBoard.'
  puts
  puts 'Please input a stop code: '
  return gets.chomp
end

def get_application_key
  data = File.read('secrets.txt').split

  # Either substitute your API key here or write a secrets.txt file with the key in the first line
  data[0]
end

def get_stop_data_from_api(stopcode)
  app_key = get_application_key
  request_url = "https://api.tfl.gov.uk/StopPoint/#{stopcode}/Arrivals?app_key=#{app_key}"

  api_response_serialised = URI.open(request_url).read
  api_response_json = JSON.parse(api_response_serialised)

  LiveBusStop.new(api_response_json)
end

def display_busboard(stop)
  puts
  puts 'These are the upcoming buses at ' + stop.name + ':'
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

def run_app
  stopcode = get_stopcode_from_user_input

  return display_error('No stop code was entered.') if stopcode.empty?

  begin
    stop = get_stop_data_from_api(stopcode)
  rescue
    display_error('That is an invalid stop code.')
  else
    display_busboard(stop)
  end
end

run_app
