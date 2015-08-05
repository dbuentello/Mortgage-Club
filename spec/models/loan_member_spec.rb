require 'rails_helper'

describe LoanMember do
  it 'has 2 valid factories' do
    expect(FactoryGirl.create(:loan_member)).to be_valid
    expect(FactoryGirl.create(:loan_member_with_user)).to be_valid
  end
end
