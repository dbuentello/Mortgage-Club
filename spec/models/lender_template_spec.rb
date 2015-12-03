require "rails_helper"

describe LenderTemplate do
  it { should have_many(:lender_template_requirements) }
  it { should have_many(:lenders) }
  it { should validate_presence_of(:name) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:lender_template)).to be_valid
  end
end
