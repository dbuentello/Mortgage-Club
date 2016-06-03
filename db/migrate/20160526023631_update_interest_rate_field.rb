class UpdateInterestRateField < ActiveRecord::Migration
  def change
    change_column :loans, :interest_rate, :decimal, precision: 9, scale: 5
  end
end
