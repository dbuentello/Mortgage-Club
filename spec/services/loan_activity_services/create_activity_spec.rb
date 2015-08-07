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

  context "invalid params" do
    before(:each) do
      @loan_activity_params = {
        name: "Verify borrower's income",
        activity_type: 0,
        activity_status: 0,
        user_visible: true,
        loan_id: @loan.id,
        loan_member_id: @loan_member.id
      }
    end

    it "is invalid without a loan" do
      @loan_activity_params.delete(:loan_id)
      result = LoanActivityServices::CreateActivity.new.call(@loan_member, @loan_activity_params)

      expect(result.error_message).to eq("Loan can't be blank")
    end

    it "is invalid with a duplicated name within a loan" do
      loan_activity = FactoryGirl.create(:loan_activity)
      @loan_activity_params[:name] = loan_activity.name
      @loan_activity_params[:loan_id] = loan_activity.loan_id
      result = LoanActivityServices::CreateActivity.new.call(@loan_member, @loan_activity_params)

      expect(result.error_message).to eq("Name has already been taken")
    end

    it "raises an error with an invalid user_visible" do
      @loan_activity_params[:user_visible] = 'wrong-data'
      expect { raise LoanActivityServices::CreateActivity.new.call(@loan_member, @loan_activity_params) }.
        to raise_error(TypeError)
    end

    it "raises an error with an invalid activity_type" do
      @loan_activity_params[:activity_type] = 10
      expect { raise LoanActivityServices::CreateActivity.new.call(@loan_member, @loan_activity_params) }.
        to raise_error(ArgumentError)
    end

    it "raises an error with an invalid activity_status" do
      @loan_activity_params[:activity_status] = 10
      expect { raise LoanActivityServices::CreateActivity.new.call(@loan_member, @loan_activity_params) }.
        to raise_error(ArgumentError)
    end
  end
end
