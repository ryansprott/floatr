class CreateType7Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type7_specifics do |t|
      t.references :message, foreign_key: true
      t.integer :ack1_mmsi
      t.integer :ack2_mmsi
      t.integer :ack3_mmsi
      t.integer :ack4_mmsi
      t.integer :ack1_sequence_number
      t.integer :ack2_sequence_number
      t.integer :ack3_sequence_number
      t.integer :ack4_sequence_number
    end
  end
end
