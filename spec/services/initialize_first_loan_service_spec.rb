require "rails_helper"

describe InitializeFirstLoanService do
  let(:user) { FactoryGirl.create(:user) }

  context "when quote_cookies is present" do
    before(:each) do
      @quote_cookies = {
        mortgage_purpose: "purchase",
        property_type: "sfh",
        property_usage: "primary_residence",
        property_value: 400000
      }.to_json
    end

    it "creates a new loan" do
      expect { described_class.new(user, @quote_cookies).call }.to change{Loan.count}.by(1)
    end

    it "creates a new loan with cookies's data" do
      described_class.new(user, @quote_cookies).call

      expect(Loan.last.purpose).to eq("purchase")
      expect(Property.last.purchase_price).to eq(400000)
      expect(Property.last.property_type).to eq("sfh")
      expect(Property.last.usage).to eq("primary_residence")
    end
  end

  context "when quote_cookies is nil" do
    it "creates a new loan" do
      expect { described_class.new(user, nil).call }.to change{Loan.count}.by(1)
    end

    it "creates a new loan without cookies's data" do
      described_class.new(user, @quote_cookies).call

      expect(Loan.last.purpose).to be_nil
      expect(Property.last.purchase_price).to be_nil
      expect(Property.last.property_type).to be_nil
      expect(Property.last.usage).to be_nil
    end
  end
end
