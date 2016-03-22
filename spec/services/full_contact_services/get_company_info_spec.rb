require "rails_helper"

describe FullContactServices::GetCompanyInfo do
  describe "#call" do
    context "with valid domain" do
      it "returns status 200" do
        VCR.use_cassette("get company info from FullContact") do
          service = described_class.new("microsoft.com")
          service.call
          expect(service.response.status).to eq(200)
        end
      end
    end
    context "with invalid domain" do
      it "returns status 422" do
        VCR.use_cassette("get company error from FullContact") do
          service = described_class.new("microsoft")
          service.call
          expect(service.response.status).to eq(422)
        end
      end
    end
  end
end
