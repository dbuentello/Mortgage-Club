FactoryGirl.define do
  factory :property do |f|
    f.property_type { ["sfh", "duplex", "triplex", "fourplex", "condo"].sample }
    f.usage { Random.rand(3) }
    f.purchase_price { Faker::Number.decimal(8, 0) }
    f.original_purchase_year { Date.new(1900 + Random.rand(114)) }
    f.original_purchase_price { Faker::Number.number(6) }
    f.market_price { Faker::Number.number(6) }
    f.estimated_property_tax { Faker::Number.number(4) }
    f.estimated_hazard_insurance { Faker::Number.number(4) }
    f.estimated_mortgage_insurance { Faker::Number.number(4) }
    f.hoa_due { Faker::Number.number(4) }
    f.is_impound_account { [true, false].sample }
    f.is_primary { true }
    f.is_subject { false }
  end

  factory :primary_property, parent: :property do |f|
    f.usage {'primary_residence'}
    f.is_primary { true }
  end

  factory :subject_property, parent: :property do |f|
    f.is_subject { true }
    f.is_primary { false }
  end

  factory :rental_property, parent: :property do |f|
    f.is_primary {false}
    f.gross_rental_income { Faker::Number.number(5) }
  end

  factory :property_with_address, parent: :property do |f|
    after(:build) do |property, address|
      create(:address, property: property)
    end
  end
end
