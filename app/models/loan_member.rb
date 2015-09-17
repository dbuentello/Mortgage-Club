# == Schema Information
#
# Table name: loan_members
#
#  id           :uuid             not null, primary key
#  phone_number :string
#  skype_handle :string
#  email        :string
#  user_id      :uuid
#  employee_id  :integer
#  nmls_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class LoanMember < ActiveRecord::Base
  belongs_to :user

  has_many :loans_members_associations
  has_many :loans, through: :loans_members_associations

  has_many :loan_activities

  delegate :first_name, to: :user, allow_nil: true
  delegate :last_name, to: :user, allow_nil: true

  validates :user_id, presence: true

  def handle_this_loan?(loan)
    loans_members_associations.where(loan_id: loan.id, loan_member_id: id).present?
  end
end
