require 'rails_helper'

describe PagesController do
  describe "GET index" do
    it "allows guest to view" do
      allow(HomepageRateServices::GetMortgageAprs).to receive(:call).and_return("zillow"=>{"apr_30_year"=>3.683, "apr_15_year"=>2.868, "apr_5_libor"=>2.999}, "quicken_loans"=>{"apr_30_year"=>"4.219", "apr_15_year"=>"3.52", "apr_5_libor"=>"2.764"}, "wells_fargo"=>{"apr_30_year"=>"4.2", "apr_15_year"=>"3.487", "apr_5_libor"=>"3.87"}, "updated_at"=>"2015-11-06T09:21:46.827Z")
      get :index
      expect(response.status).to eq(200)
    end
  end
end
