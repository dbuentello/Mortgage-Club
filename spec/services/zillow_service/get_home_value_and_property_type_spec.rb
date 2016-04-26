require "rails_helper"

describe ZillowService::GetHomeValueAndPropertyType do
  context "with valid params" do
    it "returns a correct info" do
      VCR.use_cassette("get current home value from Zillow") do
        info = described_class.call("5045 Cedar Springs Rd", "75235")
        expect(info).to include(
          current_home_value: 114_564,
          property_type: "sfh"
        )
      end
    end
  end

  context "with invalid params" do
    it "returns a hash containing nil" do
      VCR.use_cassette("do not get current home value from Zillow when params are invalid") do
        info = described_class.call("9999 AnyWhere", "10244")
        expect(info).to include(
          current_home_value: nil,
          property_type: nil
        )
      end
    end
  end
end
