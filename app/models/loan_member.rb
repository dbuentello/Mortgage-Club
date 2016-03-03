# == Schema Information
#
# Table name: loan_members
#
#  id           :uuid             not null, primary key
#  phone_number :string
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
  has_many :loans, through: :loans_members_associations, dependent: :destroy

  has_many :loan_activities

  delegate :first_name, to: :user, allow_nil: true
  delegate :last_name, to: :user, allow_nil: true

  validates :user_id, presence: true
  validates :nmls_id, presence: true
  validates :company_nmls, presence: true
  validates :company_name, presence: true
  validates :company_address, presence: true
  validates :company_phone_number, presence: true

  def handle_this_loan?(loan)
    loans_members_associations.where(loan_id: loan.id, loan_member_id: id).present?
  end

  def title(loan)
    return unless handle_this_loan?(loan)

    loans_members_associations.includes(:loan_members_title).where(loan_id: loan.id, loan_member_id: id).last.loan_members_title.title
  end
end
