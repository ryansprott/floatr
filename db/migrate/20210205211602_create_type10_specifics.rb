class CreateType10Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type10_specifics do |t|
      t.references :message, foreign_key: true
      t.integer :destination_mmsi
    end
  end
end
