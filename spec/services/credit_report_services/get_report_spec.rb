require "rails_helper"

describe CreditReportServices::GetReport do
  let!(:address) { FactoryGirl.create(:address, street_address: "7122 Chandler Drive", city: "Sacramento", state: "CA", zip: "95828") }
  let(:borrower) { FactoryGirl.create(:borrower, :with_user) }
  let!(:borrower_address) { FactoryGirl.create(:borrower_address, address: address, is_current: true) }

  describe ".call" do
    context "when Equifax returns data successfully" do
      it "returns a correct result" do
        VCR.use_cassette("get non-error credit report from Equifax") do
          borrower.borrower_addresses.destroy_all
          borrower_address.update(borrower: borrower)
          borrower.reload
          service = described_class.new(borrower)
          expect(service.call).not_to be_nil
        end
      end
    end
  end
end
