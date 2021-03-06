require 'rails_helper'

describe Property do
  let(:property) { FactoryGirl.create(:property_with_address) }
  let(:primary_property) { FactoryGirl.create(:primary_property) }
  let(:rental_property) { FactoryGirl.create(:rental_property) }

  it 'has a valid factory' do
    expect(property).to be_valid
    expect(property.address).to be_valid
  end

  context "when purchase price's value is exceeded" do
    let(:property) { FactoryGirl.attributes_for(:property, purchase_price: 100999999999) }
    it "raises error when purchase_price exceeds maximum allowed value" do
      expect { raise Property.create(property) }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  context "when property tax's value is exceeded" do
    let(:property) { FactoryGirl.attributes_for(:property, estimated_property_tax: 110999999999) }
    it "raises error when estimated_property_tax exceeds maximum allowed value" do
      expect { raise Property.create(property) }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  context "when original purchaseprice's value is exceeded" do
    let(:property) { FactoryGirl.attributes_for(:property, original_purchase_price: 160999999999) }
    it "raises error when the original_purchase_price exceeds maximum allowed value" do
      expect { raise Property.create(property) }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  describe '.usage_name' do
    context 'when usage is nil' do
      it 'returns nil' do
        property.usage = nil
        expect(property.usage_name).to be_nil
      end
    end

    context 'when usage is valid' do
      it 'returns usage name' do
        property.usage = 1
        expect(property.usage_name).to eq('Vacation Home')
      end
    end
  end

  describe 'primary_property' do
    context 'when is_primary is true' do
      it 'property is primary' do
        expect(primary_property.is_primary).to eq(true)
      end
    end
  end

  describe 'rental_property' do
    context 'when is_rental is true' do
      it 'property is not primary' do
        expect(rental_property.is_primary).to eq(false)
      end
    end
  end
end
