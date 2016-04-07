class Loan < ActiveRecord::Base
  resourcify
  serialize :service_cannot_shop_fees, Hash
  serialize :origination_charges_fees, Hash
  serialize :service_can_shop_fees, Hash

  belongs_to :user, inverse_of: :loans, foreign_key: 'user_id'
  has_one :borrower, through: :user
  has_one :secondary_borrower, inverse_of: :loan, class_name: 'Borrower' # don't destroy Borrower instance when we unset this association
  has_many :properties, dependent: :destroy
  has_many :envelopes, inverse_of: :loan, dependent: :destroy
  has_one :closing, inverse_of: :loan, dependent: :destroy
  has_many :documents, as: :subjectable, dependent: :destroy
  has_many :loan_activities, dependent: :destroy
  has_many :loans_members_associations, dependent: :destroy
  has_many :loan_members, through: :loans_members_associations, dependent: :destroy
  has_many :checklists, dependent: :destroy
  has_many :lender_documents, dependent: :destroy
  has_many :rate_comparisons, dependent: :destroy
  belongs_to :lender

  accepts_nested_attributes_for :properties, allow_destroy: true
  accepts_nested_attributes_for :borrower, allow_destroy: true
  accepts_nested_attributes_for :secondary_borrower, allow_destroy: true

  delegate :lender_templates, to: :lender, allow_nil: true

  PERMITTED_ATTRS = [
    :credit_check_agree,
    :purpose,
    :down_payment,
    properties_attributes: [:id] + Property::PERMITTED_ATTRS,
    borrower_attributes: [:id] + Borrower::PERMITTED_ATTRS,
    secondary_borrower_attributes: [:id] + Borrower::PERMITTED_ATTRS
  ]

  enum purpose: {
    purchase: 0,
    refinance: 1
  }

  enum status: {
    new_loan: 0,
    submitted: 1,
    pending: 2,
    conditionally_approved: 3,
    approved: 4,
    closed: 5
  }

  validates :loan_type, inclusion: {in: %w(Conventional VA FHA USDA 9), message: :invalid_loan_type}, allow_nil: true
  validates :status, inclusion: {in: %w(new_loan submitted pending conditionally_approved approved closed), message: :invalid_loan_status}, allow_nil: true

  def completed?
    CompletedLoanServices::BaseCompleted.new(loan: self).call
  end

  def primary_property
    properties.includes(:address).find { |p| p.is_primary == true && p.is_subject == false }
  end

  def subject_property
    properties.includes(:address).find { |p| p.is_subject == true }
  end

  def rental_properties
    rental_properties = properties.includes(:address).select { |p| p.is_primary == false && p.is_subject == false }
    rental_properties.sort_by(&:created_at)
  end

  def num_of_years
    return unless num_of_months

    num_of_months / 12
  end

  def purpose_titleize
    return unless purpose

    purpose.titleize
  end

  def relationship_manager
    return if loans_members_associations.empty?

    association = loans_members_associations.joins(:loan_members_title).where("loan_members_titles.title = ?", "Relationship Manager").last
    association.loan_member if association
  end

  def fixed_rate_amortization?
    return false unless amortization_type

    amortization_type.include? "fixed"
  end

  def arm_amortization?
    return false unless amortization_type

    amortization_type.include? "ARM"
  end

  def other_lender_documents
    lender_documents.joins(:lender_template).where("is_other = ?", true)
  end

  def required_lender_documents
    lender_documents.joins(:lender_template).where("is_other = ?", false)
  end

  def pretty_status
    return if status.nil?
    return "New".freeze if new_loan?

    status.titleize
  end

  def other_documents
    documents.where(document_type: "other_loan_report")
  end
end
