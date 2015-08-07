class AddStartedAtAndDurationToLoanActivity < ActiveRecord::Migration
  def change
    add_column :loan_activities, :started_at, :datetime
    add_column :loan_activities, :duration, :integer
  end
end
