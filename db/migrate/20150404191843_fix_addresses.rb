class FixAddresses < ActiveRecord::Migration
  def change
    rename_column :addresses, :secondary_street_address, :street_address2
    rename_column :addresses, :zipcode, :zip
    rename_column :addresses, :state_type, :state
    change_column :addresses, :state, :text
    add_column :addresses, :city, :text
    add_column :addresses, :full_text, :text
  end
end
