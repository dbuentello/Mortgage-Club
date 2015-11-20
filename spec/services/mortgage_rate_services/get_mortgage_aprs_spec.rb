require 'rails_helper'

describe MortgageRateServices::GetMortgageAprs do

  it 'GetMortgageAprs successfully' do
    VCR.use_cassette("get aprs value") do
      response = MortgageRateServices::GetMortgageAprs.call
      expect(response['zillow']['apr_30_year']).not_to be_nil
      expect(response['quicken_loans']['apr_15_year']).not_to be_nil
      expect(response['chase']['apr_5_libor']).not_to be_nil
      expect(response['updated_at']).not_to be_nil
    end
  end
end