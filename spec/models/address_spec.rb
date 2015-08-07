require 'rails_helper'

describe Address do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:address)).to be_valid
  end
end
