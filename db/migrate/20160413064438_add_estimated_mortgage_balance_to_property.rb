class AddEstimatedMortgageBalanceToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :estimated_mortgage_balance, :decimal, precision: 11, scale: 2
  end
end
