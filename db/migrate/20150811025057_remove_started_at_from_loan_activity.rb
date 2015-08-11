class RemoveStartedAtFromLoanActivity < ActiveRecord::Migration
  def change
    remove_column :loan_activities, :started_at, :datetime

    change_column :loan_activities, :duration, :integer, default: 0
  end
end
