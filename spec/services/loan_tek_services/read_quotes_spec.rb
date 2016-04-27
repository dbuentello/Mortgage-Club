require "rails_helper"

describe LoanTekServices::ReadQuotes do
  let(:quotes) do
    [
      "DiscountPts" => 0.1,
      "LenderName" => "Provident Funding",
      "ProductName" => "15yearFixed",
      "Fees" => -1520.0,
      "LoanToValue" => 80,
      "FeeSet" => {
        "Created" => "0001-01-01T00:00:00",
        "Updated" => "0001-01-01T00:00:00",
        "FeeSetId" => 5776,
        "LoanAmount" => 360000.0,
        "Fees" => [
          {
            "Description" => "Loan origination fee",
            "FeeAmount" => 995.0
          },
          {
            "Description" => "Appraisal fee",
            "FeeAmount" => 495.0
          },
          {
            "Description" => "Credit report fee",
            "FeeAmount" => 25.0
          }
        ],
        "TotalFees" => 1515.0
      },
      "APR" => 3.75,
      "Rate" => 3.75,
      "ProductTerm" => "15",
      "ProductFamily" => "CONVENTIONAL",
      "MIP" => 85.0,
      "UFMIPPercent" => 0.015
    ]
  end

  describe ".call" do
    it "returns a valid array" do
      # loan purpose: purchase

      loan_purpose = 1
      programs = described_class.call(quotes, loan_purpose)
      expect(programs).to include(
        lender_name: "Provident Funding",
        product: "15 year fixed",
        apr: 0.0375,
        loan_amount: 360000.0,
        interest_rate: 0.0375,
        total_fee: 1515.0,
        fees: [
          {
            "Description" => "Loan origination fee",
            "FeeAmount" => 995.0
          },
          {
            "Description" => "Appraisal fee",
            "FeeAmount" => 495.0
          },
          {
            "Description" => "Credit report fee",
            "FeeAmount" => 25.0
          }
        ],
        period: 180,
        down_payment: 90000.0,
        monthly_payment: 2618,
        lender_credits: 0.0,
        total_closing_cost: 6915.0,
        nmls: nil,
        logo_url: nil,
        loan_type: "CONVENTIONAL",
        discount_pts: 0.0,
        pmi_monthly_premium_amount: 85.0,
        fha_upfront_premium_amount: 5400.0,
        characteristic: "Of all 15 year fixed mortgages on MortgageClub that you've qualified for, this one has the lowest APR.",
      )
    end
  end
end
