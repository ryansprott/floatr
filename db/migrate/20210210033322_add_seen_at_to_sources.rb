class AddSeenAtToSources < ActiveRecord::Migration[6.0]
  def change
    add_column :sources, :seen_at, :timestamp
  end
end
