require 'rails_helper'

describe RatesController do
  describe 'POST #select' do
    it 'should update the loan correctly as the json params' do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      rate_params = {
        "EntityIndex" => "4",
        "EntityName" => "Bank of America",
        "FHAUpfrontPremiumAmount" => "0",
        "LoanAmortizationTermMonths" => "30",
        "LoanTermMonths" => "360",
        "LockPeriod" => "30",
        "Margin" => "0.000",
        "MIAnnualPremiumAmount" => "0",
        "MIMonthlyPremiumAmount" => "0",
        "MIMonthlyPremiumPercent" => "0.0000",
        "MIRequiredForLoan" => "False",
        "OriginationAPR" => "3.641",
        "OriginationPandI" => "1,111",
        "OriginationTotalClosingCost" => "3648",
        "Price" => "99.201",
        "ProductCode" => "101",
        "ProductIndex" => "875308",
        "ProductName" => "30 year fixed, Jumbo",
        "Rate" => "3.625",
        "TotalMarginAdjustment" => "0",
        "TotalPriceAdjustment" => "0.25",
        "TotalRateAdjustment" => "0",
        "TotalSRPAdjustment" => "1.7"
      }

      post :select, id: loan.id, rate: rate_params, format: :html

      assign_loan = assigns(:loan)
      expect(assign_loan.lender_name).to eq(rate_params['EntityName'])
      expect(assign_loan.price).to eq(BigDecimal.new(rate_params['Price']))
      expect(assign_loan.pmi_required).to eq(false)
      expect(assign_loan.margin).to eq(BigDecimal.new(rate_params['Margin']))
    end
  end
end
