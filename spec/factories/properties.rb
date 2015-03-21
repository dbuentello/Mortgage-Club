FactoryGirl.define do 
  factory :property do |f| 
    address
    f.property_type { Random.rand(4) }
    f.usage_type { Random.rand(3) }
    f.original_purchase_date { Faker::Date.backward(14) }
    f.original_purchase_price { Faker::Number.number(6) }
    f.market_price { Faker::Number.number(6) }
    f.estimated_property_tax { Faker::Number.number(4) }
    f.estimated_hazard_insurance { Faker::Number.number(4) }
    f.is_impound_account { [true, false].sample }
    # leaving out gross_rental income (optional)
  end

  factory :rental_property do |f|
    f.gross_rental_income { Faker::Number.number(5) }
  end
end
