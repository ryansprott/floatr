class CreateType4Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type4_specifics do |t|
      t.references :message, foreign_key: true
    end
  end
end
