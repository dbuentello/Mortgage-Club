# == Schema Information
#
# Table name: loans
#
#  id                           :integer          not null, primary key
#  purpose                      :integer
#  user_id                      :integer
#  agency_case_number           :string
#  lender_case_number           :string
#  amount                       :decimal(11, 2)
#  interest_rate                :decimal(11, 2)
#  num_of_months                :integer
#  amortization_type            :string
#  rate_lock                    :boolean
#  refinance                    :decimal(11, 2)
#  estimated_prepaid_items      :decimal(11, 2)
#  estimated_closing_costs      :decimal(11, 2)
#  pmi_mip_funding_fee          :decimal(11, 2)
#  borrower_closing_costs       :decimal(11, 2)
#  other_credits                :decimal(11, 2)
#  other_credits_explain        :string
#  pmi_mip_funding_fee_financed :decimal(11, 2)
#  loan_type                    :string
#  prepayment_penalty           :boolean
#  balloon_payment              :boolean
#  monthly_payment              :decimal(11, 2)
#  prepayment_penalty_amount    :decimal(11, 2)
#  pmi                          :decimal(11, 2)
#

class Loan < ActiveRecord::Base
  belongs_to :user, inverse_of: :loans, foreign_key: 'user_id'
  has_one :borrower, through: :user

  has_one :property, inverse_of: :loan, dependent: :destroy
  has_one :secondary_borrower, inverse_of: :loan, class_name: 'Borrower', dependent: :destroy
  has_one :envelope, inverse_of: :loan, dependent: :destroy

  accepts_nested_attributes_for :property, allow_destroy: true
  accepts_nested_attributes_for :borrower, allow_destroy: true
  accepts_nested_attributes_for :secondary_borrower, allow_destroy: true

  PERMITTED_ATTRS = [
    :purpose,
    property_attributes:           [:id] + Property::PERMITTED_ATTRS,
    borrower_attributes:           [:id] + Borrower::PERMITTED_ATTRS,
    secondary_borrower_attributes: [:id] + Borrower::PERMITTED_ATTRS
  ]

  enum purpose: {
    purchase: 0,
    refinance: 1
  }

  validates :amortization_type, inclusion: { in: %w( Conventional VA FHA USDA 9 ), message: "%{value} is not a valid amortization_type" }, allow_nil: true

  def self.initiate(user)
    Loan.create(user: user, property: Property.create(address: Address.create))
  end

  def property_completed
    property.present? && property.address.completed && property.property_type.present? && property.usage.present? && purpose.present? &&
      ((purchase? && property.purchase_price.present?) || (refinance? && property.original_purchase_price.present? && property.original_purchase_year.present?))
  end

  def borrower_completed
    borrower.completed?
  end

  def income_completed
    borrower.income_completed?
  end
end
