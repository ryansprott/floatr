class CreateType9Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type9_specifics do |t|
      t.references :message, foreign_key: true
      t.integer :altitude_meters
    end
  end
end
