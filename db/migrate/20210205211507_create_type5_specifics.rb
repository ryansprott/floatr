class CreateType5Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type5_specifics do |t|
      t.references :message, foreign_key: true
      t.integer :ais_version
      t.string :callsign
      t.string :destination
      t.integer :epfd_type
      t.datetime :eta
      t.integer :imo_number
      t.string :ship_name
      t.integer :ship_cargo_type
      t.decimal :static_draught
    end
  end
end
