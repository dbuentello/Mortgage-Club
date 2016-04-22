FactoryGirl.define do
  factory :property do |f|
    f.property_type { ["sfh", "duplex", "triplex", "fourplex", "condo"].sample }
    f.usage { Random.rand(3) }
    f.purchase_price { Faker::Number.decimal(8, 0) }
    f.original_purchase_year { Date.new(1900 + Random.rand(114)) }
    f.original_purchase_price { Faker::Number.number(6) }
    f.market_price { Faker::Number.number(6) }
    f.estimated_property_tax { Faker::Number.number(3) }
    f.estimated_hazard_insurance { Faker::Number.number(4) }
    f.estimated_mortgage_insurance { Faker::Number.number(4) }
    f.mortgage_includes_escrows { "taxes_only" }
    f.hoa_due { Faker::Number.number(4) }
    f.is_impound_account { [true, false].sample }
    f.is_primary { true }
    f.is_subject { false }
    f.estimated_mortgage_balance { Faker::Number.number(6) }
  end

  factory :primary_property, parent: :property do |f|
    f.usage { 'primary_residence' }
    f.is_primary { true }
  end

  factory :subject_property, parent: :property do |f|
    f.is_subject { true }
    f.is_primary { false }
  end

  factory :rental_property, parent: :property do |f|
    f.is_primary { false }
    f.gross_rental_income { Faker::Number.number(5) }
  end

  factory :property_with_address, parent: :property do
    after(:build) do |property|
      create(:address, property: property)
    end
  end

  factory :property_completed, parent: :property do |f|
    f.property_type { "sfh" }
    f.usage { "primary_residence" }
    f.purchase_price { 500000.0 }
    f.market_price { 500000.0 }
    f.estimated_property_tax { 391.0 }
    f.estimated_hazard_insurance { 80.0 }
    f.mortgage_includes_escrows { "taxes_and_insurance" }
    f.estimated_mortgage_insurance { 0 }
    f.hoa_due { 0 }
  end

  factory :primary_property_completed, parent: :property_completed do |f|
    f.is_subject { false }
    f.is_primary { true }
    f.address
  end

  factory :subject_property_completed, parent: :property_completed do |f|
    f.is_subject { true }
    f.is_primary { false }
    f.address { build(:address, street_address: "1720 Silver Meadow Court", zip: "95121", state: "CA", city: "San Jose") }
  end
end
