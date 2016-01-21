FactoryGirl.define do
  factory :address do |f|
    property

    f.street_address { Faker::Address.street_address }
    f.street_address2 { Faker::Address.secondary_address }
    f.zip { Faker::Address.zip_code }
    f.state { Faker::Address.state }
    f.city { Faker::Address.city }
    f.full_text { "10669 South Las Vegas Boulevard, Las Vegas, NV, United States" }

  end
end
