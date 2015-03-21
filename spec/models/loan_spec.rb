require 'rails_helper'

describe Loan do 
  it 'has a valid factory' do 
    expect(FactoryGirl.create(:loan)).to be_valid
  end 
end