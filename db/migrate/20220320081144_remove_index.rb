class RemoveIndex < ActiveRecord::Migration[6.1]
  def change
    remove_index :sources, name: "index_sources_on_mmsi"
  end
end
