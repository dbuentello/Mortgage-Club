require "rails_helper"

describe LoanActivity do
  let(:loan) { FactoryGirl.create(:loan) }
  let(:loan_member) { FactoryGirl.create(:loan_member) }
  let(:loan_activity) { FactoryGirl.create(:loan_activity) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:loan_activity)).to be_valid
  end

  context "invalid params" do
    it "is invalid without a loan" do
      loan_activity = LoanActivity.new(loan_member: loan_member)
      loan_activity.valid?
      expect(loan_activity.errors[:loan]).to include("can't be blank")
    end

    it "is invalid without a loan member" do
      loan_activity = LoanActivity.new(loan: loan)
      loan_activity.valid?
      expect(loan_activity.errors[:loan_member]).to include("can't be blank")
    end

    it "raises an error with an invalid user_visible" do
      loan_activity = LoanActivity.new(
        loan: loan,
        loan_member: loan_member,
        user_visible: 'false'
      )
      expect { raise loan_activity.valid? }.to raise_error(TypeError)
    end

    it "raises an error with an invalid activity_type" do
      expect {
        raise LoanActivity.new(
          loan: loan,
          loan_member: loan_member,
          activity_type: 10
        ).valid?
      }.to raise_error(ArgumentError)
    end

    it "raises an error with an invalid activity_status" do
      expect {
        raise LoanActivity.new(
          loan: loan,
          loan_member: loan_member,
          activity_status: 10
        ).valid?
      }.to raise_error(ArgumentError)
    end
  end
end
