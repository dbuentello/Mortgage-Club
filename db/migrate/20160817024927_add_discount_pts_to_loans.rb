class AddDiscountPtsToLoans < ActiveRecord::Migration
  def change
    remove_column :loans, :apr
    add_column :loans, :apr, :decimal, precision: 13, scale: 5
    add_column :loans, :discount_pts, :decimal, precision: 13, scale: 5
  end
end
