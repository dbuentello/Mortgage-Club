require "rails_helper"

describe ActivityType do
  it { should have_many(:loan_activities) }

  it "has a valid activity type" do
    expect(FactoryGirl.build(:activity_type)).to be_valid
  end

  it "is invalid without label" do
    activity_type = ActivityType.new
    activity_type.valid?
    expect(activity_type.errors[:label]).to include("can't be blank")
  end
end
