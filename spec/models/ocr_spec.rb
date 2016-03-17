require 'rails_helper'

describe Ocr do
  let(:borrower) { FactoryGirl.build(:borrower) }

  it 'has a valid factory' do
    expect(FactoryGirl.build(:ocr)).to be_valid
  end
end
