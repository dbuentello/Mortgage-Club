require 'rails_helper'

describe LoanActivityServices::CreateActivity do
  before(:each) do
    @loan_member = FactoryGirl.create(:loan_member)
    @loan = FactoryGirl.create(:loan)
  end

  context "valid params" do
    before(:each) do
      @loan_activity_params = {
        name: "Verify borrower's income",
        activity_type: 0,
        activity_status: 0,
        user_visible: true,
        loan_id: @loan.id,
        loan_member_id: @loan_member.id
      }
      @result = LoanActivityServices::CreateActivity.new.call(@loan_member, @loan_activity_params)
    end

    it "creates loan activity successfully" do
      expect(LoanActivity.count).to eq(1)
    end

    it "runs successfully" do
      expect(@result.success?).to eq(true)
    end

    it "returns error message with nil value" do
      expect(@result.error_message).to be_nil
    end
  end
end
