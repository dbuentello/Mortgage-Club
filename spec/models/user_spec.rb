require 'rails_helper'

describe User do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it 'has a valid staff factory' do
    staff = FactoryGirl.create(:staff)

    expect(staff.borrower).to be_nil
  end
end
