require 'rails_helper'

describe Property do
  let(:property) { FactoryGirl.create(:property_with_address) }

  it 'has a valid factory' do
    expect(property).to be_valid
    expect(property.address).to be_valid

  end

  describe '#usage_name' do
    context 'usage is nil' do
      it 'returns nil' do
        property.usage = nil
        expect(property.usage_name).to be_nil
      end
    end

    context 'usage is valid' do
      it 'returns usage name' do
        property.usage = 1
        expect(property.usage_name).to eq('Vacation Home')
      end
    end
  end

  describe '#actual_rental_income' do
    context 'gross_rental_income is present' do
      it 'returns right value' do
        property.gross_rental_income = 100
        expect(property.actual_rental_income).to eq(75)
      end
    end

    context 'gross_rental_income is nil' do
      it 'returns 0' do
        property.gross_rental_income = nil
        expect(property.actual_rental_income).to eq(0)
      end
    end
  end

  describe '#liability_payments' do
    let!(:liability) { FactoryGirl.create(:liability, property: property) }

    it 'returns sum of liability payments' do
      expect(property.liability_payments).to eq(liability.payment)
    end
  end
end
