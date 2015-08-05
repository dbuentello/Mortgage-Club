require 'rails_helper'

describe Template do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:template)).to be_valid
  end
end
