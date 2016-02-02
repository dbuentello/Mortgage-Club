require 'rails_helper'

describe HomepageRateServices::Chase do

  it 'gets aprs from Chase successfully' do
    VCR.use_cassette("get aprs from Chase") do
      # response = HomepageRateServices::Chase.call
      # expect(response).to eq({"apr_30_year" => 3.947, "apr_15_year" => 3.376, "apr_5_libor" => 3.204})
    end
  end
end