class Property < ActiveRecord::Base
  belongs_to :loan, inverse_of: :property, foreign_key: 'loan_id'
  has_one :address, inverse_of: :property
  accepts_nested_attributes_for :address

  PERMITTED_ATTRS = [
    :property_type,
    :usage,
    :original_purchase_year,
    :original_purchase_price,
    :purchase_price,
    :gross_rental_income,
    :market_price,
    :estimated_property_tax,
    :estimated_hazard_insurance,
    :is_impound_account,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]

  enum property_type: {
    sfh: 0,
    duplex: 1,
    triplex: 2,
    quadruplex: 3
  }

  enum usage: {
    primary_residence: 0,
    vacation_home: 1,
    rental_property: 2
  }
end
