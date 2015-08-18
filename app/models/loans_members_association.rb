# == Schema Information
#
# Table name: loans_members_associations
#
#  id             :uuid             not null, primary key
#  loan_id        :uuid
#  team_member_id :uuid
#

class LoansMembersAssociation < ActiveRecord::Base

  ROLE_TITLES = {
    admin: 'Loan Admin',
    member: 'Loan Member'
  }

  belongs_to :loan
  belongs_to :loan_member

end
