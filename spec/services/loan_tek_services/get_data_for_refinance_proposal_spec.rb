require "rails_helper"

describe LoanTekServices::GetDataForRefinanceProposal do
  describe "#call" do
    context "when quote is valid" do
      let(:service) { described_class.new(property_value: 500_000, loan_amount: 400_000, zipcode: "95127", original_interest_rate: 0.04625, property_type: "sfh", cash_out: false) }

      it "returns a hash" do
        VCR.use_cassette("get quotes from LoanTek for cash out refinance") do
          expect(service.call).to eq(
            interest_rate: 0.03625,
            estimated_closing_costs: -1803,
            lender_credit: -3750.0
          )
        end
      end
    end

    context "when quotes are empty" do
      let(:service) { described_class.new(property_value: 0, loan_amount: 0, zipcode: "95127", original_interest_rate: 0.04625, property_type: "sfh", cash_out: false) }

      it "returns nil" do
        VCR.use_cassette("get empty quotes from LoanTek for refinance proposal") do
          expect(service.call).to be_nil
        end
      end
    end

    context "when there are not any desired quotes" do
      let(:service) { described_class.new(property_value: 500_000, loan_amount: 400_000, zipcode: "95127", original_interest_rate: 0.0125, property_type: "sfh") }

      it "returns nil" do
        VCR.use_cassette("get quotes from LoanTek for cash out refinance") do
          expect(service.call).to be_nil
        end
      end
    end
  end
end
