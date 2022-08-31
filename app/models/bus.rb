class Bus < ApplicationRecord
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
    [line_name, destination_name, time_until_arrival]
  end
end
