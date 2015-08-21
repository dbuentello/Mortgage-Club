class Declaration < ActiveRecord::Base
  belongs_to :borrower

  validates_presence_of :borrower_id

  PERMITTED_ATTRS = [
    :outstanding_judgment,
    :bankrupt,
    :property_foreclosed,
    :party_to_lawsuit,
    :loan_foreclosure,
    :present_deliquent_loan,
    :child_support,
    :down_payment_borrowed,
    :co_maker_or_endorser,
    :us_citizen,
    :permanent_resident_alien,
    :ownership_interest,
    :type_of_property,
    :title_of_property
  ]
end
