require 'rails_helper'

describe LoanActivityServices::CalculateProcessingTime do
  let(:previous_loan_activity) { FactoryGirl.create(:loan_activity) }
  let(:loan_activity) { FactoryGirl.create(:loan_activity,
    loan: previous_loan_activity.loan, activity_type: previous_loan_activity.activity_type,
    name: previous_loan_activity.name, created_at: (previous_loan_activity.created_at + 1.hour)
  )}

  it "returns true with valid params" do
    result = LoanActivityServices::CalculateProcessingTime.new(loan_activity, previous_loan_activity).call
    expect(result).to eq(true)
  end

  describe ".start_switcher" do
    before(:each) { previous_loan_activity.update(activity_status: "start") }

    context "when current_activity_status is start" do
      before(:each) do
        Timecop.freeze
        loan_activity.activity_status = "start" # current_activity_status
        LoanActivityServices::CalculateProcessingTime.new(loan_activity, previous_loan_activity).call
      end

      it "sets duration to 0" do
        expect(loan_activity.duration).to eq(0)
      end
    end

    context "when current_activity_status is pause or done" do
      before(:each) do
        Timecop.freeze
        loan_activity.activity_status = "pause" # current_activity_status
        @current_time = Time.now.utc
        @next_time = Time.now.utc + 1.hour
      end

      it "updates duration with exactly value" do
        Timecop.travel(@next_time)
        LoanActivityServices::CalculateProcessingTime.new(loan_activity, previous_loan_activity).call
        expect(previous_loan_activity.duration).to eq(@next_time - @current_time)
      end
    end
  end

  describe ".pause_switcher" do
    before(:each) { previous_loan_activity.update(activity_status: "pause") }

    context "when current_activity_status is start" do
      before(:each) do
        Timecop.freeze
        loan_activity.activity_status = "start" # current_activity_status
        LoanActivityServices::CalculateProcessingTime.new(loan_activity, previous_loan_activity).call
      end
    end

    context "when current_activity_status is done" do
      it "will do something in the future"
    end
  end

  describe ".done_switcher" do
    # before(:each) { previous_loan_activity.update(activity_status: "done") }

    # context "when current_activity_status is done" do
    #   before(:each) do
    #     Timecop.freeze
    #     loan_activity.activity_status = "done" # current_activity_status
    #     LoanActivityServices::CalculateProcessingTime.new(loan_activity, @previous_loan_activity).call
    #   end
    # end
  end
end