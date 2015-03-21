require 'rails_helper'

describe Property do 
  it 'has a valid factory' do 
    expect(FactoryGirl.create(:property)).to be_valid
  end 
end
