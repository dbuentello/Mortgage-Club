require 'rails_helper'

describe ZillowService::GetPropertyInfo do

  it 'gets zpid from Zillow successfully' do
    VCR.use_cassette("get property's info from Zillow") do
      info = ZillowService::GetPropertyInfo.call('5045 Cedar Springs Rd', '75235')
      expect(info[:monthlyTax]).to eq('172')
      expect(info[:monthlyInsurance]).to eq('110')
    end
  end
end