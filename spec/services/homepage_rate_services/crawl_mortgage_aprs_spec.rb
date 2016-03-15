require "rails_helper"

describe HomepageRateServices::CrawlMortgageAprs do
  describe ".call" do
    before(:each) do
      allow(HomepageRateServices::LoanTek).to receive(:call).and_return(
        "apr_30_year" => 2.1,
        "apr_15_year" => 2.2,
        "apr_5_libor" => 2.3
      )
      allow(HomepageRateServices::Quickenloans).to receive(:call).and_return(
        "apr_30_year" => 2.4,
        "apr_15_year" => 2.5,
        "apr_5_libor" => 2.6
      )
      allow(HomepageRateServices::Wellsfargo).to receive(:call).and_return(
        "apr_30_year" => 2.7,
        "apr_15_year" => 2.8,
        "apr_5_libor" => 2.9
      )
    end

    it "returns aprs with valid values" do
      result = HomepageRateServices::CrawlMortgageAprs.call

      loan_tek = result["loan_tek"]
      quicken_loans = result["quicken_loans"]
      wellsfargo = result["wellsfargo"]

      expect(loan_tek["apr_30_year"]).to eq(2.1)
      expect(loan_tek["apr_15_year"]).to eq(2.2)
      expect(loan_tek["apr_5_libor"]).to eq(2.3)

      expect(quicken_loans["apr_30_year"]).to eq(2.4)
      expect(quicken_loans["apr_15_year"]).to eq(2.5)
      expect(quicken_loans["apr_5_libor"]).to eq(2.6)

      expect(wellsfargo["apr_30_year"]).to eq(2.7)
      expect(wellsfargo["apr_15_year"]).to eq(2.8)
      expect(wellsfargo["apr_5_libor"]).to eq(2.9)
    end
  end
end
