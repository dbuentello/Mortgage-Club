require 'rails_helper'

describe Role do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:role)).to be_valid
  end
end
