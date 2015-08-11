FactoryGirl.define do
  factory :loan_activity do |f|
    loan
    loan_member

    f.name { Faker::Lorem.word }
    f.activity_type { ['loan_submission', 'loan_doc', 'closing', 'post_closing'].sample }
    f.activity_status { ['start', 'done', 'pause'].sample }
    f.user_visible { [true, false].sample }
    f.duration { 0 }
  end
end
