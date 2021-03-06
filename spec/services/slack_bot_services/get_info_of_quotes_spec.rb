require "rails_helper"

describe SlackBotServices::GetInfoOfQuotes do
  let(:quotes) do
    [
      "DiscountPts" => -0.102,
      "LenderName" => "Provident Funding",
      "ProductName" => "15yearFixed",
      "Fees" => -1520.0,
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
      "ProductFamily" => "CONVENTIONAL"
    ]
  end

  describe ".call" do
    it "calls GetQuotesForSlackBot service" do
      expect_any_instance_of(LoanTekServices::GetQuotesForSlackBot).to receive(:call)
      described_class.call({})
    end

    context "when quotes are available" do
      before(:each) do
        allow_any_instance_of(LoanTekServices::GetQuotesForSlackBot).to receive(:call).and_return(true)
        allow_any_instance_of(LoanTekServices::GetQuotesForSlackBot).to receive(:query_content).and_return("lorem ipsum")
        allow_any_instance_of(LoanTekServices::GetQuotesForSlackBot).to receive(:quotes).and_return(quotes)
      end

      it "creates new QuoteQuery's record" do
        expect { described_class.call({}) }.to change { QuoteQuery.count }.by(1)
      end

      it "returns a correct output" do
        expect(described_class.call({})).to eq("Good news, I've found mortgage loans for you. Lowest rates as of today: \n15 year fixed: 3.750% rate, $0 origination fee, $367 lender credit\n Do you want to apply for a mortgage now? (Yes/No)")
      end
    end

    context "when quotes are not available" do
      it "returns a sorry message" do
        allow_any_instance_of(LoanTekServices::GetQuotesForSlackBot).to receive(:call).and_return(false)

        expect(described_class.call({})).to eq("We're sorry, there aren't any quotes matching your needs.")
      end
    end
  end

  describe ".summary" do
    it "returns a correct summary" do
      expect(described_class.summary(quotes)).to eq("Good news, I've found mortgage loans for you. Lowest rates as of today: \n15 year fixed: 3.750% rate, $0 origination fee, $367 lender credit\n")
    end

    context "when there are not any quotes having DiscountPts less than 0.125" do
      let(:quotes) do
        [
          "DiscountPts" => 1.0,
          "LenderName" => "Provident Funding",
          "ProductName" => "15yearFixed",
          "Fees" => -1520.0,
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
          "ProductFamily" => "CONVENTIONAL"
        ]
      end

      it "returns nil" do
        expect(described_class.summary(quotes)).to be_nil
      end
    end
  end
end
