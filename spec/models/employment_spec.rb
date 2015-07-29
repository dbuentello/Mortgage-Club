require 'rails_helper'

describe Employment do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:employment)).to be_valid
  end
end
