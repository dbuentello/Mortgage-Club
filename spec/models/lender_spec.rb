require "rails_helper"

describe Lender do
  it { should have_many(:lender_template_requirements) }
  it { should have_many(:lender_templates) }
  it { should have_many(:loans) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:lock_rate_email) }
  it { should validate_uniqueness_of(:docs_email) }
  it { should validate_uniqueness_of(:contact_email) }
  it { should validate_presence_of(:contact_name) }
  it { should validate_presence_of(:contact_phone) }
  it { should validate_presence_of(:website) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:lender)).to be_valid
  end
end
