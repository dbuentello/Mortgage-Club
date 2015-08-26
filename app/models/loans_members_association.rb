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

  TITLES = {
    'sale' => 'Sale',
    'premier_agent' => 'Premier Agent',
    'manager' => 'Manager'
  }

  belongs_to :loan
  belongs_to :loan_member

  def pretty_title
    return unless title
    TITLES[title]
  end
end
