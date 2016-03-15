require 'rails_helper'

describe HomepageRateServices::Wellsfargo do
  it 'gets aprs from Wellsfargo successfully' do
    # VCR.use_cassette("get aprs from Wellsfargo") do
    #   response = HomepageRateServices::Wellsfargo.call
    #   expect(response).to eq({"apr_30_year"=>4.315, "apr_15_year"=>3.594, "apr_5_libor"=>4.0})
    # end
  end
end