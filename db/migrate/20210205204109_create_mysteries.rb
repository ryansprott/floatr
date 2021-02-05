class CreateMysteries < ActiveRecord::Migration[6.0]
  def change
    create_table :mysteries do |t|
      t.references :message, foreign_key: true
      t.integer :designated_area_code
      t.integer :functional_id
      t.text :full_dearmored_ais_payload
    end
  end
end
