class AddIncomeCompletedToBorrower < ActiveRecord::Migration
  def change
    add_column :borrowers, :income_completed, :boolean, default: false
  end
end
