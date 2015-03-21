class Loan < ActiveRecord::Base
  has_one :property, inverse_of: :loan, dependent: :destroy
  has_one :borrower, inverse_of: :loan, dependent: :destroy
  has_one :secondary_borrower, inverse_of: :loan, class_name: 'Borrower', dependent: :destroy
  accepts_nested_attributes_for :property, allow_destroy: true 
  accepts_nested_attributes_for :borrower, allow_destroy: true
  accepts_nested_attributes_for :secondary_borrower, allow_destroy: true

  PERMITTED_ATTRS = [
    :purpose_type,
    property_attributes:           [:id] + Property::PERMITTED_ATTRS,
    borrower_attributes:           [:id] + Borrower::PERMITTED_ATTRS,
    secondary_borrower_attributes: [:id] + Borrower::PERMITTED_ATTRS
  ]

  enum purpose_type: {
    purchase: 0,
    refinance: 1
  }
end