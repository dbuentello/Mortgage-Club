require "rails_helper"

describe RatesComparisonServices::GetRatesFromGoogle do
  let(:loan) { FactoryGirl.create(:loan) }
  let(:property) { FactoryGirl.create(:property_with_address) }
  let(:borrower) { FactoryGirl.create(:borrower_with_credit_report) }

  before(:each) do
    rates = [
      {product: "30 year fixed", apr: 2.35, lender_name: "Citibank", total_fee: 5334},
      {product: "30 year fixed", apr: 1.35, lender_name: "ConsumerDirect Mortgage", total_fee: 1214},
      {product: "15 year fixed", apr: 1.5, lender_name: "Mortgage Services Across America", total_fee: 6234},
      {product: "7/1 ARM", apr: 2.5, lender_name: "ConsumerDirect Mortgage", total_fee: 534},
      {product: "3/1 ARM", apr: 4.5, lender_name: "American Interbanc Mortgage", total_fee: 1034}
    ]
    allow_any_instance_of(Crawler::GoogleRates).to receive(:call).and_return(rates)
  end

  it "calls Crawler::GoogleRates service" do
    expect_any_instance_of(Crawler::GoogleRates).to receive(:call).exactly(4).times
    described_class.new(loan, property, borrower).call
  end

  it "saves 4 records into database" do
    expect do
      described_class.new(loan, property, borrower).call
    end.to change{RateComparison.count}.by(4)
  end
end
