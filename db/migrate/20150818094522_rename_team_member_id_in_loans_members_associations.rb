class RenameTeamMemberIdInLoansMembersAssociations < ActiveRecord::Migration
  def change
    rename_column :loans_members_associations, :team_member_id, :loan_member_id
  end
end
