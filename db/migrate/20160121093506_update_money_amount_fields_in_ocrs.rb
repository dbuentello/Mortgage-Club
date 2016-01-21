class UpdateMoneyAmountFieldsInOcrs < ActiveRecord::Migration
  def up
    change_column :ocrs, :current_salary_1, :decimal, precision: 13, scale: 2
    change_column :ocrs, :current_salary_2, :decimal, precision: 13, scale: 2
    change_column :ocrs, :ytd_salary_1, :decimal, precision: 13, scale: 2
    change_column :ocrs, :ytd_salary_2, :decimal, precision: 13, scale: 2
    change_column :ocrs, :current_earnings_1, :decimal, precision: 13, scale: 2
    change_column :ocrs, :current_earnings_2, :decimal, precision: 13, scale: 2
  end

  def down
    change_column :ocrs, :current_salary_1, :decimal, precision: 11, scale: 2
    change_column :ocrs, :current_salary_2, :decimal, precision: 11, scale: 2
    change_column :ocrs, :ytd_salary_1, :decimal, precision: 11, scale: 2
    change_column :ocrs, :ytd_salary_2, :decimal, precision: 11, scale: 2
    change_column :ocrs, :current_earnings_1, :decimal, precision: 11, scale: 2
    change_column :ocrs, :current_earnings_2, :decimal, precision: 11, scale: 2
  end
end
