class AddActivityTypeToLoanActivity < ActiveRecord::Migration
  def change
    add_reference :loan_activities, :activity_type, index: true, foreign_key: true, type: :uuid
  end
end
