require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
    expect(user.confirmed?).to be true
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
