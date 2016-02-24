class AddLoanMemberTitleToLoanMemberAssociation < ActiveRecord::Migration
  def change
    add_column :loans_members_associations, :loan_members_title_id, :uuid
  end
end
