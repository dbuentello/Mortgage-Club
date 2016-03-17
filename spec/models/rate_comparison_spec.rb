require "rails_helper"

describe RateComparison do
  it { should validate_presence_of(:loan_id) }
  it { should validate_presence_of(:competitor_name) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:rate_comparison)).to be_valid
  end
end
