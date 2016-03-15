FactoryGirl.define do
  factory :loan_member do |f|

    f.phone_number { '(' + Faker::Number.number(3) + ') ' + Faker::Number.number(3) + '-' + Faker::Number.number(4) }
    f.email { Faker::Internet.email }
    f.employee_id { Faker::Number.number(2) }
    f.nmls_id { Faker::Number.number(6).to_s }
    f.company_name { Faker::Company.name }
    f.company_address { Faker::Address.street_address + ", " + Faker::Address.city + ", " + Faker::Address.state}
    f.company_phone_number { '(' + Faker::Number.number(3) + ') ' + Faker::Number.number(3) + '-' + Faker::Number.number(4) }
    f.company_nmls { Faker::Number.number(6).to_s }
    f.user { create(:loan_member_user) }

    factory :loan_member_with_activites, parent: :loan_member do
      after(:build) do |loan_member, _evaluator|
        create_list(:loan_activity, Random.rand(1..3), loan_member: loan_member)
      end
    end
  end
end
