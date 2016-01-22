class UpdateMoneyAmountFieldsInLiabilities < ActiveRecord::Migration
  def up
    change_column :liabilities, :payment, :decimal, precision: 13, scale: 2
    change_column :liabilities, :balance, :decimal, precision: 13, scale: 2
  end

  def down
    change_column :liabilities, :payment, :decimal, precision: 11, scale: 2
    change_column :liabilities, :balance, :decimal, precision: 11, scale: 2
  end
end
