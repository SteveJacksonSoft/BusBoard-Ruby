class BusTimes

  def initialize(stop_code, number_of_buses_requested, bus_service = BusService.new)
    @stop_code = stop_code
    @number_of_buses_requested = number_of_buses_requested
    @bus_service = bus_service
  end

  def next_arrivals_at_stop

    @bus_service.get_times_of_next_buses_at_stop(@stop_code, @number_of_buses_requested)
  end
end
