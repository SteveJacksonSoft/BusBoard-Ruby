# frozen_string_literal: true

module Buses
  class BusService
    def initialize(api_client)
      @client = api_client
    end

    def get_times_of_next_buses_at_stop(stop_code, number_of_buses)
      next_buses = @client.get_next_buses_for_stop_point_id(stop_code)
      buses_ordered_by_arrival_time = next_buses.sort do |bus1, bus2|
        bus1[:expectedArrival.to_s] <=> bus2[:expectedArrival.to_s]
      end
      buses_to_show = buses_ordered_by_arrival_time[0..(number_of_buses - 1)]
      buses_to_show.map { |bus| bus[:expectedArrival.to_s] }
    end
  end
end
