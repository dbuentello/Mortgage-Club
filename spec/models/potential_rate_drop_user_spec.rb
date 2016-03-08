require 'rails_helper'

RSpec.describe PotentialRateDropUser, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:zip) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:potential_rate_drop_user)).to be_valid
  end
end
