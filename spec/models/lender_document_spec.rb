require "rails_helper"

describe LenderDocument do
  before(:each) { @lender_document = FactoryGirl.build(:lender_document) }

  it "has a valid factory" do
    expect(@lender_document).to be_valid
  end

  context "missing user_id" do
    it "raises an error" do
      @lender_document.user_id = nil
      @lender_document.valid?
      expect(@lender_document.errors[:user_id]).to include("can't be blank")
    end
  end

  context "missing loan_id" do
    it "raises an error" do
      @lender_document.loan_id = nil
      @lender_document.valid?
      expect(@lender_document.errors[:loan_id]).to include("can't be blank")
    end
  end

  context "missing description" do
    it "raises an error" do
      @lender_document.description = nil
      @lender_document.valid?
      expect(@lender_document.errors[:description]).to include("can't be blank")
    end
  end
end
