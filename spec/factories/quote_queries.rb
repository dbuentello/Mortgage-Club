FactoryGirl.define do
  factory :quote_query do |f|
    f.query { Faker::Lorem.sentence }
  end
end
