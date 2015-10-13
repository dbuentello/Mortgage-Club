require "rails_helper"

describe RateServices::UpdateLoanDataFromSelectedRate do
  let(:loan) { FactoryGirl.create(:loan) }

  before(:each) do
    @fees = {
      appraisal_fee: 100,
      credit_report_fee: 200,
      origination_fee: 300,
    }

    @lender = {
      name: "Sebonic Financial",
      lender_nmls_id: "66247",
      interest_rate: 0.036,
      period: 60,
      amortization_type: "30 year fixed",
      monthly_payment: 1824,
      apr: 3.625
    }
  end

  context "valid params" do
    it "updates fees & lender'rates for loan" do
      RateServices::UpdateLoanDataFromSelectedRate.call(loan.id, @fees, @lender)
      loan.reload

      expect(loan.appraisal_fee).to eq(100)
      expect(loan.credit_report_fee).to eq(200)
      expect(loan.underwriting_fee).to eq(300)
      expect(loan.lender_name).to eq("Sebonic Financial")
      expect(loan.lender_nmls_id).to eq("66247")
      expect(loan.interest_rate).to eq(0.036)
      expect(loan.amortization_type).to eq("30 year fixed")
      expect(loan.monthly_payment).to eq(1824)
      expect(loan.term_months).to eq(60)
      expect(loan.apr).to eq(3.625)
    end
  end

  context "not found loan" do
    it "writes error log for this case" do
      expect(Rails.logger).to receive(:error).with("#LoanNotFound: cannot update loan's data from selected rate. Loan id: fake-id")
      RateServices::UpdateLoanDataFromSelectedRate.call("fake-id", @fees, @lender)
    end
  end
end