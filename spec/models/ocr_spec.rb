require 'rails_helper'

describe Ocr do
  let(:borrower) { FactoryGirl.build(:borrower) }
  # let(:user) { FactoryGirl.create(:user) }

  it 'has a valid factory' do
    expect(FactoryGirl.build(:ocr)).to be_valid
  end

  it 'a borrower has a ocr' do
    ocr = borrower.create_ocr
    expect(borrower.ocr.present?).to eql(true)
  end
end
