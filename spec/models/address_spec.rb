require 'rails_helper'

describe Address do 
  it 'has a valid factory' do 
    expect(FactoryGirl.create(:address)).to be_valid
  end 
end