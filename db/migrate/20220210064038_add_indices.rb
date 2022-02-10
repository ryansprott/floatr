class AddIndices < ActiveRecord::Migration[6.1]
  def change
    add_index :messages, :source_mmsi
    add_index :sources, :mmsi, unique: true
  end
end
