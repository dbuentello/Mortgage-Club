require "rails_helper"

describe RatesComparisonServices::Base do
  let(:loan) { FactoryGirl.create(:loan_with_properties) }
  let(:user) { FactoryGirl.create(:borrower_user) }

  before(:each) do
    rates = [
      {product: "30 year fixed", apr: 2.35, lender_name: "Citibank", total_fee: 5334},
      {product: "30 year fixed", apr: 1.35, lender_name: "ConsumerDirect Mortgage", total_fee: 1214},
      {product: "15 year fixed", apr: 1.5, lender_name: "Mortgage Services Across America", total_fee: 6234},
      {product: "7/1 ARM", apr: 2.5, lender_name: "ConsumerDirect Mortgage", total_fee: 534},
      {product: "3/1 ARM", apr: 4.5, lender_name: "American Interbanc Mortgage", total_fee: 1034}
    ]
    allow_any_instance_of(Crawler::GoogleRates).to receive(:call).and_return(rates)

    @crawler = Crawler::GoogleRates.new({
      purpose: "purchase",
      zipcode: 95127,
      property_value: 33322,
      credit_score: 650,
      monthly_payment: 2341,
      purchase_price: 23232,
      market_price: 22323,
      balance: 342
    })
  end

  describe "#get_rates" do
    it "returns a proper hash" do
      expect(described_class.new(loan.id, user.id).get_rates(40000, @crawler)).to match_response_schema("rates_comparison")
    end
  end
end
