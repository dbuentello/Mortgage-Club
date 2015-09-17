class AddDateTimeToLoanActivities < ActiveRecord::Migration
  def change
    add_column :loan_activities, :start_date, :datetime
    add_column :loan_activities, :end_date, :datetime
  end
end
