# == Schema Information
#
# Table name: loans
#
#  id      :integer          not null, primary key
#  purpose :integer
#  user_id :integer
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
