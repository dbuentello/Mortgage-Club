class BorrowerAddress < ActiveRecord::Base
  belongs_to :borrower, inverse_of: :borrower_addresses, foreign_key: 'borrower_id'
  has_one :address, inverse_of: :borrower_address, dependent: :destroy
  accepts_nested_attributes_for :address

  PERMITTED_ATTRS = [
    :borrower_id,
    :years_at_address,
    :is_rental,
    :is_current,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]
end