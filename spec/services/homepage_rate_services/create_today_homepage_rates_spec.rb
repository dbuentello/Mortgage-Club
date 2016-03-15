require "rails_helper"

describe HomepageRateServices::CreateTodayHomepageRates do
  describe ".call" do
    before(:each) do
     allow(HomepageRateServices::CrawlMortgageAprs).to receive(:call).and_return(
        "loan_tek" => {
          "apr_30_year" => 2.1,
          "apr_15_year" => 2.2,
          "apr_5_libor" => 2.3
        },
        "quicken_loans" => {
          "apr_30_year" => 2.4,
          "apr_15_year" => 2.5,
          "apr_5_libor" => 2.6
        },
        "wellsfargo" => {
          "apr_30_year" => 2.7,
          "apr_15_year" => 2.8,
          "apr_5_libor" => 2.9
        },
        "updated_at" => Time.zone.now
      )
    end

    it "save new data with valid value" do
      HomepageRateServices::CreateTodayHomepageRates.call

      expect(HomepageRate.count).to eq(9)
    end

    context "with exist rate in database" do
      let!(:loan_tek_30) { FactoryGirl.create(:loan_tek_rate, program: "30 Year Fixed", rate_value: 2.0) }

      it "saves correct data" do
        HomepageRateServices::CreateTodayHomepageRates.call
        loan_tek_rate = HomepageRate.find_by(program: "30 Year Fixed", lender_name: "Mortgage Club")

        expect(loan_tek_rate.rate_value).to eq(2.1)
      end
    end
  end
end