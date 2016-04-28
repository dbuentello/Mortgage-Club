require "rails_helper"

describe CreditReportServices::Base do
  describe ".call" do
    let(:borrower) { double("borrower", id: "B1", first_name: "Robert", last_name: "Ice", ssn: "301423221") }
    let(:address) { double("address", street_address: "126 4th Street, Atlanta, MI 49709", city: "Atlanta", state: "MI", zip: "49709") }

    it "calls CreditReportServices::GetReport" do
      expect_any_instance_of(CreditReportServices::GetReport).to receive(:call)

      described_class.call(borrower, address)
    end

    context "when Equifax returns credit report" do
      it "calls CreditReportServices::ParseReport" do
        allow_any_instance_of(CreditReportServices::GetReport).to receive(:call).and_return(["not_empty_array"])
        expect(CreditReportServices::ParseReport).to receive(:call)

        described_class.call(borrower, address)
      end
    end

    context "when Equifax does not return credit report" do
      it "returns empty" do
        allow_any_instance_of(CreditReportServices::GetReport).to receive(:call).and_return(nil)
        expect(described_class.call(borrower, address)).to be_empty
      end
    end
  end
end
