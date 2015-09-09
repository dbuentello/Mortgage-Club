require 'rails_helper'

describe LoanMember do
  it 'has valid factory' do
    expect(FactoryGirl.build(:loan_member)).to be_valid
  end

  it 'has valid with_user factory' do
    loan_member = FactoryGirl.build(:loan_member)

    expect(loan_member).to be_valid
    expect(loan_member.first_name).to be_truthy
    expect(loan_member.last_name).to be_truthy
  end

  it 'has a valid with_loan_activites factory' do
    loan_member = FactoryGirl.build(:loan_member_with_activites)

    expect(loan_member).to be_valid
    expect(loan_member.loan_activities.size).to be >= 1
  end
end
