FactoryGirl.define do
  factory :loan_member do |f|

    f.phone_number { Faker::PhoneNumber.cell_phone }
    f.skype_handle { Faker::Internet.email }
    f.email { Faker::Internet.email }
    f.employee_id { Faker::Number.number(2) }
    f.nmls_id { Faker::Number.number(6) }
    f.user { create(:loan_member_user) }

    factory :loan_member_with_activites, parent: :loan_member do |f|
      after(:build) do |loan_member, evaluator|
        create_list(:loan_activity, Random.rand(1..3), loan_member: loan_member)
      end
    end

  end
end
