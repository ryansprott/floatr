class AddDescriptiveColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :type_cnb_specifics, :navigational_status_description, :string
    add_column :type5_specifics, :ship_cargo_type_description, :string
    add_column :type24_specifics, :ship_cargo_type_description, :string
    add_column :type27_specifics, :navigational_status_description, :string
  end
end
