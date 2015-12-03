require "rails_helper"

describe LenderDocument do
  before(:each) { @lender_document = FactoryGirl.build(:lender_document) }

  it { should belong_to(:loan) }
  it { should belong_to(:user) }
  it { should belong_to(:lender_template) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:loan_id) }
  it { should validate_presence_of(:lender_template_id) }
  it { should validate_presence_of(:description) }

  it "has a valid factory" do
    expect(@lender_document).to be_valid
  end
end
