class CreateType15Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type15_specifics do |t|
      t.references :message, foreign_key: true
      t.integer :interrogation1_mmsi
      t.integer :interrogation1_type1
      t.integer :interrogation1_offset1
      t.integer :interrogation1_type2
      t.integer :interrogation1_offset2
      t.integer :interrogation2_mmsi
      t.integer :interrogation2_type
      t.integer :interrogation2_offset
    end
  end
end
