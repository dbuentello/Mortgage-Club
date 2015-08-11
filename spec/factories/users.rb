FactoryGirl.define do
  factory :user do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.middle_name { Faker::Name.last_name }
    f.suffix { Faker::Name.suffix }

    f.email { Faker::Internet.email }

    f.password 'password'
    f.password_confirmation 'password'
    f.confirmed_at Date.today

    factory :borrower_user do
      after(:build) do |user|
        user.borrower = build(:borrower)
        user.add_role(:borrower)
      end
    end

    factory :loan_member_user do
      after(:build) do |user|
        user.loan_member = build(:loan_member)
        user.add_role(:loan_member)
      end
    end

  end
end
