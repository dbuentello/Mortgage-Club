require "rails_helper"

describe FacebookBotServices::GetInfoOfQuotes do
  describe ".call" do
    it "calls GetQuotesForBot service" do
      expect_any_instance_of(LoanTekServices::GetQuotesForBot).to receive(:call)
      described_class.call({})
    end

    context "when quotes are available" do
      it "creates new QuoteQuery's record" do
        allow_any_instance_of(LoanTekServices::GetQuotesForBot).to receive(:call).and_return(true)
        allow_any_instance_of(LoanTekServices::GetQuotesForBot).to receive(:query_content).and_return("lorem ipsum")
        allow_any_instance_of(LoanTekServices::GetQuotesForBot).to receive(:quotes).and_return([])

        expect { described_class.call({}) }.to change { QuoteQuery.count }.by(1)
      end
    end

    context "when quotes are not available" do
      it "returns a sorry message" do
        allow_any_instance_of(LoanTekServices::GetQuotesForBot).to receive(:call).and_return(false)

        expect(described_class.call({})).to eq("We're sorry, there aren't any quotes matching your needs.")
      end
    end
  end

  describe ".generate_output" do
    let(:quotes) do
      [
        {
          "DiscountPts" => 0.122,
          "ProductName" => "30yearFixed",
          "Fees" => -1520.0,
          "FeeSet" => {
            "FeeSetId" => 5776,
            "LoanAmount" => 360000.0,
            "TotalFees" => 1515.0
          },
          "APR" => 3.35,
          "Rate" => 3.45
        },
        {
          "DiscountPts" => 0.122,
          "ProductName" => "30yearFixed",
          "Fees" => -1520.0,
          "FeeSet" => {
            "FeeSetId" => 5776,
            "LoanAmount" => 360000.0,
            "TotalFees" => 1515.0
          },
          "APR" => 3.75,
          "Rate" => 3.75
        },
        {
          "DiscountPts" => 0.122,
          "ProductName" => "15yearFixed",
          "Fees" => -1520.0,
          "FeeSet" => {
            "FeeSetId" => 5776,
            "LoanAmount" => 360000.0,
            "TotalFees" => 1515.0
          },
          "APR" => 2.75,
          "Rate" => 2.95
        },
        {
          "DiscountPts" => 0.122,
          "ProductName" => "5yearARM",
          "Fees" => -1520.0,
          "FeeSet" => {
            "FeeSetId" => 5776,
            "LoanAmount" => 360000.0,
            "TotalFees" => 1515.0
          },
          "APR" => 2.5,
          "Rate" => 2.55
        },
      ]
    end

    let(:quote_query) { FactoryGirl.create(:quote_query, code_id: "MColEK3w") }

    it "returns a correct output" do
      expect(described_class.generate_output(quotes, quote_query)).to eq(
        [
          {
            title: "30 year fixed",
            subtitle: "3.350% rate, $0 origination fee, $439 lender credit",
            url: "http://localhost:4000/quotes/MColEK3w?program=30yearFixed"
          },
          {
            title: "15 year fixed",
            subtitle: "2.750% rate, $0 origination fee, $439 lender credit",
            url: "http://localhost:4000/quotes/MColEK3w?program=15yearFixed"
          },
          {
            title: "5/1 ARM",
            subtitle: "2.500% rate, $0 origination fee, $439 lender credit",
            url: "http://localhost:4000/quotes/MColEK3w?program=5yearARM"
          }
        ]
      )
    end
  end
end
