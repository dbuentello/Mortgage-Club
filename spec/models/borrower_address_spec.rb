require 'rails_helper'

describe BorrowerAddress do
  let(:borrower_address) { FactoryGirl.build(:borrower_address) }

  it 'has a valid factory' do
    expect(borrower_address).to be_valid
  end

  it 'has a valid factory with address object' do
    expect(borrower_address.address).to be_truthy
  end
end
