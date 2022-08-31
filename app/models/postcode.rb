class Postcode < ApplicationRecord
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
