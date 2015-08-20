require 'rails_helper'

describe ZillowService::UpdatePropertyTax do
  let(:property) { FactoryGirl.create(:property) }

  it 'updates estimated property tax successfully' do
    # http://www.zillow.com/homes/26697086_zpid/
    allow(ZillowService::GetZpid).to receive(:call).and_return('26697086')
    ZillowService::UpdatePropertyTax.call(property.id)
    property.reload
    expect(property.estimated_property_tax).to eq(2083.0)
  end
end