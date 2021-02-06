class CreateType21Specifics < ActiveRecord::Migration[6.0]
  def change
    create_table :type21_specifics do |t|
      t.references :message, foreign_key: true
      t.integer :aid_type
      t.integer :epfd_type
      t.string :name_extension
      t.boolean :off_position
      t.string :ship_name
      t.boolean :virtual_aid
    end
  end
end
