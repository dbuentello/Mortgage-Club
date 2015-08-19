require 'rails_helper'

describe RatesController do
  describe 'POST #select' do
    include_context 'signed in as borrower user'

    it 'updates the loan correctly as the json params' do
      loan = FactoryGirl.create(:loan, user: user)

      rate_param = {
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

      post :select, id: loan.id, rate: rate_param, format: :html

      assign_loan = assigns(:loan)
      expect(assign_loan.lender_name).to eq(rate_param['EntityName'])
      expect(assign_loan.price).to eq(BigDecimal.new(rate_param['Price']))
      expect(assign_loan.pmi_required).to eq(false)
      expect(assign_loan.margin).to eq(BigDecimal.new(rate_param['Margin']))

      expect(assign_loan.appraisal_fee).to be_truthy
      expect(assign_loan.credit_report_fee).to be_truthy
    end
  end
end
