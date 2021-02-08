class AddColumnsToSources < ActiveRecord::Migration[6.0]
  def change
    change_table :sources do |t|
      t.string :ship_name
      t.string :callsign
    end
  end
end
