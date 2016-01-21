class UpdateMoneyAmountBorrowerAddresses < ActiveRecord::Migration
  def up
    change_column :borrower_addresses, :monthly_rent, :decimal, precision: 13, scale: 2, default: 0.0
  end

  def down
    change_column :borrower_addresses, :monthly_rent, :decimal, precision: 11, scale: 2, default: 0.0
  end
end
