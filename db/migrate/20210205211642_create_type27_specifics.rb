class CreateType27Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type27_specifics do |t|
      t.references :message, foreign_key: true
      t.integer :navigational_status
      t.boolean :gnss
    end
  end
end
