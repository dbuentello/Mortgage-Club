# == Schema Information
#
# Table name: liabilities
#
#  id               :uuid             not null, primary key
#  credit_report_id :uuid
#  name             :string
#  payment          :decimal(11, 2)
#  months           :integer
#  balance          :decimal(11, 2)
#  account_type     :string
#  phone            :string
#

class Liability < ActiveRecord::Base
  belongs_to :credit_report, inverse_of: :liabilities, foreign_key: 'credit_report_id'
  has_one :address, inverse_of: :liability, autosave: true, dependent: :destroy
  belongs_to :property, inverse_of: :liabilities, foreign_key: 'property_id'

  accepts_nested_attributes_for :address, allow_destroy: true

  PERMITTED_ATTRS = [
    :name,
    # monthly payment
    :payment,
    # months remaining
    :months,
    # unpaid balance
    :balance,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]

  validate :property_cannot_have_more_than_two_liabilities

  private

  def property_cannot_have_more_than_two_liabilities
    return unless property_id

    if Liability.where(property_id: property_id).count == 2
      errors.add(:liabilities, "Property can't have more than two liabilities")
    end
  end
end
