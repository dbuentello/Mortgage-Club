require 'rails_helper'

describe Envelope do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:envelope)).to be_valid
  end
end
