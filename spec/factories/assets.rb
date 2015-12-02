FactoryGirl.define do
  factory :asset do
    institution_name Faker::Name.name
    asset_type :checkings
    current_balance Faker::Number.decimal(11, 2)
  end
end
