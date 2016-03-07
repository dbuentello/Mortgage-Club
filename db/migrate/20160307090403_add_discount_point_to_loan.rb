class AddDiscountPointToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :discount_points, :float
  end
end
