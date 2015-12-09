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
    borrower_attributes: [:id] + Borrower::PERMITTED_ATTRS
  ]

  enum purpose: {
    purchase: 0,
    refinance: 1
  }

  enum status: {
    pending: 0,
    has_lender: 1,
    sent: 2,
    read: 3,
    finish: 4
  }

  validates :loan_type, inclusion: {in: %w( Conventional VA FHA USDA 9 ), message: "%{value} is not a valid loan_type"}, allow_nil: true

  def self.initiate(user)
    loan = Loan.create(user: user, properties: [Property.create(address: Address.create, is_subject: true)], closing: Closing.create(name: 'Closing'))
  end

  def property_completed
    properties.size > 0 && subject_property && subject_property.completed? && purpose_completed?
  end

  def borrower_completed
    if secondary_borrower.present?
      borrower.completed? && secondary_borrower.completed?
    else
      borrower.completed?
    end
  end

  def documents_completed
    borrower.documents_completed?
  end

  def income_completed
    borrower.income_completed?
  end

  def credit_completed
    credit_check_agree
  end

  def assets_completed
    subject_property && subject_property.completed? &&
    subject_property.market_price.present? &&
    subject_property.estimated_mortgage_insurance.present? &&
    subject_property.mortgage_includes_escrows.present? &&
    subject_property.estimated_property_tax.present? &&
    subject_property.estimated_hazard_insurance.present? &&
    subject_property.hoa_due.present?
  end

  def declarations_completed
    borrower.declaration && borrower.declaration.completed?
  end

  def purpose_completed?
    purpose.present? && subject_property && (purchase? && subject_property.purchase_price.present? ||
      refinance? && subject_property.refinance_completed?)
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

  def can_submit_to_lender
    true # will update it when we have rules
    # return if self.sent? || self.read? || self.finish?
    # true
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
end
