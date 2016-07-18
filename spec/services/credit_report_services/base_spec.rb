require "rails_helper"

describe CreditReportServices::Base do
  describe ".call" do
    let(:loan) { FactoryGirl.create(:loan_with_all_associations) }

    it "calls CreditReportServices::GetReport" do
      expect_any_instance_of(CreditReportServices::GetReport).to receive(:call)

      described_class.call(loan)
    end

    context "when Equifax returns credit report" do
      it "calls CreditReportServices::CreateLiabilities" do
        allow_any_instance_of(CreditReportServices::GetReport).to receive(:call).and_return(["not_empty_array"])
        allow(CreditReportServices::SaveCreditReportAsPdf).to receive(:call).and_return(nil)
        expect(CreditReportServices::CreateLiabilities).to receive(:call)

        described_class.call(loan)
      end
    end
  end
end
