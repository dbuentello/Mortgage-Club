class LenderDocusignForm < ActiveRecord::Base
  belongs_to :lender

  PERMITTED_ATTRS = [
    :description,
    :sign_position,
    :lender_id
  ]

end
