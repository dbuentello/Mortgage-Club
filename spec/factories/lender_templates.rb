FactoryGirl.define do
  factory :lender_template do |f|
    f.name { Faker::App.name }
    f.description { Faker::Lorem.sentence }
  end
end
