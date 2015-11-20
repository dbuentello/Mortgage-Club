require 'rails_helper'

describe MortgageRateServices::Chase do

  it 'gets aprs from Chase successfully' do
    VCR.use_cassette("get aprs from Chase") do
      response = MortgageRateServices::Chase.call
      expect(response).to eq({"apr_30_year"=>0, "apr_15_year"=>0, "apr_5_libor"=>0})
    end
  end
end