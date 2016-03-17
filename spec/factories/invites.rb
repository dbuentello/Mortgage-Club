FactoryGirl.define do
  factory :invite do |f|
    f.email { Faker::Internet.email }
    f.name { Faker::Name.first_name }
    f.phone { Faker::PhoneNumber.phone_number }
    f.sender_id Faker::Number.number(32)
    f.recipient_id Faker::Number.number(32)
    f.join_at { Faker::Time.between(Time.zone.now - 2, Time.zone.now) }
    f.token 'token'
  end
end
