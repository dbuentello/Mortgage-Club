require "rails_helper"

describe AutomateRefinanceProposalService do
  describe "#interest" do
    it "returns a correct result" do
      expect(described_class.new.interest(416000, 0.0463)).to eq(1605.0358)
    end
  end

  describe "#total_principal_payment" do
    it "returns a correct result" do
      expect(described_class.new.total_principal_payment(535.49, 0, 0)).to eq(535.49)
    end
  end
end
