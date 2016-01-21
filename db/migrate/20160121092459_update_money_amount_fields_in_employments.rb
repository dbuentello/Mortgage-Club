class UpdateMoneyAmountFieldsInEmployments < ActiveRecord::Migration
  def up
    change_column :employments, :current_salary, :decimal, precision: 13, scale: 2
    change_column :employments, :ytd_salary, :decimal, precision: 13, scale: 2
    change_column :employments, :monthly_income, :decimal, precision: 13, scale: 2
  end

  def down
    change_column :employments, :current_salary, :decimal, precision: 11, scale: 2
    change_column :employments, :ytd_salary, :decimal, precision: 11, scale: 2
    change_column :employments, :monthly_income, :decimal, precision: 11, scale: 2
  end
end
