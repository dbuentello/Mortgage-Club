class Address < ActiveRecord::Base
  belongs_to :property, inverse_of: :address, foreign_key: 'property_id'
  belongs_to :borrower_address, inverse_of: :address, foreign_key: 'borrower_address_id'
  belongs_to :borrower_employer, inverse_of: :address, foreign_key: 'borrower_employer_id'

  PERMITTED_ATTRS = [
    :street_address,
    :street_address2,
    :city,
    :zip,
    :state
  ]
end
