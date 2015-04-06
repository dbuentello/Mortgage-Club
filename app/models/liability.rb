class Liability < ActiveRecord::Base
  belongs_to :credit_report, inverse_of: :liabilities, foreign_key: 'credit_report_id'
  has_one   :address, inverse_of: :liability, dependent: :destroy
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
end
