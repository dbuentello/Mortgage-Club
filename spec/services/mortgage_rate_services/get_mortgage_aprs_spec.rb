require 'rails_helper'

describe MortgageRateServices::GetMortgageAprs do

  it 'GetMortgageAprs successfully' do
    VCR.use_cassette("get aprs value") do
      response = MortgageRateServices::GetMortgageAprs.call
      expect(response['zillow']['apr_30_year']).not_to eq(nil)
      expect(response['quicken_loans']['apr_15_year']).not_to eq(nil)
      expect(response['wells_fargo']['apr_5_libor']).not_to eq(nil)
      expect(response['updated_at']).not_to eq(nil)
    end
  end
end