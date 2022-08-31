class PagesController < ApplicationController
  def home; end

  def bus_board
    postcode_api = PostcodeApi.new

    postcode = params[:postcode]

    return return_view_with_error_message('Enter a postcode.') if postcode.empty?

    postcode_details = postcode_api.get_postcode_details(postcode)

    return return_view_with_error_message('That is not a valid postcode.') if postcode_details.nil?

    @stops = get_stops_from_postcode(postcode_details)

    if @stops.all?(&:no_buses?)
      return return_view_with_error_message('There are no buses near that postcode at the moment.')
    end

    flash.each { |type| flash.discard(type) }

    @stops
  end

  def get_stops_from_postcode(postcode_details)
    transport_api = TransportApi.new

    stopcodes = transport_api.get_nearest_stopcodes(2, postcode_details.latitude, postcode_details.longitude)

    stops = []
    stopcodes.each { |stopcode| stops.push(transport_api.get_live_bus_stop(stopcode)) }
    stops
  end

  def return_view_with_error_message(error_message)
    flash[:alert] = error_message
    render action: :home
  end
end
