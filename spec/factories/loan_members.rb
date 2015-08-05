FactoryGirl.define do
  factory :loan_member do |f|

    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.middle_name { Faker::Name.last_name }
    f.phone_number { Faker::PhoneNumber.cell_phone }
    f.skype_handle { Faker::Internet.email }
    f.email { Faker::Internet.email }
    f.employee_id { Faker::Number.number(2) }
    f.nmls_id { Faker::Number.number(6) }

    factory :loan_member_with_user do
      user
    end

  end
end
