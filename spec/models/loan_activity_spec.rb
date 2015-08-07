require 'rails_helper'

describe LoanActivity do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:loan_activity)).to be_valid
  end
end
