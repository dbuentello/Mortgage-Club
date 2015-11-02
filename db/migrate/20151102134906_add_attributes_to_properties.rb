class AddAttributesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :mortgage_payment, :string
    add_column :properties, :other_mortgage_payment, :string
    add_column :properties, :financing, :string
    add_column :properties, :other_financing, :string
  end
end
