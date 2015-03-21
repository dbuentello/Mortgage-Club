require 'rails_helper'

describe Borrower do 
  it 'has a valid factory' do 
    expect(FactoryGirl.create(:borrower)).to be_valid
  end 
end