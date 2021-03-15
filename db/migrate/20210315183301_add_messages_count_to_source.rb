class AddMessagesCountToSource < ActiveRecord::Migration[6.0]
  def change
    add_column :sources, :messages_count, :integer
  end
end
