require "rails_helper"

describe RateServices::UpdateLoanDataFromSelectedRate do
  let(:loan) { FactoryGirl.create(:loan) }
  let!(:lender) { FactoryGirl.create(:lender, name: "Sebonic Financial") }

  before(:each) do
    @fees = {
      "0" => {
               "HudLine" => "801",
           "Description" => "Loan origination fee",
          "IncludeInAPR" => "true",
             "FeeAmount" => "995",
               "FeeType" => "1"
      },
      "1" => {
               "HudLine" => "803",
           "Description" => "Appraisal fee",
          "IncludeInAPR" => "false",
             "FeeAmount" => "495",
               "FeeType" => "1"
      },
      "2" => {
               "HudLine" => "804",
           "Description" => "Credit report fee",
          "IncludeInAPR" => "false",
             "FeeAmount" => "25",
               "FeeType" => "1"
      },
      "3" => {
               "HudLine" => "805",
           "Description" => "Wire transfer fee",
          "IncludeInAPR" => "false",
             "FeeAmount" => "252",
               "FeeType" => "1"
      }
    }

    @lender = {
      lender_name: "Sebonic Financial",
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

      expect(loan.service_cannot_shop_fees).to eq({:fees=>[{:name=>"Appraisal fee", :amount=>495.0}, {:name=>"Credit report fee", :amount=>25.0}], :total=>520.0})
      expect(loan.origination_charges_fees).to eq({:fees=>[{:name=>"Loan origination fee", :amount=>995.0}], :total=>995.0})
      expect(loan.service_can_shop_fees).to eq({:fees=>[{:name=>"Wire transfer fee", :amount=>252.0}], :total=>252.0})
      expect(loan.lender.name).to eq("Sebonic Financial")
      expect(loan.lender_nmls_id).to eq("66247")
      expect(loan.interest_rate).to eq(0.036)
      expect(loan.amortization_type).to eq("30 year fixed")
      expect(loan.monthly_payment).to eq(1824)
      expect(loan.num_of_months).to eq(60)
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
