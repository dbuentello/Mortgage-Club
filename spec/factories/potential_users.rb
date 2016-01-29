FactoryGirl.define do
  factory :potential_user do |f|
    f.name { Faker::Name.first_name }
    f.email { Faker::Internet.email }
    f.phone { '(' + Faker::Number.number(3) + ') ' + Faker::Number.number(3) + '-' + Faker::Number.number(4) }
    f.mortgage_statement { File.new(Rails.root.join 'spec', 'files', 'sample.png') }
  end
end