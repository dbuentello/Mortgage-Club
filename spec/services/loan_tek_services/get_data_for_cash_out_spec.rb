require "rails_helper"

describe LoanTekServices::GetDataForCashOutRefinance do
  describe "#call" do
    context "when quote is valid" do
      let(:service) { described_class.new(500_000, 400_000, "95127", 0.04625, "sfh") }

      it "returns a hash" do
        VCR.use_cassette("get quotes from LoanTek for cash out refinance") do
          expect(service.call).to eq(
            new_interest_rate_cash_out: 0.03625,
            estimated_closing_costs_cash_out: -1803,
            lender_credit_cashout: -3750.0
          )
        end
      end
    end

    context "when quotes are empty" do
      let(:service) { described_class.new(0, 0, "95127", 0.04625, "sfh") }

      it "returns nil" do
        VCR.use_cassette("get empty quotes from LoanTek for refinance proposal") do
          expect(service.call).to be_nil
        end
      end
    end

    context "when there are not any desired quotes" do
      let(:service) { described_class.new(500_000, 400_000, "95127", 0.0125, "sfh") }

      it "returns nil" do
        VCR.use_cassette("get quotes from LoanTek for cash out refinance") do
          expect(service.call).to be_nil
        end
      end
    end
  end
end
