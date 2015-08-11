require 'rails_helper'

describe LoanMember do
  it 'has 2 valid factories' do
    expect(FactoryGirl.build(:loan_member)).to be_valid
    expect(FactoryGirl.build(:loan_member, :with_user)).to be_valid
  end

  it 'has a valid with_loan_activites factory' do
    loan_member = FactoryGirl.build(:loan_member_with_activites)
    expect(loan_member).to be_valid
    expect(loan_member.loan_activities.size).to be >= 1
  end
end
