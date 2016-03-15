require 'rails_helper'

describe Ocr do
  let(:borrower) { FactoryGirl.build(:borrower) }

  it 'has a valid factory' do
    expect(FactoryGirl.build(:ocr)).to be_valid
  end

  it 'a borrower has a ocr' do
    borrower.create_ocr
    expect(borrower.ocr.present?).to eql(true)
  end
end
