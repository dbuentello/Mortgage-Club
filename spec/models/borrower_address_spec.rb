require 'rails_helper'

describe BorrowerAddress do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:borrower_address)).to be_valid
  end
end
