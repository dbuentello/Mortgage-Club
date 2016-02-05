require "rails_helper"

describe HomepageRateServices::GetMortgageAprs do
  describe ".get_aprs" do
    let!(:loan_tek_30) { FactoryGirl.create(:loan_tek_rate, program: "30 Year Fixed", rate_value: 2.1) }
    let!(:loan_tek_15) { FactoryGirl.create(:loan_tek_rate, program: "15 Year Fixed", rate_value: 2.2) }
    let!(:loan_tek_arm) { FactoryGirl.create(:loan_tek_rate, program: "5/1 Libor ARM", rate_value: 2.3) }

    let!(:wellsfargo_30) { FactoryGirl.create(:wellsfargo_rate, program: "30 Year Fixed", rate_value: 3.1) }
    let!(:wellsfargo_15) { FactoryGirl.create(:wellsfargo_rate, program: "15 Year Fixed", rate_value: 3.2) }
    let!(:wellsfargo_arm) { FactoryGirl.create(:wellsfargo_rate, program: "5/1 Libor ARM", rate_value: 3.3) }

    let!(:quicken_loans_30) { FactoryGirl.create(:quicken_loans_rate, program: "30 Year Fixed", rate_value: 4.1) }
    let!(:quicken_loans_15) { FactoryGirl.create(:quicken_loans_rate, program: "15 Year Fixed", rate_value: 4.2) }
    let!(:quicken_loans_arm) { FactoryGirl.create(:quicken_loans_rate, program: "5/1 Libor ARM", rate_value: 4.3) }

    it "returns default aprs with today rates empty" do
      HomepageRate.destroy_all
      result = HomepageRateServices::GetMortgageAprs.get_aprs

      loan_tek = result["loan_tek"]
      quicken_loans = result["quicken_loans"]
      wellsfargo = result["wellsfargo"]

      expect(loan_tek["apr_30_year"]).to eq(0)
      expect(loan_tek["apr_15_year"]).to eq(0)
      expect(loan_tek["apr_5_libor"]).to eq(0)

      expect(quicken_loans["apr_30_year"]).to eq(0)
      expect(quicken_loans["apr_15_year"]).to eq(0)
      expect(quicken_loans["apr_5_libor"]).to eq(0)

      expect(wellsfargo["apr_30_year"]).to eq(0)
      expect(wellsfargo["apr_15_year"]).to eq(0)
      expect(wellsfargo["apr_5_libor"]).to eq(0)
    end

    it "returns aprs with mortgage rates from database" do
      result = HomepageRateServices::GetMortgageAprs.get_aprs

      loan_tek = result["loan_tek"]
      quicken_loans = result["quicken_loans"]
      wellsfargo = result["wellsfargo"]

      expect(loan_tek["apr_30_year"]).to eq("#{loan_tek_30.rate_value}%")
      expect(loan_tek["apr_15_year"]).to eq("#{loan_tek_15.rate_value}%")
      expect(loan_tek["apr_5_libor"]).to eq("#{loan_tek_arm.rate_value}%")

      expect(quicken_loans["apr_30_year"]).to eq("#{quicken_loans_30.rate_value}%")
      expect(quicken_loans["apr_15_year"]).to eq("#{quicken_loans_15.rate_value}%")
      expect(quicken_loans["apr_5_libor"]).to eq("#{quicken_loans_arm.rate_value}%")

      expect(wellsfargo["apr_30_year"]).to eq("#{wellsfargo_30.rate_value}%")
      expect(wellsfargo["apr_15_year"]).to eq("#{wellsfargo_15.rate_value}%")
      expect(wellsfargo["apr_5_libor"]).to eq("#{wellsfargo_arm.rate_value}%")
    end
  end
end