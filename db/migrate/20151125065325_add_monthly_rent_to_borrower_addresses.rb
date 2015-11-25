class AddMonthlyRentToBorrowerAddresses < ActiveRecord::Migration
  def change
    add_column :borrower_addresses, :monthly_rent, :decimal, :precision => 11, :scale => 2, default: 0.00
  end
end
