class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :message_type
      t.integer :repeat_indicator
      t.integer :source_mmsi
      t.string :category_description

      t.timestamps
    end
  end
end
