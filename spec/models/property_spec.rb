require 'rails_helper'

describe Property do
  let(:property) { FactoryGirl.create(:property) }

  it 'has a valid factory' do
    expect(property).to be_valid
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
end
