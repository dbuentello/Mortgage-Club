# == Schema Information
#
# Table name: loan_members
#
#  id           :integer          not null, primary key
#  phone_number :string
#  skype_handle :string
#  email        :string
#  employee_id  :integer
#  nmls_id      :integer
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class LoanMember < ActiveRecord::Base
  belongs_to :user

  has_many :loans_members_associations
  has_many :loans, through: :loans_members_associations

  has_many :loan_activities

  delegate :first_name, to: :user, allow_nil: true
  delegate :last_name, to: :user, allow_nil: true

end
