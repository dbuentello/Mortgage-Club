FactoryGirl.define do
  factory :lender_template do |f|
    f.name { "Wholesale Submission Form" } # hard code to test at Cucumber
    f.description { Faker::Lorem.sentence }
  end
end
