class RetryIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :sources, :mmsi, unique: false
  end
end
