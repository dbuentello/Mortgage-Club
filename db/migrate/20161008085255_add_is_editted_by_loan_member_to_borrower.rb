class AddIsEdittedByLoanMemberToBorrower < ActiveRecord::Migration
  def change
    add_column :borrowers, :is_editted_by_loan_member, :boolean
  end
end
