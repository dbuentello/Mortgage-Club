require 'rails_helper'

describe Borrower do
  context 'when created default' do
    let(:borrower) { FactoryGirl.build(:borrower) }
    subject { borrower }

    it 'has a valid factory' do
      expect(borrower).to be_valid
    end

    it 'has valid associations' do
      expect(borrower.employments.count).to eq(1)
      expect(borrower.borrower_addresses.count).to eq(1)
    end
  end

  context 'when created with user' do
    let(:borrower) { FactoryGirl.build(:borrower, :with_user) }
    subject { borrower }

    it 'has documents' do
      expect(borrower.user).to be_valid
    end
  end

  context 'when created with invalid params' do
    let(:borrower) { FactoryGirl.build(:borrower, gross_income: 123123123123)}
    it 'raises error when the gross_income exceeds maximum allowed value' do
      expect { raise borrower.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end
end
