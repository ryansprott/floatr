class CreateTypeCnbSpecifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type_cnb_specifics do |t|
      t.references :message, foreign_key: true
      t.integer :navigational_status
      t.integer :true_heading
      t.decimal :rate_of_turn
    end
  end
end
