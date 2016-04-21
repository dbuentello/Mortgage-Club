require "rails_helper"

describe FacebookBotServices::GetInfoOfQuotes do
  describe ".call" do
    it "calls GetQuotesForFacebookBot service" do
      expect_any_instance_of(LoanTekServices::GetQuotesForFacebookBot).to receive(:call)
      described_class.call({})
    end

    context "when quotes are available" do
      it "creates new QuoteQuery's record" do
        allow_any_instance_of(LoanTekServices::GetQuotesForFacebookBot).to receive(:call).and_return(true)
        allow_any_instance_of(LoanTekServices::GetQuotesForFacebookBot).to receive(:query_content).and_return("lorem ipsum")
        allow_any_instance_of(LoanTekServices::GetQuotesForFacebookBot).to receive(:quotes).and_return([])

        expect { described_class.call({}) }.to change { QuoteQuery.count }.by(1)
      end
    end

    context "when quotes are not available" do
      it "returns a sorry message" do
        allow_any_instance_of(LoanTekServices::GetQuotesForFacebookBot).to receive(:call).and_return(false)

        expect(described_class.call({})).to eq("{\"data\":\"Sorry, I can't find any mortgage loans for you. I've asked my human colleagues to look into it. To go back to the main menu, simply type \\\"start over\\\"!\",\"status_code\":404}")
      end
    end
  end

  describe ".generate_data" do
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
          "ProductTerm" => "30",
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
          "ProductTerm" => "30",
          "APR" => 3.75,
          "Rate" => 3.55
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
          "ProductTerm" => "15",
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
          "ProductTerm" => "5/1",
          "APR" => 2.5,
          "Rate" => 2.55
        }
      ]
    end

    let(:quote_query) { FactoryGirl.create(:quote_query, code_id: "MColEK3w") }

    it "returns a correct output" do
      expect(described_class.generate_data(quotes, quote_query)).to eq(
        [
          {
            title: "3.350% APR",
            subtitle: "Monthly Payment: $1,607, Estimated Closing Cost: $1,515",
            url: "http://localhost:4000/quotes/MColEK3w?program=30yearFixed",
            type: "30yearFixed",
            img_url: "https://s3-us-west-2.amazonaws.com/production-homieo/facebook_messenger/30_year_fixed.jpg"
          },
          {
            title: "2.750% APR",
            subtitle: "Monthly Payment: $2,477, Estimated Closing Cost: $1,515",
            url: "http://localhost:4000/quotes/MColEK3w?program=15yearFixed",
            type: "15yearFixed",
            img_url: "https://s3-us-west-2.amazonaws.com/production-homieo/facebook_messenger/15_year_fixed.jpg"
          },
          {
            title: "2.500% APR",
            subtitle: "Monthly Payment: $1,432, Estimated Closing Cost: $1,515",
            url: "http://localhost:4000/quotes/MColEK3w?program=5yearARM",
            type: "5yearARM",
            img_url: "https://s3-us-west-2.amazonaws.com/production-homieo/facebook_messenger/5_1_ARM.jpg"
          }
        ]
      )
    end
  end
end
