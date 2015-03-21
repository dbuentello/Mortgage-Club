FactoryGirl.define do 
  factory :address do |f| 
    f.street_address { Faker::Address.street_address }
    f.secondary_street_address { Faker::Address.secondary_address }
    f.zipcode { Faker::Address.zip_code }
    f.state_type { Random.rand(50) }
  end 
end
