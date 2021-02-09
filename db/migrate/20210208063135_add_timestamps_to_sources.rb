class AddTimestampsToSources < ActiveRecord::Migration[6.0]
  def change
    change_table :sources do |t|
      t.timestamps null: true
    end
  end
end
