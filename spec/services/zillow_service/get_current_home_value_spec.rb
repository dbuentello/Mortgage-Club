require "rails_helper"

describe ZillowService::GetCurrentHomeValue do
  context "with valid params" do
    it "returns a correct home value" do
      VCR.use_cassette("get current home value from Zillow") do
        current_home_value = described_class.call("5045 Cedar Springs Rd", "75235")
        expect(current_home_value).to eq(114564)
      end
    end
  end

  context "with invalid params" do
    it "returns nil" do
      current_home_value = described_class.call("9999 AnyWhere", "10244")
      expect(current_home_value).to be_nil
    end

    it "returns nil" do
      current_home_value = described_class.call("", "")
      expect(current_home_value).to be_nil
    end
  end
end
