class Property < ActiveRecord::Base
  has_one :address

  PERMITTED_ATTRS = [
    :address_id,
    :property_type,
    :usage_type,
    :original_purchase_date,
    :original_purchase_price,
    :purchase_price,
    :gross_rental_income,
    :market_price,
    :estimated_property_tax,
    :estimated_hazard_insurance,
    :impound_account
  ]

  enum property_type: {
    single_family: 0,
    duplex: 1,
    triplex: 2,
    fourplex: 3
  }

  enum usage_text: {
    primary_residence: 0,
    vacation_home: 1,
    rental_property: 2
  }
end