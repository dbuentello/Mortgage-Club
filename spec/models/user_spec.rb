require 'rails_helper'

describe User do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it 'has a valid borrower_user factory' do
    loan_member = FactoryGirl.create(:borrower_user)

    expect(loan_member.borrower).to be_truthy
    expect(loan_member.loan_member).to be_nil
  end

  it 'has a valid loan_member_user factory' do
    loan_member = FactoryGirl.create(:loan_member_user)

    expect(loan_member.loan_member).to be_truthy
    expect(loan_member.borrower).to be_nil
  end
end
