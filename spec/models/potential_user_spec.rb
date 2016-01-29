require "rails_helper"

describe PotentialUser do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:mortgage_statement) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:lender)).to be_valid
  end
end