# == Schema Information
#
# Table name: loans
#
#  id                             :uuid             not null, primary key
#  purpose                        :integer
#  user_id                        :uuid
#  agency_case_number             :string
#  lender_case_number             :string
#  amount                         :decimal(11, 2)
#  interest_rate                  :decimal(9, 3)
#  num_of_months                  :integer
#  amortization_type              :string
#  rate_lock                      :boolean
#  refinance                      :decimal(11, 2)
#  estimated_prepaid_items        :decimal(11, 2)
#  estimated_closing_costs        :decimal(11, 2)
#  pmi_mip_funding_fee            :decimal(11, 2)
#  borrower_closing_costs         :decimal(11, 2)
#  other_credits                  :decimal(11, 2)
#  other_credits_explain          :string
#  pmi_mip_funding_fee_financed   :decimal(11, 2)
#  loan_type                      :string
#  prepayment_penalty             :boolean
#  balloon_payment                :boolean
#  monthly_payment                :decimal(11, 2)
#  prepayment_penalty_amount      :decimal(11, 2)
#  pmi                            :decimal(11, 2)
#  loan_amount_increase           :boolean
#  interest_rate_increase         :boolean
#  included_property_taxes        :boolean
#  included_homeowners_insurance  :boolean
#  included_other                 :boolean
#  included_other_text            :boolean
#  in_escrow_property_taxes       :boolean
#  in_escrow_homeowners_insurance :boolean
#  in_escrow_other                :boolean
#  loan_costs                     :decimal(11, 2)
#  other_costs                    :decimal(11, 2)
#  lender_credits                 :decimal(11, 2)
#  estimated_cash_to_close        :decimal(11, 2)
#  lender_name                    :string
#  fha_upfront_premium_amount     :decimal(11, 2)
#  term_months                    :integer
#  lock_period                    :integer
#  margin                         :decimal(11, 2)
#  pmi_annual_premium_mount       :decimal(11, 2)
#  pmi_monthly_premium_amount     :decimal(11, 2)
#  pmi_monthly_premium_percent    :decimal(11, 4)
#  pmi_required                   :boolean
#  apr                            :decimal(11, 3)
#  price                          :decimal(11, 3)
#  product_code                   :string
#  product_index                  :integer
#  total_margin_adjustment        :decimal(11, 2)
#  total_price_adjustment         :decimal(11, 2)
#  total_rate_adjustment          :decimal(11, 2)
#  srp_adjustment                 :decimal(11, 2)
#  appraisal_fee                  :decimal(11, 2)
#  city_county_deed_stamp_fee     :decimal(11, 2)
#  credit_report_fee              :decimal(11, 2)
#  document_preparation_fee       :decimal(11, 2)
#  flood_certification            :decimal(11, 2)
#  origination_fee                :decimal(11, 2)
#  settlement_fee                 :decimal(11, 2)
#  state_deed_tax_stamp_fee       :decimal(11, 2)
#  tax_related_service_fee        :decimal(11, 2)
#  title_insurance_fee            :decimal(11, 2)
#

class Loan < ActiveRecord::Base
  resourcify

  belongs_to :user, inverse_of: :loans, foreign_key: 'user_id'

  has_one :borrower, through: :user
  has_one :secondary_borrower, inverse_of: :loan, class_name: 'Borrower' # don't destroy Borrower instance when we unset this association

  has_many :properties, dependent: :destroy
  has_many :envelope, inverse_of: :loan, dependent: :destroy
  has_one :closing, inverse_of: :loan, dependent: :destroy

  has_one :hud_estimate, inverse_of: :loan, dependent: :destroy, foreign_key: 'loan_id'
  has_one :hud_final, inverse_of: :loan, dependent: :destroy, foreign_key: 'loan_id'
  has_one :loan_estimate, inverse_of: :loan, dependent: :destroy, foreign_key: 'loan_id'
  has_one :uniform_residential_lending_application, inverse_of: :loan, dependent: :destroy, foreign_key: 'loan_id'
  has_many :other_loan_reports, inverse_of: :loan, dependent: :destroy, foreign_key: 'loan_id'
  has_many :loan_documents, dependent: :destroy, foreign_key: 'loan_id'

  has_many :loan_activities

  has_many :loans_members_associations
  has_many :loan_members, through: :loans_members_associations

  has_many :checklists

  accepts_nested_attributes_for :properties, allow_destroy: true
  accepts_nested_attributes_for :borrower, allow_destroy: true
  accepts_nested_attributes_for :secondary_borrower, allow_destroy: true

  delegate :completed?, to: :borrower, prefix: :borrower

  PERMITTED_ATTRS = [
    :credit_check_agree,
    :purpose,
    properties_attributes: [:id] + Property::PERMITTED_ATTRS,
    borrower_attributes: [:id] + Borrower::PERMITTED_ATTRS
  ]

  enum purpose: {
    purchase: 0,
    refinance: 1
  }

  validates :amortization_type, inclusion: {in: %w( Conventional VA FHA USDA 9 ), message: "%{value} is not a valid amortization_type"}, allow_nil: true

  def self.initiate(user)
    loan = Loan.create(user: user, properties: [Property.create(address: Address.create, is_primary: true)], closing: Closing.create(name: 'Closing'))
  end

  def property_completed
    properties.size > 0 && primary_property && primary_property.completed? && purpose_completed?
  end

  def borrower_completed
    if secondary_borrower.present?
      borrower.completed? && secondary_borrower.completed?
    else
      borrower.completed?
    end
  end

  def income_completed
    borrower.income_completed?
  end

  def credit_completed
    credit_check_agree
  end

  def assets_completed
    false
  end

  def declarations_completed
    false
  end

  def purpose_completed?
    purpose.present? && primary_property && (purchase? && primary_property.purchase_price.present? ||
      refinance? && primary_property.refinance_completed?)
  end

  def primary_property
    properties.find { |p| p.is_primary == true }
  end

  def rental_properties
    properties.select { |p| p.is_primary == false }
  end

  def num_of_years
    return unless num_of_months

    num_of_months / 12
  end

  def ltv_formula
    return unless (amount && properties && primary_property && primary_property.purchase_price)

    (amount / primary_property.purchase_price * 100).ceil
  end

  def purpose_titleize
    return unless purpose

    purpose.titleize
  end

  def relationship_manager
    return if loans_members_associations.empty?

    association = loans_members_associations.where(loan_id: self.id, title: 'manager').last
    association.loan_member if association
  end
end
