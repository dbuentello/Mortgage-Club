require 'rails_helper'

describe Employment do
  let(:employment) { FactoryGirl.build(:employment) }

  it 'has a valid factory' do
    expect(employment).to be_valid
  end

  it 'has a valid factory with address object' do
    expect(employment.address).to be_truthy
  end

end
