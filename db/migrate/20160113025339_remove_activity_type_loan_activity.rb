class RemoveActivityTypeLoanActivity < ActiveRecord::Migration
  def change
    remove_column :loan_activities, :activity_type
  end
end
