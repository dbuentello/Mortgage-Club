class AddFieldToBorrowers < ActiveRecord::Migration
  def change
    add_column :borrowers, :other_properties, :text
  end
end
