class AddMonthlyIncomeToEmployment < ActiveRecord::Migration
  def change
    add_column :employments, :monthly_income, :decimal, :precision => 11, :scale => 2
  end
end
