class BorrowerAddress < ActiveRecord::Base
  belongs_to :borrower
  has_one    :address

  PERMITTED_ATTRS = [
    :borrower_id,
    :address_id,
    :years_at_address,
    :is_rental,
    :is_current
  ]
end