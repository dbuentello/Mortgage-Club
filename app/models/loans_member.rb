# == Schema Information
#
# Table name: loans_members
#
#  id             :integer          not null, primary key
#  loan_id        :integer
#  team_member_id :integer
#

class LoansMember < ActiveRecord::Base

  belongs_to :loan
  belongs_to :team_member

end
