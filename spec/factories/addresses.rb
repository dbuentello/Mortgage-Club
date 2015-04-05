FactoryGirl.define do 
  factory :address do |f| 
    f.street_address { Faker::Address.street_address }
    f.street_address2 { Faker::Address.secondary_address }
    f.zip { Faker::Address.zip_code }
    f.state { Random.rand(50) }
  end 
end
