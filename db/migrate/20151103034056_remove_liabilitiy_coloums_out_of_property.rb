class RemoveLiabilitiyColoumsOutOfProperty < ActiveRecord::Migration
  def change
    remove_column :properties, :mortgage_payment
    remove_column :properties, :other_mortgage_payment
    remove_column :properties, :financing
    remove_column :properties, :other_financing
  end
end
