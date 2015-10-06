FactoryGirl.define do
  factory :property do |f|
    f.property_type { Random.rand(4) }
    f.usage { Random.rand(3) }
    f.purchase_price { Faker::Number.decimal(8, 0) }
    f.original_purchase_year { Date.new(1900 + Random.rand(114)) }
    f.original_purchase_price { Faker::Number.number(6) }
    f.market_price { Faker::Number.number(6) }
    f.estimated_property_tax { Faker::Number.number(4) }
    f.estimated_hazard_insurance { Faker::Number.number(4) }
    f.is_impound_account { [true, false].sample }
    f.is_primary { true }
  end

  factory :rental_property, parent: :property do |f|
    f.gross_rental_income { Faker::Number.number(5) }
  end

  factory :property_with_address, parent: :property do |f|
    after(:build) do |property, address|
      create(:address, property: property)
    end
  end
end
