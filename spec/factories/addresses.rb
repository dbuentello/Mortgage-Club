FactoryGirl.define do
  factory :address do |f|
    property

    f.street_address { Faker::Address.street_address }
    f.zip { Faker::Address.zip_code }
    f.state { "CA" }
    f.city { Faker::Address.city }
    f.full_text { "1722 Silver Meadow Way, Sacramento, CA 95829" }
  end
end
