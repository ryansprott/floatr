class CreateType24Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type24_specifics do |t|
      t.references :message, foreign_key: true
      t.string :callsign
      t.string :ship_name
      t.integer :ship_cargo_type
      t.string :vendor_id
      t.integer :model_code
      t.integer :serial_number
      t.integer :mothership_mmsi
    end
  end
end
