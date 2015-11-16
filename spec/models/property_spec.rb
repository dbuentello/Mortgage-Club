require 'rails_helper'

describe Property do
  let(:property) { FactoryGirl.create(:property_with_address) }
  let (:primary_property) {FactoryGirl.create(:primary_property)}
  let(:rental_property) {FactoryGirl.create(:rental_property)}

  it 'has a valid factory' do
    expect(property).to be_valid
    expect(property.address).to be_valid
  end

  describe '.usage_name' do
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

  describe 'primary_property' do
    context 'is_primary ' do
      it 'property is primary' do
        expect(primary_property.is_primary).to eq(true)
      end
    end
  end

  describe 'rental_property' do
    context 'is_rental property' do
      it 'property is not primary' do
        expect(rental_property.is_primary).to eq(false)
      end
    end
  end

end
