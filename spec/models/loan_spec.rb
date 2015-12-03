require 'rails_helper'

describe Loan do
  let(:loan) { FactoryGirl.create(:loan) }
  it { should have_many(:properties) }
  it { should have_many(:envelopes) }
  it { should have_many(:documents) }
  it { should have_many(:loan_activities) }
  it { should have_many(:loans_members_associations) }
  it { should have_many(:loan_members) }
  it { should have_many(:checklists) }
  it { should have_many(:lender_documents) }
  it { should belong_to(:lender) }

  it 'has a valid factory' do
    expect(loan).to be_valid
  end

  it 'has a valid with_loan_activites factory' do
    loan = FactoryGirl.build(:loan_with_activites)
    expect(loan).to be_valid
    expect(loan.loan_activities.size).to be >= 1
  end

  describe '.primary_property' do
    context 'primary_property is nil' do
      it 'returns nil' do
        expect(loan.primary_property).to be_nil
      end
    end

    context 'loan has primary_property' do
      before(:each) do
        @loan = FactoryGirl.create(:loan_with_properties)
      end

      it 'returns primary_property value' do
        expect(@loan.primary_property).not_to be_nil
      end
    end
  end

  describe '.rental_properties' do
    context 'rental_properties is nil' do
      it 'returns nil' do
        expect(loan.rental_properties).to eq([])
      end
    end

    context 'loan has rental_properties' do
      before(:each) do
        @loan = FactoryGirl.create(:loan_with_properties)
      end

      it 'returns rental_properties value' do
        expect(@loan.rental_properties).not_to be_nil
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
