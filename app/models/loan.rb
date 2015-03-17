class Property < ActiveRecord::Base
  has_one :address

  PERMITTED_ATTRS = [
    :purpose_type,
    :property_id,
    :borrower_id,
    :second_borrower_id
  ]

  enum purpose_type: {
    purchase: 0,
    refinance: 1
  }
end