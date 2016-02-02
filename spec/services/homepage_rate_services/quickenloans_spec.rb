require 'rails_helper'

describe HomepageRateServices::Quickenloans do

  it 'gets aprs from Quickenloans successfully' do
    # VCR.use_cassette("get aprs from Quickenloans") do
    #   response = HomepageRateServices::Quickenloans.call
    #   expect(response).to eq({"apr_30_year"=>4.286, "apr_15_year"=>3.588, "apr_5_libor"=>2.845})
    # end
  end
end