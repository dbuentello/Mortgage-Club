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

  context 'when created with documents' do
    let(:borrower) { FactoryGirl.build(:borrower_with_documents) }
    subject { borrower }

    it 'has documents' do
      expect(borrower.first_w2).to be_valid
      expect(borrower.second_w2).to be_valid
      expect(borrower.first_paystub).to be_valid
      expect(borrower.second_paystub).to be_valid
      expect(borrower.first_bank_statement).to be_valid
      expect(borrower.second_bank_statement).to be_valid
    end
  end

  context 'when created with user' do
    let(:borrower) { FactoryGirl.build(:borrower, :with_user) }
    subject { borrower }

    it 'has documents' do
      expect(borrower.user).to be_valid
    end
  end
end
