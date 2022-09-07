require_relative 'api_clients'
require_relative 'buses'
require_relative 'ui'

def bus_board
  number_of_buses = 5

  program_interface = Ui::ProgramInterface.new
  api_client = ApiClients::TflApiClient.new
  bus_service = Buses::BusService.new(api_client)

  stop_code = program_interface.run_and_get_input

  next_buses = bus_service.get_times_of_next_buses_at_stop(stop_code, number_of_buses)

  program_interface.output(next_buses)
end

bus_board
