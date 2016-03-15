require 'rails_helper'

describe ZillowService::GetZpid do
  it "gets property's info from Zillow successfully" do
    VCR.use_cassette("get property's info from Zillow") do
      zpid = ZillowService::GetZpid.call('5045 Cedar Springs Rd', '75235')
      expect(zpid).to eq('26697093')
    end
  end
end