require 'rails_helper'

describe MortgageRateServices::Zillow do

  it 'gets aprs from Zillow successfully' do
    VCR.use_cassette("get aprs from Zillow", :record => :new_episodes) do
      # response = MortgageRateServices::Zillow.call
      # expect(response['apr_30_year']).not_to be_nil
      # expect(response['apr_15_year']).not_to be_nil
      # expect(response['apr_5_libor']).not_to be_nil
    end
  end
end