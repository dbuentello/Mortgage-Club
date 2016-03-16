FactoryGirl.define do
  factory :loans_members_association do
    loan
    loan_member { build(:loan_member) }
    loan_members_title { build(:loan_members_title) }
  end
end
