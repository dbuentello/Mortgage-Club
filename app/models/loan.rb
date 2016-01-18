class Loan < ActiveRecord::Base
  resourcify

  belongs_to :user, inverse_of: :loans, foreign_key: 'user_id'
  has_one :borrower, through: :user
  has_one :secondary_borrower, inverse_of: :loan, class_name: 'Borrower' # don't destroy Borrower instance when we unset this association
  has_many :properties, dependent: :destroy
  has_many :envelopes, inverse_of: :loan, dependent: :destroy
  has_one :closing, inverse_of: :loan, dependent: :destroy
  has_many :documents, as: :subjectable, dependent: :destroy
  has_many :loan_activities
  has_many :loans_members_associations
  has_many :loan_members, through: :loans_members_associations
  has_many :checklists
  has_many :lender_documents
  has_many :rate_comparisons
  belongs_to :lender

  accepts_nested_attributes_for :properties, allow_destroy: true
  accepts_nested_attributes_for :borrower, allow_destroy: true
  accepts_nested_attributes_for :secondary_borrower, allow_destroy: true

  delegate :completed?, to: :borrower, prefix: :borrower
  delegate :lender_templates, to: :lender, allow_nil: true

  PERMITTED_ATTRS = [
    :credit_check_agree,
    :purpose,
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

  validates :loan_type, inclusion: {in: %w(Conventional VA FHA USDA 9), message: "%{value} is not a valid loan_type"}, allow_nil: true
  validates :status, inclusion: {in: %w(new_loan submitted pending conditionally_approved approved closed), message: "%{value} is not a valid status"}, allow_nil: true

  def self.initiate(user)
    loan = Loan.create(
      user: user,
      properties: [Property.create(address: Address.create, is_subject: true)],
      closing: Closing.create(name: 'Closing'),
      status: "new_loan"
    )
  end

  def property_completed
    CompletedLoanServices::TabProperty.new(self, subject_property).call
  end

  def borrower_completed
    CompletedLoanServices::TabBorrower.new({
      borrower: borrower,
      secondary_borrower: secondary_borrower
    }).call
  end

  def documents_completed
    CompletedLoanServices::TabDocuments.new({
      borrower: borrower,
      secondary_borrower: secondary_borrower
    }).call
  end

  def income_completed
    CompletedLoanServices::TabIncome.new({
      borrower: borrower,
      current_employment: borrower.current_employment,
      previous_employment: borrower.previous_employment
    }).call
  end

  def credit_completed
    # credit_check_agree
    true
  end

  def assets_completed
    CompletedLoanServices::TabAssets.new({
      assets: borrower.assets,
      subject_property: subject_property,
      rental_properties: rental_properties,
      primary_property: primary_property,
      own_investment_property: own_investment_property
    }).call
  end

  def declarations_completed
    CompletedLoanServices::TabDeclarations.new(borrower.declaration).call
  end

  def primary_property
    properties.includes(:address).find { |p| p.is_primary == true }
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

    association = loans_members_associations.where(loan_id: self.id, title: 'manager').last
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
    return "New" if new_loan?
    status.titleize
  end
end
