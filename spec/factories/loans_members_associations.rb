FactoryGirl.define do
  factory :loans_members_association do |f|
    loan
    loan_member { build(:loan_member) }
  end
end
