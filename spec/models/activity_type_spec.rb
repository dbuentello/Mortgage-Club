require "rails_helper"

describe ActivityType do
  it { should have_many(:loan_activities)}

  it "has a valid activity type" do
    expect(FactoryGirl.build(:activity_type)).to be_valid
  end

  it "is invalid without label" do
    activity_type = ActivityType.new(type_name_mapping: ["name 1", "name 2"])
    activity_type.valid?
    expect(activity_type.errors[:label]).to include("can't be blank")
  end

  it "is invalid without type name mapping" do
    activity_type = ActivityType.new(label: "label")
    activity_type.valid?
    expect(activity_type.errors[:type_name_mapping]).to include("can't be blank")
  end
end
