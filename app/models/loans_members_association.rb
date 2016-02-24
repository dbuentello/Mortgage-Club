# == Schema Information
#
# Table name: loans_members_associations
#
#  id             :uuid             not null, primary key
#  loan_id        :uuid
#  loan_member_id :uuid
#  title          :string
#

class LoansMembersAssociation < ActiveRecord::Base

  ROLE_TITLES = {
    admin: 'Loan Admin',
    member: 'Loan Member'
  }

  belongs_to :loan
  belongs_to :loan_member
  belongs_to :loan_members_title

  def pretty_title
    return unless loan_members_title
    loan_members_title.title
  end
end
