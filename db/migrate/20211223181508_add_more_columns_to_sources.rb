class AddMoreColumnsToSources < ActiveRecord::Migration[6.1]
  def change
    add_column :sources, :last_area, :integer
    add_column :sources, :last_aspect_ratio, :float
    add_column :sources, :last_destination, :string
    add_column :sources, :static_data_received, :boolean
  end
end
