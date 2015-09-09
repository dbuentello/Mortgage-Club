FactoryGirl.define do
  factory :loans_members_association do |f|
    loan
    loan_member { build(:loan_member) }
    f.title {['sale', 'premier_agent', 'manager'].sample}
  end
end
