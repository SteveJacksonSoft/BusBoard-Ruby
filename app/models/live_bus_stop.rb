class LiveBusStop < ApplicationRecord
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
         .first(num_next_buses).each do |bus_data|
      arriving_bus = Bus.new(bus_data)
      arrival_summaries.push(arriving_bus.arrival_summary)
    end

    arrival_summaries
  end
end
