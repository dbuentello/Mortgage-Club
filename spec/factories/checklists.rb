FactoryGirl.define do
  factory :checklist do |f|
    loan
    template
    user { create(:loan_member_user_with_loan_member) }

    f.name { Faker::Lorem.sentence }
    f.document_description { Faker::Lorem.sentence }
    f.info { Faker::Lorem.sentence }
    f.due_date { Faker::Date.forward(10) }
    f.status { 'pending' }
    f.document_type { 'first_w2' }
    f.subject_name { 'Borrower' }
    f.checklist_type { 'explain' }

    factory :checklist_explain do
      checklist_type { 'explain' }
      question { Faker::Lorem.sentence }
    end

    factory :checklist_upload do
      checklist_type { 'upload' }
    end
  end
end
