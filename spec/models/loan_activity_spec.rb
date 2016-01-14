# == Schema Information
#
# Table name: loan_activities
#
#  id              :uuid             not null, primary key
#  name            :string
#  activity_type   :integer          default(0), not null
#  activity_status :integer          default(0), not null
#  user_visible    :boolean          default(FALSE), not null
#  loan_id         :uuid
#  loan_member_id  :uuid
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  duration        :integer          default(0)
#  start_date      :datetime
#  end_date        :datetime
#

require "rails_helper"

describe LoanActivity do
  let(:loan) { FactoryGirl.create(:loan) }
  let(:loan_member) { FactoryGirl.create(:loan_member) }
  let(:activity_type) { FactoryGirl.create(:activity_type) }

  context "with valid params" do
    let(:loan_activity) { FactoryGirl.create(:loan_activity) }

    it "has a valid factory" do
      expect(loan_activity).to be_valid
    end

    it "has a valid factory with loan and loan_member objects" do
      expect(loan_activity.loan).to be_valid
      expect(loan_activity.loan_member).to be_valid
    end
  end

  context "with invalid params" do
    it "is invalid without a loan" do
      loan_activity = LoanActivity.new(loan_member: loan_member, activity_type: activity_type)
      loan_activity.valid?
      expect(loan_activity.errors[:loan]).to include("can't be blank")
    end

    it "is invalid without a loan member" do
      loan_activity = LoanActivity.new(loan: loan, activity_type: activity_type)
      loan_activity.valid?
      expect(loan_activity.errors[:loan_member]).to include("can't be blank")
    end

    it "is invalid without a activity type" do
      loan_activity = LoanActivity.new(loan: loan, loan_member: loan_member)
      loan_activity.valid?
      expect(loan_activity.errors[:activity_type]).to include("can't be blank")
    end

    it "raises an error with an invalid user_visible" do
      loan_activity = LoanActivity.new(
        loan: loan,
        loan_member: loan_member,
        user_visible: 'false'
      )
      expect { raise loan_activity.valid? }.to raise_error(TypeError)
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
