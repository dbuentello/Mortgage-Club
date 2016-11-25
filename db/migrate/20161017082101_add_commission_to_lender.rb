class AddCommissionToLender < ActiveRecord::Migration
  def change
    add_column :lenders, :commission, :decimal, precision: 13, scale: 3
  end
end
