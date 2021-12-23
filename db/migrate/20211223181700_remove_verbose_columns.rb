class RemoveVerboseColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :type24_specifics, :ship_cargo_type
    remove_column :type5_specifics, :ship_cargo_type
    remove_column :type27_specifics, :navigational_status_description
    remove_column :type_cnb_specifics, :navigational_status_description
    remove_column :messages, :category_description
  end
end
