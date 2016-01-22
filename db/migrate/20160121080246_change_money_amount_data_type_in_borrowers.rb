class ChangeMoneyAmountDataTypeInBorrowers < ActiveRecord::Migration
  def up
    change_column :borrowers, :gross_overtime, :decimal, precision: 13, scale: 2
    change_column :borrowers, :gross_bonus, :decimal, precision: 13, scale: 2
    change_column :borrowers, :gross_commission, :decimal, precision: 13, scale: 2
    change_column :borrowers, :gross_interest, :decimal, precision: 13, scale: 2
  end

  def down
    change_column :borrowers, :gross_overtime, :decimal, precision: 11, scale: 2
    change_column :borrowers, :gross_bonus, :decimal, precision: 11, scale: 2
    change_column :borrowers, :gross_commission, :decimal, precision: 11, scale: 2
    change_column :borrowers, :gross_interest, :decimal, precision: 11, scale: 2
  end
end
