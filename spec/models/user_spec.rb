require 'rails_helper'

describe User do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it 'has a valid borrower_user factory' do
    user = FactoryGirl.create(:borrower_user)

    expect(user.has_role? :borrower).to be_truthy
  end

  it 'has a valid loan_member_user factory' do
    user = FactoryGirl.create(:loan_member_user)

    expect(user.has_role? :loan_member).to be_truthy
  end
end
