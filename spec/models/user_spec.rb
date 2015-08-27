require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

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

  describe '.avatar_url' do
    it "returns  avatar'url" do
      expect(user.avatar_url).to eq("/assets/avatar.png")
    end
  end
end
