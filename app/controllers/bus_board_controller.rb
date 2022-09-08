class BusBoardController < ApplicationController
  def index
  end

  def bus_times
    number_of_buses = 5

    @stop_code = params[:stop_code]
    @bus_times = BusTimes.new(@stop_code, number_of_buses)
  end
end
