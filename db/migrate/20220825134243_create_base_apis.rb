class CreateBaseApis < ActiveRecord::Migration[6.0]
  def change
    create_table :base_apis do |t|

      t.timestamps
    end
  end
end
