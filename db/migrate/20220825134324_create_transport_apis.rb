class CreateTransportApis < ActiveRecord::Migration[6.0]
  def change
    create_table :transport_apis do |t|

      t.timestamps
    end
  end
end
