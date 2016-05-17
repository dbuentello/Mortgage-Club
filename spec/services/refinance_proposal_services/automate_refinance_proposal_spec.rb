require "rails_helper"

describe RefinanceProposalServices::AutomateRefinanceProposal do
  before(:each) { Timecop.freeze(Time.zone.local(2016, 4, 7)) }

  let(:service) do
    described_class.new(
      old_loan_amount: 416_000,
      old_interest_rate: 0.04625,
      new_interest_rate: 0.03375,
      new_interest_rate_cash_out: 0.04,
      periods: 360,
      lender_credit: -2500,
      lender_credit_cash_out: -2500,
      estimated_closing_costs: 1800,
      estimated_closing_costs_cash_out: 1800,
      original_interest_rate: 0.04625,
      current_home_value: 600_000,
      original_loan_date: DateTime.strptime("8/20/2013", "%m/%d/%Y")
    )
  end

  describe "#call" do
    it "returns a correct hash" do
      expect(service.call).to eq(
        current_monthly_payment: 2138.82,
        current_mortgage_balance: 399004.47,
        original_interest_rate: 4.625,
        original_term: "30 years fixed",
        lower_rate_refinance: {
          new_interest_rate: 3.375,
          new_monthly_payment: 1764,
          net_closing_costs: -700,
          savings_1_year: 5567,
          savings_3_years: 15043,
          savings_10_years: 44597
        },
        cash_out_refinance: {
          cash_out: 80995,
          net_closing_costs_cash_out: 1800.0,
          monthly_payment_cash_out: 2292,
          current_home_value: 600_000,
          new_interest_rate: 4.0,
          new_loan_amount: 480000,
          net_closing_costs: 1800.0
        },
        status_code: 200
      )
    end
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
