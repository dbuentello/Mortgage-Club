FactoryGirl.define do
  factory :quote_query do |f|
    f.query { Faker::Lorem.sentence }
    f.email { Faker::Internet.email }
  end
end
