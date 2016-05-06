require "rails_helper"

describe CreditReportServices::GetReport do
  describe ".call" do
    context "when Equifax returns data successfully" do
      let(:args) do
        {
          borrower_id: "B1",
          first_name: "Robert",
          last_name: "Ice",
          ssn: "301423221",
          street_address: "126 4th St",
          city: "Atlanta",
          state: "GA",
          zipcode: "30014"
        }
      end

      it "returns a correct result" do
        VCR.use_cassette("get non-error credit report from Equifax") do
          service = described_class.new(args)
          expect(service.call).not_to be_nil
        end
      end
    end

    context "when Equifax returns error" do
      it "returns nil" do
        VCR.use_cassette("get error credit report from Equifax") do
          service = described_class.new({})
          expect(service.call).to be_nil
        end
      end
    end
  end
end
