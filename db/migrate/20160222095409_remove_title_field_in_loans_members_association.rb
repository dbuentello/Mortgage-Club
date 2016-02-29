class RemoveTitleFieldInLoansMembersAssociation < ActiveRecord::Migration
  def change
    remove_column :loans_members_associations, :title
  end
end
