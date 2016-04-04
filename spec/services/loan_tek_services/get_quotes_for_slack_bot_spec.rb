require "rails_helper"

describe LoanTekServices::GetQuotesForSlackBot do
  describe "#call" do
    context "with invalid params" do
      let(:params) { {} }

      it "returns false" do
        expect(described_class.new(params).call).to be_falsey
      end
    end

    context "with valid params" do
      let(:params) do
        {
          "initial_quote" => {
            "result" => {
              "parameters" => {
                "credit_score" => 750
              },
              "contexts" => [
                {
                  "parameters" => {
                    "zipcode" => 95127,
                    "usage" => "primary_residence",
                    "property_type" => "sfh",
                    "property_value" => 450000,
                    "down_payment" => 50000,
                    "purpose" => "purchase"
                  }
                }
              ]
            }
          }
        }
      end

      it "returns true" do
        VCR.use_cassette("get quotes from LoanTek for Slackbot") do
          expect(described_class.new(params).call).to be_truthy
        end
      end
    end
  end

  describe "#quotes_summary" do
    let(:params) do
      {
        "initial_quote" => {
          "result" => {
            "parameters" => {
              "credit_score" => 750
            },
            "contexts" => [
              {
                "parameters" => {
                  "zipcode" => 95127,
                  "usage" => "primary_residence",
                  "property_type" => "sfh",
                  "property_value" => 450000,
                  "down_payment" => 50000,
                  "purpose" => "purchase"
                }
              }
            ]
          }
        }
      }
    end

    it "returns a proper summary" do
      VCR.use_cassette("get quotes from LoanTek for Slackbot") do
        service = described_class.new(params)
        service.call
        expect(service.quotes_summary).to eq("Lowest APR \n30 year fixed: 3.750% \n15 year fixed: 3.200% \n5/1 ARM: 3.460% \n")
      end
    end
  end
end
