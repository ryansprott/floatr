class CreateType18Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type18_specifics do |t|
      t.references :message, foreign_key: true
      t.integer :true_heading
    end
  end
end
