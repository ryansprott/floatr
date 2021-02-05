class CreatePositions < ActiveRecord::Migration[6.0]
  def change
    create_table :positions do |t|
      t.references :message, foreign_key: true
      t.string :latitude
      t.string :longitude
    end
  end
end
