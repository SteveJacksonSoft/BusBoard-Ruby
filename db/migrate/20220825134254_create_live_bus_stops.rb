class CreateLiveBusStops < ActiveRecord::Migration[6.0]
  def change
    create_table :live_bus_stops do |t|

      t.timestamps
    end
  end
end
