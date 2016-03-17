require 'rails_helper'

describe Borrower do
  let(:borrower) { FactoryGirl.build(:borrower) }

  it 'has a valid factory' do
    expect(borrower).to be_valid
  end

  it 'has valid associations' do
    expect(borrower.employments.count).to eq(1)
    expect(borrower.borrower_addresses.count).to eq(1)
  end

  context 'with invalid params' do
    let(:borrower) { FactoryGirl.build(:borrower, gross_income: 123123123123) }
    it 'raises error when the gross_income exceeds maximum allowed value' do
      expect { raise borrower.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  describe ".create_ocr" do
    it 'creates a new ocr record' do
      borrower.create_ocr
      expect(borrower.ocr.present?).to eql(true)
    end
  end
end
