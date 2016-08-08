require 'rails_helper'

RSpec.describe LenderDocusignForm, type: :model do
  before(:each) { @lender_docsign_form = FactoryGirl.build(:lender_docusign_form) }

  it { should belong_to(:lender) }
  it { should validate_presence_of(:attachment) }
  it { should validate_presence_of(:lender_id) }

  it "has not a valid factory" do
    expect(@lender_docsign_form).to_not be_valid
  end
end
