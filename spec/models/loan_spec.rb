require 'rails_helper'

describe Loan do
  let(:loan) { FactoryGirl.create(:loan) }

  it 'has a valid factory' do
    expect(loan).to be_valid
  end

  it 'has a valid with_loan_activites factory' do
    loan = FactoryGirl.build(:loan_with_activites)
    expect(loan).to be_valid
    expect(loan.loan_activities.size).to be >= 1
  end

  describe '.ltv_formula' do
    context 'property or amount is nil' do
      it 'returns nil' do
        expect(loan.ltv_formula).to be_nil
      end
    end

    context 'property and amount are valid' do
      before(:each) do
        @property = FactoryGirl.create(:property)
        loan.property = @property
      end

      it 'returns ltv_formula value' do
        expected_value = (loan.amount / @property.purchase_price * 100).ceil
        expect(loan.ltv_formula).to eq(expected_value)
      end
    end
  end

  describe '.num_of_years' do
    context 'num_of_months is nil' do
      it 'returns nil' do
        loan.num_of_months = nil
        expect(loan.num_of_years).to be_nil
      end
    end

    context 'num_of_months is a valid number' do
      it 'returns number of years' do
        loan.num_of_months = 24
        expect(loan.num_of_years).to eq(2)
      end
    end
  end

  describe '.purpose_titleize' do
    context 'purpose is nil' do
      it 'returns nil' do
        loan.purpose = nil
        expect(loan.purpose_titleize).to be_nil
      end
    end

    context 'purpose is valid' do
      it 'returns number of years' do
        loan.purpose = 1
        expect(loan.purpose_titleize).to eq('Refinance')
      end
    end
  end

  describe '.relationship_manager' do
    let(:loan_with_loan_member) { FactoryGirl.create(:loan_with_loan_member) }

    context 'loans_members_associations are empty' do
      it 'returns nil if there is not any loans members associations' do
        loan.loans_members_associations = []
        expect(loan.relationship_manager).to be_nil
      end
    end

    context 'non existing relationship manager' do
      it 'returns nil' do
        loan_with_loan_member.loans_members_associations.last.update(title: 'sale')
        expect(loan_with_loan_member.relationship_manager).to be_nil
      end
    end

    context 'loans_members_associations are valid' do
      it 'returns a loan member' do
        loan_with_loan_member.loans_members_associations.last.update(title: 'manager')
        expect(loan_with_loan_member.relationship_manager).to be_a(LoanMember)
      end
    end
  end
end
