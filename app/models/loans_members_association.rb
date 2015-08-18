# == Schema Information
#
# Table name: loans_members_associations
#
#  id             :integer          not null, primary key
#  loan_id        :integer
#  loan_member_id :integer

class LoansMembersAssociation < ActiveRecord::Base

  ROLE_TITLES = {
    admin: 'Loan Admin',
    member: 'Loan Member'
  }

  belongs_to :loan
  belongs_to :loan_member

end
