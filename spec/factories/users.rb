FactoryGirl.define do
  factory :user do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.middle_name { Faker::Name.last_name }
    f.suffix { Faker::Name.suffix }

    f.email { Faker::Internet.email }

    f.password 'password'
    f.password_confirmation 'password'
    f.confirmed_at Time.zone.today

    factory :borrower_user do
      after(:build) do |user|
        user.add_role(:borrower)
      end
    end

    factory :loan_member_user do
      after(:build) do |user|
        user.add_role(:loan_member)
      end
    end

    factory :borrower_user_with_borrower do
      after(:build) do |user|
        user.add_role(:borrower)
        build(:borrower, user: user)
      end
    end

    factory :user_has_borrower do
      after(:build) do |user|
        user.add_role(:borrower)
        build(:borrower, user: user)
        user
      end
    end

    factory :loan_member_user_with_loan_member do
      after(:build) do |user|
        user.add_role(:loan_member)
        build(:loan_member, user: user)
      end
    end

    factory :admin do
      after(:build) do |user|
        user.add_role(:admin)
      end
    end
  end
end
