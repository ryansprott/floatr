class CreateDimensions < ActiveRecord::Migration[6.0]
  def change
    create_table :dimensions do |t|
      t.references :message, foreign_key: true
      t.integer :ship_dimension_to_bow
      t.integer :ship_dimension_to_port
      t.integer :ship_dimension_to_starboard
      t.integer :ship_dimension_to_stern
    end
  end
end
