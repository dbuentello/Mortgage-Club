require "rails_helper"

describe HomepageRate do
  it { should validate_presence_of(:lender_name) }
  it { should validate_presence_of(:program) }

  it "has a valid factory" do
    ap FactoryGirl.build(:homepage_rate)
    expect(FactoryGirl.build(:homepage_rate)).to be_valid
  end
end
