class FixIndices < ActiveRecord::Migration[6.1]
  def change
    remove_index :sources, name: "index_sources_on_mmsi"
    add_index :sources, :mmsi, unique: false
  end
end
