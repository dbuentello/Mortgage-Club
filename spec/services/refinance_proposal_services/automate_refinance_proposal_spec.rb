require "rails_helper"

describe RefinanceProposalServices::AutomateRefinanceProposal do
  before(:each) { Timecop.freeze(Time.zone.local(2016, 4, 7)) }

  let(:service) do
    described_class.new(
      old_loan_amount: 416_000,
      old_interest_rate: 0.04625,
      new_interest_rate: 0.03375,
      periods: 360,
      lender_credit: -2500,
      estimated_closing_costs: 1800,
      original_interest_rate: 0.04625,
      original_loan_date: DateTime.strptime("8/20/2013", "%m/%d/%Y")
    )
  end

  describe "#ending_balance" do
    it "returns a correct result" do
      expect(service.ending_balance(0.03375 / 12, 399_004.46, 5)).to eq(395_777.46)
    end
  end

  describe "#get_monthly_payment" do
    it "returns a correct result" do
      expect(service.get_monthly_payment(0.04625 / 12, 416_000)).to eq(2_138.82)
    end
  end

  describe "#current_mortgage_balance" do
    it "returns a correct result" do
      expect(service.current_mortgage_balance).to eq(399_004.47)
    end
  end

  describe "#get_savings" do
    it "returns a correct result" do
      expect(service.get_savings(service.start_due_date + 12.months)).to eq(5_567)
    end
  end

  describe "#savings_in_one_year" do
    it "returns a correct result" do
      expect(service.savings_in_one_year).to eq(5_567)
    end
  end

  describe "#savings_in_three_years" do
    it "returns a correct result" do
      expect(service.savings_in_three_years).to eq(15_043)
    end
  end

  describe "#savings_in_ten_years" do
    it "returns a correct result" do
      expect(service.savings_in_ten_years).to eq(44_597)
    end
  end
end
