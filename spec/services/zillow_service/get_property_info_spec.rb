require 'rails_helper'

describe ZillowService::GetPropertyInfo do

  it 'gets zpid from Zillow successfully' do
    VCR.use_cassette("get property's info from Zillow") do
      property_info = ZillowService::GetPropertyInfo.call('5045 Cedar Springs Rd', '75235')
      expect(property_info[:monthlyTax]).to eq('219')
      expect(property_info[:monthlyInsurance]).to eq('110')
    end
  end
end