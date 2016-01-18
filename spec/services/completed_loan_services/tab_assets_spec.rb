require "rails_helper"

describe CompletedLoanServices::TabAssets do
  let(:loan) { FactoryGirl.create(:loan) }

  before(:each) do
    @loan_params = {
      assets: loan.borrower.assets,
      subject_property: nil,
      rental_properties: loan.rental_properties,
      primary_property: loan.primary_property,
      own_investment_property: loan.own_investment_property
    }

    @service = CompletedLoanServices::TabAssets.new(@loan_params)
  end

  it "returns false with subject property nil" do
    @service.subject_property = nil
    expect(@service.call).to eq(false)
  end

  describe "checks assets completed" do
  end

  describe "checks rental properties completed" do
  end

  describe "checks primary property completed" do
  end

  describe "checks subject property completed" do
  end
end
