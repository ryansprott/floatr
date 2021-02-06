class CreateType8Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type8_specifics do |t|
      t.references :message, foreign_key: true
      t.boolean :course_quality
      t.decimal :dimension_beam
      t.decimal :dimension_draught
      t.decimal :dimension_length
      t.string :european_vessel_id
      t.integer :hazardous_cargo
      t.boolean :heading_quality
      t.integer :load_status
      t.integer :ship_type
      t.boolean :speed_quality
      t.string :encrypted_data
    end
  end
end
