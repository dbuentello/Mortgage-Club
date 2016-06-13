require "rails_helper"

describe CreditReportServices::GetReport do
  let(:loan) { FactoryGirl.create(:loan) }
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
          service = described_class.new(loan.borrower)
          expect(service.call).not_to be_nil
        end
      end
    end
  end
end
